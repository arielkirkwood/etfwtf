# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: [:environment, 'db:seed'] do
    # managers = Assets::Manager.where.not(name: 'TCW')
    # managers.flat_map(&:funds).each(&:extract_holdings)
    funds = Fund.first(2)
    funds.each(&:extract_holdings)
  end
end
