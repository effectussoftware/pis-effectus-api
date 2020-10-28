# frozen_string_literal: true

set :output, { error: 'log/cron_error_log.log', standard: 'log/cron_log.log' }

every '5 * * * *' do
  rake 'push_notifications:send_to_recurrent_communications', environment: 'development'
end
