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
        self.holdings = holdings_via_strategy

        Rails.logger.info("#{fund.name} holdings: #{holdings.count}")

        fund.save! if holdings.any?
      end
    end

    private

    def holdings_via_strategy
      strategy_class.new(fund).extract(holdings_file)
    end

    def strategy_class
      @strategy_class ||= case holdings_file
                          when CSVFile
                            Holdings::Extraction::CSVStrategy
                          when ExcelOpenXMLFile
                            Holdings::Extraction::ExcelOpenStrategy
                          else
                            raise UnknownStrategyError, "#{holdings_file.class} found at #{agent.page.url}"
                          end
    end

    def holdings_file
      @holdings_file ||= holdings_file_via_agent
    end

    def holdings_file_via_agent
      agent.get(fund.public_url)
      agent.click(agent.page.link_with(text: fund.manager.holdings_link_text))
    end

    def agent
      @agent ||= ::Mechanize.new do |agent|
        agent.user_agent_alias = 'iPhone'
        agent.pluggable_parser.csv = CSVFile
        agent.pluggable_parser.xml = ExcelOpenXMLFile
        agent.pluggable_parser['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'] = ExcelOpenXMLFile
      end
    end
  end
end
