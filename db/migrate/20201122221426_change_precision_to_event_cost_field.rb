class ChangePrecisionToEventCostField < ActiveRecord::Migration[6.0]
  def change
    change_column :events, :cost, :decimal, precision: 9, scale: 2
  end
end
