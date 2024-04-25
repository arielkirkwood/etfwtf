# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :fund

  has_one_attached :holdings_file

  has_many :holdings, dependent: :destroy

  validates :date, timeliness: { type: :date }, uniqueness: { scope: [:fund_id] }
  validates_associated :holdings
end
