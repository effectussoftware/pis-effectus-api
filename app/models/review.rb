class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'
  belongs_to :user
  has_many :review_action_item
end
