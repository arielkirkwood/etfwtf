# frozen_string_literal: true

module Holdings
  module Files
    class Base < Mechanize::File
      attr_reader :date
    end
  end
end
