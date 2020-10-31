# frozen_string_literal: true

class CreateReviewActionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :review_action_items do |t|
      t.text :description
      t.boolean :completed
      t.integer :reviewer_review_id, foreign_key: true
      t.integer :user_review_id, foreign_key: true

      t.timestamps
    end
  end
end
