class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :name
      t.string :type
      t.integer :min_range
      t.integer :max_range
      t.string :options, array: true, default: []
      t.references :survey, foreign_key: true, index:true
      t.timestamps
    end
  end
end
                                                                                   