# frozen_string_literal: true

class Equity < Asset
  delegate :ticker, to: :identity
end
