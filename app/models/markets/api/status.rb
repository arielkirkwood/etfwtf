# frozen_string_literal: true

module Markets
  module API
    class Status < Model
      # common markets missing from trading calendar with solution alias
      MISSING_MICS = {
        'XNAS' => 'XNYS'
      }.freeze

      collection_path 'markets/status'

      def local_time
        Time.zone.parse(attributes[:local_time])
      end

      def open_time
        Time.zone.parse(attributes[:open_time]) if attributes[:open_time].present?
      end

      def close_time
        Time.zone.parse(attributes[:close_time]) if attributes[:close_time].present?
      end

      def weekend?
        is_weekend == true
      end

      def business_day?
        is_business_day == true
      end

      def early_close?
        is_early_close == true
      end

      def open?
        status == 'Open'
      end

      def closed?
        status == 'Closed'
      end
    end
  end
end
