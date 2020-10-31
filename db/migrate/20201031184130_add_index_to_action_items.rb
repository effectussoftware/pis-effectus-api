class AddIndexToActionItems < ActiveRecord::Migration[6.0]
  def change
    add_index :review_action_items, :user_review_id
    add_index :review_action_items, :reviewer_review_id
  end
end
