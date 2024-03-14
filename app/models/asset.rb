class Asset < ApplicationRecord
  alias_attribute :asset_class, :type
end
