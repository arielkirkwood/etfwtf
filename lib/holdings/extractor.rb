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
                            raise UnknownStrategyError, holdings_file.class
                          end
    end

    def holdings_file
      @holdings_file ||= agent.get(fund.holdings_url)
    end

    def agent
      @agent ||= ::Mechanize.new
      @agent.pluggable_parser.csv = CSVFile
      @agent.pluggable_parser.xml = ExcelOpenXMLFile
      @agent.pluggable_parser['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'] = ExcelOpenXMLFile

      @agent
    end
  end
end
