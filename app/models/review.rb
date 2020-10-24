# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'
  belongs_to :user
  has_many :user_action_items, foreign_key: 'user_review_id', class_name: 'ReviewActionItem', dependent: :delete_all
  has_many :reviewer_action_items, foreign_key: 'reviewer_review_id', class_name: 'ReviewActionItem', dependent: :delete_all
  accepts_nested_attributes_for :user_action_items
  accepts_nested_attributes_for :reviewer_action_items

  validates :title, presence: true
end
