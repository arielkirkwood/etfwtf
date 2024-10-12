# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: [:environment] do
    funds = Fund.all
    funds.each(&:extract_holdings)
  end
end
