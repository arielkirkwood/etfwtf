# frozen_string_literal: true

module Assets
  class SEDOL < Identity
    belongs_to :exchange, class_name: 'Assets::Exchange'

    alias_attribute :sedol, :identifier

    validates :identifier, length: { minimum: 7 }
  end
end
