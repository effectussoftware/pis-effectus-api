class AddDummyToCommunications < ActiveRecord::Migration[6.0]
  def change
    add_column :communications, :dummy, :boolean, default: false
  end
end
