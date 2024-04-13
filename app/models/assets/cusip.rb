# frozen_string_literal: true

module Assets
  class CUSIP < Identity
    alias_attribute :cusip, :identifier

    validates :identifier, length: { minimum: 9 }
  end
end
