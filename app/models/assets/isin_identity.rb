# frozen_string_literal: true

module Assets
  class ISINIdentity < Identity
    alias_attribute :isin, :identifier

    validates_length_of :identifier, is: 12
  end
end
