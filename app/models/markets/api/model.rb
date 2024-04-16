# frozen_string_literal: true

module Markets
  module API
    class Model
      include Restorm::Model

      scope :for_exchange, ->(exchange) { where(mic: exchange.mic) }
    end
  end
end
