# frozen_string_literal: true

require 'mechanize'

module Holdings
  class UnknownStrategyError < StandardError; end

  class Extractor
    attr_reader :fund, :portfolio

    def initialize(fund)
      @fund = fund
      @portfolio = fund.portfolios.any? ? fund.latest_portfolio : fund.portfolios.build

      attach_holdings_file unless portfolio.holdings_file.attached?

      replace_portfolio if Rails.env.production? || conditions_warrant_replacement?
    end

    def extract_holdings # rubocop:disable Metrics/AbcSize
      portfolio.update!(date: strategy.date) if portfolio.date != strategy.date

      Holding.transaction do
        if portfolio_ready?
          strategy.extract_holdings
        else
          Rails.logger.info("Skipping #{fund.name}, portfolio already has #{portfolio.holdings.count} holdings")
        end

        portfolio.save!
      end
    end

    private

    def portfolio_ready?
      portfolio.holdings.empty? && portfolio.holdings.count != strategy.holdings_count
    end

    def conditions_warrant_replacement?
      !portfolio.holdings.empty? &&
        exchange_status.business_day? && exchange_status.open? &&
        portfolio.date < 1.day.before(exchange_status.open_time.to_date)
    end

    def exchange_status
      @exchange_status ||= fund.exchange_status
    end

    def strategy
      @strategy ||= case fund.manager.name
                    when 'iShares'
                      ExtractionStrategies::Ishares.new(portfolio)
                    when 'TCW'
                      ExtractionStrategies::TCW.new(portfolio)
                    when 'State Street'
                      ExtractionStrategies::StateStreet.new(portfolio)
                    else
                      raise UnknownStrategyError, fund.manager
                    end
    end

    def replace_portfolio
      portfolio.destroy
      @portfolio = fund.portfolios.build
      attach_holdings_file
    end

    def attach_holdings_file # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      case fund.manager.name
      when 'iShares'
        raise unless file_via_agent.code == '200'

        portfolio.holdings_file.attach(io: file_via_agent.body_io, filename: file_via_agent.filename, content_type: file_via_agent.response['content_type'])
      when 'TCW'
        portfolio.holdings_file.attach(io: File.open('VOTE_holdings.xlsx'), filename: "#{fund.ticker.identifier}_holdings.xlsx")
      when 'State Street'
        io = case fund.ticker.identifier
             when 'EEMX'
               File.open('holdings-daily-us-en-eemx.xlsx')
             when 'EFAX'
               File.open('holdings-daily-us-en-efax.xlsx')
             when 'SPYX'
               File.open('holdings-daily-us-en-spyx.xlsx')
             end

        portfolio.holdings_file.attach(io:, filename: "#{fund.ticker.identifier}_holdings.xlsx")
      end

      portfolio.date = Time.zone.today
      portfolio.save!
    end

    def file_via_agent # rubocop:disable Metrics/AbcSize
      agent.get(fund.public_url)
      agent.click(agent.page.link_with!(text: fund.manager.holdings_link_text))
    rescue Mechanize::ElementNotFoundError
      agent.click(agent.page.link_with!(text: fund.manager.backup_holdings_link_text))
    end

    def agent
      @agent ||= ::Mechanize.new do |agent|
        agent.user_agent_alias = 'iPhone'
        agent.pluggable_parser.default = Mechanize::Download
      end
    end
  end
end
