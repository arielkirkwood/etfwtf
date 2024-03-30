# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: [:environment, 'db:seed'] do
    managers = Assets::Manager.where(name: 'iShares').all
    managers.flat_map(&:funds).each(&:extract_holdings)
  end
end
