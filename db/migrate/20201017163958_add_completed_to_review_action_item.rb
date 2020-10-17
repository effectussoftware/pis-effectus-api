class AddCompletedToReviewActionItem < ActiveRecord::Migration[6.0]
  def change
    add_column :review_action_items, :completed, :boolean
  end
end
