# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: [:environment, 'db:seed'] do
    # managers = Assets::Manager.where.not(name: 'TCW')
    # managers.flat_map(&:funds).each(&:extract_holdings)
    fund = Fund.first
    fund.extract_holdings
  end
end
