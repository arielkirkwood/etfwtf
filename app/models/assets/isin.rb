# frozen_string_literal: true

module Assets
  class ISIN < Identity
    belongs_to :exchange, class_name: 'Markets::Exchange'

    alias_attribute :isin, :identifier

    validates :identifier, length: { is: 12 }
  end
end
