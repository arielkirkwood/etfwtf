# frozen_string_literal: true

module Assets
  class SEDOL < Identity
    alias_attribute :sedol, :identifier

    validates :identifier, length: { minimum: 7 }
  end
end
