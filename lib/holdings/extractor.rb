# frozen_string_literal: true

require 'mechanize'

module Holdings
  class UnknownStrategyError < StandardError; end

  class Extractor
    attr_reader :fund, :portfolio

    def initialize(fund)
      @fund = fund
      @portfolio = fund.portfolio || fund.build_portfolio

      attach_holdings_file unless portfolio.holdings_file.attached?
    end

    def extract_holdings
      portfolio.update!(date: strategy.date) if strategy.date != portfolio.date

      Holding.transaction do
        strategy.extract_holdings if conditions_correct?

        portfolio.save!
      end
    end

    private

    def conditions_correct?
      portfolio.holdings.count != strategy.holdings_count
    end

    def strategy
      @strategy ||= case portfolio.holdings_file.content_type
                    when 'text/csv'
                      ExtractionStrategies::CSV.new(portfolio)
                    when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                      ExtractionStrategies::Excel.new(portfolio)
                    else
                      raise UnknownStrategyError, portfolio.holdings_file.content_type
                    end
    end

    def attach_holdings_file # rubocop:disable Metrics/AbcSize
      raise unless file_via_agent.code == '200'

      portfolio.holdings_file.attach(io: file_via_agent.body_io, filename: file_via_agent.filename, content_type: file_via_agent.response['content_type'])
      portfolio.date = Time.zone.today
      portfolio.save!
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
