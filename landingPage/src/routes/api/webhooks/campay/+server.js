import { json } from '@sveltejs/kit';
import { createClient } from '@supabase/supabase-js';
import { env } from '$env/dynamic/private';

const supabase = createClient(
	env.SUPABASE_URL,
	env.SUPABASE_SERVICE_ROLE_KEY
);

export async function POST({ request }) {
	// 1. Verify Authentication
	const authHeader = request.headers.get('Authorization') || '';
	const webhookKeyHeader = request.headers.get('x-campay-webhook-key');
	
	// Handle "Bearer <key>" format common in many gateways
	const providedKey = webhookKeyHeader || authHeader.replace('Bearer ', '').trim();
	
	if (providedKey !== env.CAMPAY_WEBHOOK_KEY) {
		console.error('CamPay Webhook: Invalid Webhook Key', { providedKey, expected: env.CAMPAY_WEBHOOK_KEY });
		return json({ error: 'Unauthorized' }, { status: 401 });
	}

	try {
		const payload = await request.json();
		const { status, reference, amount, currency, external_reference } = payload;

		console.log(`CamPay Webhook received: ${reference} - Status: ${status} - External: ${external_reference}`);

		if (status === 'SUCCESSFUL') {
			if (external_reference && external_reference.startsWith('boost:')) {
				const [_, listingId, duration] = external_reference.split(':');
				await handleBoostSuccess(listingId, reference, amount, duration || '7');
			} else if (external_reference && external_reference.startsWith('donation:')) {
				const [_, userId] = external_reference.split(':');
				await handleDonationSuccess(userId, reference, amount);
			}
		} else {
			console.log(`CamPay Payment ${status}: ${reference}`);
		}

		return json({ success: true });
	} catch (err) {
		console.error('CamPay Webhook Error:', err);
		return json({ error: err.message }, { status: 500 });
	}
}

async function handleBoostSuccess(listingId, reference, amount, duration) {
	const expiresAt = new Date();
	expiresAt.setDate(expiresAt.getDate() + parseInt(duration));

	console.log(`Processing boost for listing ${listingId}`);

	// 1. Get the seller_id from the listing
	const { data: listing, error: fetchError } = await supabase
		.from('listings')
		.select('seller_id')
		.eq('id', listingId)
		.single();

	if (fetchError || !listing) {
		console.error('Error fetching listing for boost:', fetchError);
		throw new Error('Listing not found');
	}

	const userId = listing.seller_id;

	// 2. Update listing visibility
	const { error: listingError } = await supabase
		.from('listings')
		.update({
			is_boosted: true,
			boost_expires_at: expiresAt.toISOString()
		})
		.eq('id', listingId);

	if (listingError) {
		console.error('Error updating listing visibility:', listingError);
		throw listingError;
	}

	// 3. Upsert boost payment record
	const { error: paymentError } = await supabase
		.from('boost_payments')
		.upsert({
			payment_reference: reference,
			listing_id: listingId,
			user_id: userId,
			amount: parseInt(amount),
			duration_days: parseInt(duration),
			status: 'successful',
			created_at: new Date().toISOString()
		}, { onConflict: 'payment_reference' });
    
    if (paymentError) {
		console.error('Error recording boost payment:', paymentError);
		throw paymentError;
	}
	
	console.log(`Successfully boosted listing ${listingId} for user ${userId}`);
}

async function handleDonationSuccess(userId, reference, amount) {
	console.log(`Processing donation from user ${userId}`);
	
	const { error } = await supabase
		.from('donations')
		.upsert({
			payment_reference: reference,
			user_id: userId === 'anonymous' ? null : userId,
			amount: parseInt(amount),
			status: 'successful',
			created_at: new Date().toISOString()
		}, { onConflict: 'payment_reference' });
    
    if (error) {
		console.error('Donation record error:', error);
		throw error;
	}
}
