class PointsService
  class << self
    def per_last_day
      usd_data = DepositPayment.per_last_day.currency('USD').all
      eur_data = DepositPayment.per_last_day.currency('EUR').all

      result = []
      result << to_points(usd_data, 'USD', :buy)
      result << to_points(usd_data, 'USD', :sell)
      result << to_points(eur_data, 'EUR', :buy)
      result << to_points(eur_data, 'EUR', :sell)
      result
    end

    def to_points(dp_data, curr, act)
      data = dp_data.reduce({}) do |res, dp|
        res.merge(dp.created_at => dp.send(act))
      end
      {
        name: "#{curr} #{act}",
        data: data
      }
    end
  end
end
