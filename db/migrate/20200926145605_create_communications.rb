class CreateCommunications < ActiveRecord::Migration[6.0]
  def change
    create_table :communications do |t|
      t.text :title
      t.text :text
      t.boolean :published

      t.timestamps
    end
  end
end
