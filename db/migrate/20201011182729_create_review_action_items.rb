# frozen_string_literal: true

class CreateReviewActionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :review_action_items do |t|
      t.text :description
      t.string :commitment_owner
      t.boolean :completed
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
