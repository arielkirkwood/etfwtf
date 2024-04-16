# frozen_string_literal: true

Restorm::API.setup url: ENV.fetch('TRADING_CALENDAR_API_URL', 'https://trading-calendar.fly.dev/api/v1') do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use Restorm::Middleware::DefaultParseJSON

  # Adapter
  c.adapter Faraday::Adapter::NetHttp
end
