# frozen_string_literal: true

class TradingCalendarParser < Restorm::Middleware::FirstLevelParseJSON
  def parse(body)
    json = parse_json(body)
    errors = json.delete(:detail) || {}
    metadata = json.delete(:metadata) || {}

    {
      data: json,
      errors:,
      metadata:
    }
  end
end

Restorm::API.setup url: ENV.fetch('TRADING_CALENDAR_API_URL', 'https://trading-calendar.fly.dev/api/v1') do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  # c.use Restorm::Middleware::DefaultParseJSON
  c.use TradingCalendarParser

  # Adapter
  c.adapter Faraday::Adapter::NetHttp
end
