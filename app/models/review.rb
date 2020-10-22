# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'
  belongs_to :user
  has_many :review_action_item
  accepts_nested_attributes_for :review_action_item 
end
