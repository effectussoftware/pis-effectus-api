class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.timestamp(:start_time)
      t.timestamp(:end_time)
      t.boolean (:publish, default: false)
      t.string(:name, null: false)
      
      t.timestamps
    end
  end
end