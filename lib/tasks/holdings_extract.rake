# frozen_string_literal: true

desc "Update existing funds' holdings."

namespace :holdings do
  task extract: :environment do
    manager = Assets::Manager.first
    manager.funds.each(&:extract_holdings)
  end
end
