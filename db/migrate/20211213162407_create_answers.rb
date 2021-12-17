class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :value
      t.datetime :answered_at
      t.references :question, foreign_key: true, index:true
      t.references :user, foreign_key: true, index:true
      t.timestamps
    end
  end
end