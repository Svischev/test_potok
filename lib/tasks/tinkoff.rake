namespace :tinkoff do
  task collect: :environment do
    puts "DepositPayment.count = #{DepositPayment.count}"
    deposit_payments = TinkoffService.new(to_currency: 'RUB').deposit_payments
    DepositPayment.create!(deposit_payments)
    puts "DepositPayment.count = #{DepositPayment.count}"
  end

  # random for 100 hours ago
  task random: :environment do
    puts "DepositPayment.count = #{DepositPayment.count}"
    DepositPayment.destroy_all
    100.times do |i|
      deposit_payments = TinkoffService.new(to_currency: 'RUB').deposit_payments
      deposit_payments.each { |dp| dp[:sell] = dp[:sell] + rand(5) }
      deposit_payments.each { |dp| dp[:buy] = dp[:buy] + rand(5) }
      deposit_payments.each { |dp| dp[:created_at] = Time.now - i.hours }
      DepositPayment.create!(deposit_payments)
    end
    puts "DepositPayment.count = #{DepositPayment.count}"
  end
end
