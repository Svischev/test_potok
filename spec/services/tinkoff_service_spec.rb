
require 'rails_helper'

describe TinkoffService do
  let(:status) { 200 }
  let(:result_code) { 'OK' }
  let(:response) do
    {
      'resultCode' => result_code,
      'payload' => {
        'rates' => [
          dp_rate_hash('USD', 'RUB', 64.1, 66.7),
          dp_rate_hash('EUR', 'RUB', 63.3, 65.9),
          dp_rate_hash('GBP', 'RUB', 77.2, 79.1),
          dp_rate_hash('USD', 'GBP', 39.7, 40.0)
        ]
      }
    }
  end

  before do
    stub_request(:get, TinkoffService::API_URL)
      .to_return(status: status, body: response.to_json, headers: {})
  end

  context 'response status is 200 and resultCode is OK and full hash' do
    it 'deposit_payments RUB' do
      expect(deposit_payments('RUB'))
        .to eq([{ currency: 'USD', buy: 64.1, sell: 66.7 }, { currency: 'EUR', buy: 63.3, sell: 65.9 }])
    end
    it 'deposit_payments GBP' do
      expect(deposit_payments('GBP'))
        .to eq([{ currency: 'USD', buy: 39.7, sell: 40.0 }])
    end
    it 'deposit_payments GBPPP - incorrect' do
      expect(deposit_payments('GBPPP'))
        .to eq([])
    end
  end

  context 'response is blank hash' do
    let(:response) { {} }
    it { expect(deposit_payments('RUB')).to eq(nil) }
  end

  context 'response is blank hash with resultCode is OK' do
    let(:response) { { 'resultCode' => result_code } }
    it { expect { deposit_payments('RUB') }.to raise_error(NoMethodError) }
  end

  context 'response status is 500' do
    let(:status) { 500 }
    it { expect(deposit_payments('RUB')).to eq(nil) }
  end

  context 'resultCode is Error' do
    let(:result_code) { 'Error' }
    it { expect(deposit_payments('RUB')).to eq(nil) }
  end

  def deposit_payments(to_currency)
    TinkoffService.new(to_currency: to_currency).deposit_payments
  end

  def dp_rate_hash(from_curr, to_curr, buy, sell)
    {
      'category' => 'DepositPayments',
      'fromCurrency' => {
        'code' => 777,
        'name' => from_curr,
        'strCode' => '840'
      },
      'toCurrency' => {
        'code' => 888,
        'name' => to_curr,
        'strCode' => '643'
      }, 'buy' => buy, 'sell' => sell
    }
  end
end
