# frozen_string_literal: true

module Assets
  class Currency < Identity
    alias_attribute :currency, :identifier
  end
end
