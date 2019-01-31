class DepositPayment < ApplicationRecord
  validates :currency, :buy, :sell, presence: true

  scope :currency, ->(value) { where(currency: value) }
  scope :per_last_day, -> { where('created_at >= ?', 1.day.ago) }
  scope :mean_buy_per_last_day, -> { per_last_day.average(:buy) }
  scope :mean_sell_per_last_day, -> { per_last_day.average(:sell) }

  def self.mean_per_last_day
    Rails.cache.fetch('mean_per_last_day', expires_in: 30.minutes) do
      {
        'USD BUY' => currency('USD').mean_buy_per_last_day.round(2),
        'USD SELL' => currency('USD').mean_sell_per_last_day.round(2),
        'EUR BUY' => currency('EUR').mean_buy_per_last_day.round(2),
        'EUR SELL' => currency('EUR').mean_sell_per_last_day.round(2)
      }
    end
  end
end
