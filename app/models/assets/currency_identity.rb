# frozen_string_literal: true

module Assets
  class CurrencyIdentity < Identity
    alias_attribute :currency, :identifier
  end
end
