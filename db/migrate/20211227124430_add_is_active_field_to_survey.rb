class AddIsActiveFieldToSurvey < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :is_active, :boolean,  default: false
  end
end
