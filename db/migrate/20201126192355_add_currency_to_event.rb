class AddCurrencyToEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :currency, :string, default: 'pesos'
  end
end
