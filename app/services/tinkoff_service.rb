class TinkoffService
  API_URL = 'https://www.tinkoff.ru/api/v1/currency_rates'.freeze
  FROM_CURRENCIES = %w[USD EUR].freeze
  attr_reader :to_currency

  def initialize(to_currency:)
    @to_currency = to_currency
  end

  def deposit_payments
    return unless api_response.code == 200
    return unless body['resultCode'] == 'OK'
    calculate
  end

  private

  def calculate
    rates.select { |r| r['category'] == 'DepositPayments' }.each_with_object([]) do |line, result|
      next unless line['fromCurrency']['name'].in?(FROM_CURRENCIES) && line['toCurrency']['name'] == to_currency
      result << {
        currency: line['fromCurrency']['name'],
        buy: line['buy'],
        sell: line['sell']
      }
    end
  end

  def rates
    @rates ||= body['payload']['rates']
  end

  def body
    @body ||= JSON.parse(api_response.body)
  end

  def api_response
    @api_response ||= HTTParty.get(API_URL)
  end
end
