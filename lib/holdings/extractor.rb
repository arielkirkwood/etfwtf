# frozen_string_literal: true

require 'mechanize'

module Holdings
  class UnknownStrategyError < StandardError; end

  class Extractor
    attr_accessor :fund, :holdings

    def initialize(fund)
      @fund = fund
    end

    def extract_holdings
      Holding.transaction do
        self.holdings = strategy.extract(holdings_file)

        fund.save! if holdings.any?
        Rails.logger.info("#{fund.name} saved, holdings: #{holdings.count}")
      # rescue ActiveRecord::RecordInvalid => e
      #   debugger
      end
    end

    private

    def strategy
      @strategy ||= case holdings_file
                    when Holdings::Files::CSV
                      Holdings::ExtractionStrategies::CSV.new(fund)
                    when Holdings::Files::OpenXML
                      Holdings::ExtractionStrategies::Excel.new(fund)
                    else
                      raise UnknownStrategyError, "#{holdings_file.class} found at #{agent.page.url}"
                    end
    end

    def holdings_file
      @holdings_file ||= refresh_holdings_file_via_agent
    end

    def refresh_holdings_file_via_agent
      agent.get(fund.public_url)
      agent.click(agent.page.link_with!(text: fund.manager.holdings_link_text))
    end

    def agent
      @agent ||= ::Mechanize.new do |agent|
        agent.user_agent_alias = 'iPhone'
        agent.pluggable_parser.csv = Holdings::Files::CSV
        agent.pluggable_parser.xml = Holdings::Files::OpenXML
        agent.pluggable_parser['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'] = Holdings::Files::OpenXML
      end
    end
  end
end
