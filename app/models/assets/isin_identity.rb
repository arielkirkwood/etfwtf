# frozen_string_literal: true

module Assets
  class ISINIdentity < Identity
    alias_attribute :isin, :identifier

    validates :identifier, length: { is: 12 }
  end
end
