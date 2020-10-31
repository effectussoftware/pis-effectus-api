# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'
  belongs_to :user

  has_many :user_action_items,
           foreign_key: 'user_review_id',
           class_name: 'ReviewActionItem',
           dependent: :delete_all

  has_many :reviewer_action_items,
           foreign_key: 'reviewer_review_id',
           class_name: 'ReviewActionItem',
           dependent: :delete_all

  accepts_nested_attributes_for :user_action_items
  accepts_nested_attributes_for :reviewer_action_items

  validates :title, presence: true
  validate  :cant_save_if_reviewer_is_not_admin

  after_create :send_notification

  def cant_save_if_reviewer_is_not_admin
    errors.add(:reviewer, 'the reviewer must be an admin') if !reviewer || !reviewer.is_admin
  end

  scope :from_date, lambda { |start_time, with_include, user_id|
    query = if with_include
              'reviews.updated_at <= ? and user_id = ?'
            else
              'reviews.updated_at < ? and user_id = ?'
            end

    where(query, start_time, user_id)
  }

  scope :user_id, -> { where('user_id = ?', user_id) }

  private

  def send_notification
    user.send_notification(
      title,
      'You have a new review available.',
      { id: id, updated_at: updated_at, type: self.class.to_s }
    )
  end
end
