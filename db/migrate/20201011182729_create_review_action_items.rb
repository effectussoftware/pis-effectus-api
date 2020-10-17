class CreateReviewActionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :review_action_items do |t|
      t.text :description
      t.integer :type
      t.references :user, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
