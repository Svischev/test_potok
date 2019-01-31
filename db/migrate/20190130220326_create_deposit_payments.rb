class CreateDepositPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :deposit_payments do |t|
      t.string :currency
      t.float :buy
      t.float :sell

      t.timestamps
    end
  end
end
