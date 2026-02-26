import { json } from '@sveltejs/kit';
import { createClient } from '@supabase/supabase-js';
import { env } from '$env/dynamic/private';

let supabase;

function getSupabase() {
	if (!supabase && env.SUPABASE_URL && env.SUPABASE_SERVICE_ROLE_KEY) {
		supabase = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY);
	}
	return supabase;
}

// Health check endpoint
export async function GET() {
	return json({ 
		status: 'alive', 
		time: new Date().toISOString(),
		config_check: {
			has_url: !!env.SUPABASE_URL,
			has_key: !!env.SUPABASE_SERVICE_ROLE_KEY,
			has_webhook_key: !!env.FAPSHI_WEBHOOK_KEY
		}
	});
}

export async function POST({ request }) {
	const timestamp = new Date().toISOString();
	console.log(`[${timestamp}] Fapshi Webhook received`);

	// 1. Log Headers for debugging
	const headers = Object.fromEntries(request.headers.entries());
	console.log(`[${timestamp}] Headers:`, JSON.stringify(headers));

	// 2. Verify Authentication
	// Fapshi might use a specific header, but we'll support both custom header and Authorization
	const authHeader = request.headers.get('Authorization') || '';
	const webhookKeyHeader = request.headers.get('x-fapshi-webhook-key');
	const providedKey = webhookKeyHeader || authHeader.replace('Bearer ', '').trim();
	
	// We allow bypassing key check if FAPSHI_WEBHOOK_KEY is not set for easy testing, 
	// but highly recommend in production.
	if (env.FAPSHI_WEBHOOK_KEY && env.FAPSHI_WEBHOOK_KEY !== 'PLACEHOLDER_WEBHOOK_KEY_CREATE_LATER' && providedKey !== env.FAPSHI_WEBHOOK_KEY) {
		console.error(`[${timestamp}] Unauthorized: Provided ${providedKey} vs Expected ${env.FAPSHI_WEBHOOK_KEY}`);
		return json({ error: 'Unauthorized', debug_received: providedKey }, { status: 401 });
	}

	try {
		const payload = await request.json();
		console.log(`[${timestamp}] Payload:`, JSON.stringify(payload));
		
		// Fapshi typically sends transId, status, amount, externalId
		const status = payload.status || payload.state;
		const reference = payload.transId || payload.transactionId || payload.id;
		const amount = payload.amount;
		const external_reference = payload.externalId || payload.externalReference || payload.custom;

		if (status === 'SUCCESSFUL' || status === 'SUCCESS') {
			if (external_reference && (external_reference.startsWith('boost:') || external_reference.startsWith('boost_'))) {
				const separator = external_reference.includes(':') ? ':' : '_';
				const parts = external_reference.split(separator);
				const listingId = parts[1];
				const duration = parts[2] || '7';
				
				console.log(`[${timestamp}] Processing boost: Listing=${listingId}, Duration=${duration}`);
				await handleBoostSuccess(listingId, reference, amount, duration);
			} else if (external_reference && (external_reference.startsWith('donation:') || external_reference.startsWith('donation_'))) {
				const separator = external_reference.includes(':') ? ':' : '_';
				const parts = external_reference.split(separator);
				const userId = parts[1];
				await handleDonationSuccess(userId, reference, amount);
			} else {
				console.warn(`[${timestamp}] Unknown externalId format: ${external_reference}`);
			}
		} else {
			console.log(`[${timestamp}] Payment ${status} for ref ${reference}`);
		}

		return json({ success: true, processed_at: timestamp });
	} catch (err) {
		console.error(`[${timestamp}] Webhook Error:`, err);
		return json({ error: err.message, stack: err.stack }, { status: 500 });
	}
}

async function handleBoostSuccess(listingId, reference, amount, duration) {
	const expiresAt = new Date();
	expiresAt.setDate(expiresAt.getDate() + parseInt(duration));

	console.log(`Processing boost for listing ${listingId}`);

	// 1. Get the seller_id from the listing
	const supabase = getSupabase();
	if (!supabase) throw new Error('Supabase client not initialized');

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
	
	const supabase = getSupabase();
	if (!supabase) throw new Error('Supabase client not initialized');

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
