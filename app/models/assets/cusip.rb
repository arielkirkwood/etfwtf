# frozen_string_literal: true

module Assets
  class CUSIP < Identity
    belongs_to :exchange, class_name: 'Markets::Exchange'

    alias_attribute :cusip, :identifier

    validates :identifier, length: { minimum: 9 }
  end
end
