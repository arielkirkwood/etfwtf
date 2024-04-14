# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: [:environment] do
    managers = Assets::Manager.where(name: 'iShares').all
    funds = managers.flat_map(&:funds).first(2)
    funds.each(&:extract_holdings)
  end
end
