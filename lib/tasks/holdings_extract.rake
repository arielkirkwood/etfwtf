# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: [:environment] do
    funds = Fund.all

    funds.each do |fund|
      extractor = Holdings::Extractor.new(fund)
      extractor.attach_holdings_file
      extractor.extract_holdings
    end
  end
end
