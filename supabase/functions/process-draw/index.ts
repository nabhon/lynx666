// Supabase Edge Function: Process Lottery Draw
// Run this function every 2 hours via cron schedule

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create Supabase client with service role key (admin access)
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        global: { headers: { Authorization: req.headers.get('Authorization')! } },
      }
    )

    console.log('Starting lottery draw processing...')

    // Get all pending draws that should have been processed
    const { data: pendingDraws, error: fetchError } = await supabase
      .from('lottery_draws')
      .select('*')
      .eq('status', 'PENDING')
      .lte('scheduled_time', new Date().toISOString())
      .order('scheduled_time', { ascending: true })

    if (fetchError) {
      console.error('Error fetching pending draws:', fetchError)
      throw fetchError
    }

    if (!pendingDraws || pendingDraws.length === 0) {
      console.log('No pending draws to process')
      return new Response(
        JSON.stringify({ success: true, message: 'No pending draws', processed: 0 }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        }
      )
    }

    console.log(`Found ${pendingDraws.length} pending draw(s) to process`)

    const results = []

    // Process each pending draw
    for (const draw of pendingDraws) {
      console.log(`Processing draw: ${draw.id}, scheduled: ${draw.scheduled_time}`)

      // Call the database function to process the draw
      const { data: result, error: processError } = await supabase.rpc(
        'process_lottery_draw',
        { draw_id: draw.id }
      )

      if (processError) {
        console.error(`Error processing draw ${draw.id}:`, processError)
        results.push({
          draw_id: draw.id,
          success: false,
          error: processError.message,
        })
        continue
      }

      console.log(`Draw ${draw.id} processed successfully:`, result)
      results.push({
        draw_id: draw.id,
        success: true,
        result: result,
      })
    }

    const successCount = results.filter((r) => r.success).length

    return new Response(
      JSON.stringify({
        success: true,
        message: `Processed ${successCount}/${pendingDraws.length} draws`,
        processed: successCount,
        total: pendingDraws.length,
        results: results,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Error in process-draw function:', error)
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
