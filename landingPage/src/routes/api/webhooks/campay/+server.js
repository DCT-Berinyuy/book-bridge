import { json } from '@sveltejs/kit';
import { createClient } from '@supabase/supabase-js';
import { env } from '$env/dynamic/private';

const supabase = createClient(
	env.SUPABASE_URL,
	env.SUPABASE_SERVICE_ROLE_KEY
);

export async function POST({ request }) {
	// 1. Verify Authentication (CamPay uses an "App webhook key" for security)
	const webhookKey = request.headers.get('Authorization') || request.headers.get('x-campay-webhook-key');
	
	if (webhookKey !== env.CAMPAY_WEBHOOK_KEY) {
		console.error('CamPay Webhook: Invalid Webhook Key');
		return json({ error: 'Unauthorized' }, { status: 401 });
	}

	try {
		const payload = await request.json();
		const { status, reference, amount, currency, external_reference } = payload;

		console.log(`CamPay Webhook received: ${reference} - Status: ${status}`);

		if (status === 'SUCCESSFUL') {
			// Check if it's a Boost or a Donation using the external_reference
			// We usually prefix it like "boost:listing_uuid" or "donation:user_uuid"
			
			if (external_reference.startsWith('boost:')) {
				const listingId = external_reference.split(':')[1];
				const duration = external_reference.split(':')[2] || '7'; // default to 7 days
				
				await handleBoostSuccess(listingId, reference, amount, duration);
			} else if (external_reference.startsWith('donation:')) {
				const userId = external_reference.split(':')[1];
				await handleDonationSuccess(userId, reference, amount);
			}
		} else if (status === 'FAILED') {
			await updatePaymentStatus(external_reference, 'failed');
		}

		return json({ success: true });
	} catch (err) {
		console.error('CamPay Webhook Error:', err);
		return json({ error: 'Internal Server Error' }, { status: 500 });
	}
}

async function handleBoostSuccess(listingId, reference, amount, duration) {
	const expiresAt = new Date();
	expiresAt.setDate(expiresAt.getDate() + parseInt(duration));

	// 1. Update listing
	const { error: listingError } = await supabase
		.from('listings')
		.update({
			is_boosted: true,
			boost_expires_at: expiresAt.toISOString()
		})
		.eq('id', listingId);

	if (listingError) throw listingError;

	// 2. Update boost payment record
	const { error: paymentError } = await supabase
		.from('boost_payments')
		.update({ status: 'successful' })
		.eq('payment_reference', reference);
    
    // Note: If record doesn't exist (race condition), we'll skip for now 
    // or we should have created it when initiating.
}

async function handleDonationSuccess(userId, reference, amount) {
	const { error } = await supabase
		.from('donations')
		.update({ status: 'successful' })
		.eq('payment_reference', reference);
    
    if (error) console.error('Donation update error:', error);
}

async function updatePaymentStatus(external_reference, status) {
    // Basic status update logic
    if (external_reference.startsWith('boost:')) {
        // ... update boost_payments set status = failed ...
    }
}
