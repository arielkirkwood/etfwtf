# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class Base
      attr_reader :date, :portfolio

      def initialize(portfolio)
        @portfolio = portfolio
      end

      private

      def asset_type(asset_class) # rubocop:disable Metrics/MethodLength
        case asset_class
        when 'Bond', 'Fixed Income'
          'Bond'
        when 'Cash', 'Cash Collateral and Margins'
          'CashEquivalent'
        when 'Derivatives', 'Futures'
          'Derivative'
        when 'Equity'
          'Equity'
        when 'FX'
          'ForexCurrency'
        when 'Money Market'
          'MoneyMarketFund'
        else
          raise Asset::UnknownTypeError, asset_class
        end
      end
    end
  end
end
