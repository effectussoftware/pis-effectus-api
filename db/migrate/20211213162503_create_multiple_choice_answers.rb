class CreateMultipleChoiceAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :multiple_choice_answers do |t|
      t.string :value
      t.datetime :answered_at
      t.references :question, foreign_key: true, index:true
      t.timestamps
    end
  end
end
