# frozen_string_literal: true

require 'mechanize'

module Holdings
  class UnknownStrategyError < StandardError; end

  class Extractor
    attr_reader :fund

    def initialize(fund)
      @fund = fund
      return if fund.holdings_file.attached?
      raise unless file_via_agent.code == '200'

      fund.holdings_file.attach(io: file_via_agent.body_io, filename: file_via_agent.filename, content_type: file_via_agent.response['content_type'])
      fund.save
    end

    def extract_holdings
      Holding.transaction do
        strategy.extract

        fund.save! if fund.holdings.any?
        Rails.logger.info("#{fund.name} saved, holdings: #{fund.holdings.count}")
      end
    end

    private

    def strategy
      @strategy ||= case fund.holdings_file.content_type
                    when 'text/csv'
                      Holdings::ExtractionStrategies::CSV.new(fund)
                    when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                      Holdings::ExtractionStrategies::Excel.new(fund)
                    else
                      raise UnknownStrategyError, fund.holdings_file
                    end
    end

    def file_via_agent
      agent.get(fund.public_url)
      agent.click(agent.page.link_with!(text: fund.manager.holdings_link_text))
    end

    def agent
      @agent ||= ::Mechanize.new do |agent|
        agent.user_agent_alias = 'iPhone'
        agent.pluggable_parser.default = Mechanize::Download
      end
    end
  end
end
