# frozen_string_literal: true

module Assets
  class ISIN < Identity
    alias_attribute :isin, :identifier

    validates :identifier, length: { is: 12 }
  end
end
