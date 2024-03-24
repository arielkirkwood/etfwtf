# frozen_string_literal: true

module Assets
  class ISINIdentity < Identity
    belongs_to :exchange, class_name: 'Assets::Exchange'

    alias_attribute :isin, :identifier

    validates :identifier, length: { is: 12 }
  end
end
