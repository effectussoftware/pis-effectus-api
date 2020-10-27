# frozen_string_literal: true

json.extract! review, :id, :reviewer_id, :user_id, :title, :comments, :created_at
json.reviewer_action_items review.reviewer_action_items do |action_item|
  json.extract! action_item, :id, :description, :completed
end
json.user_action_items review.user_action_items do |action_item|
  json.extract! action_item, :id, :description, :completed
end
