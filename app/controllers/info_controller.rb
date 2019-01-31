class InfoController < ApplicationController
  def index
    @points = PointsService.per_last_day
    @mean = DepositPayment.mean_per_last_day
  end
end
