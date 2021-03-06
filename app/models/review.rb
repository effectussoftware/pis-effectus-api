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

  accepts_nested_attributes_for :user_action_items, allow_destroy: true
  accepts_nested_attributes_for :reviewer_action_items, allow_destroy: true

  validates :title, presence: true
  validate  :cant_save_if_reviewer_is_not_admin

  after_create :send_notification

  def cant_save_if_reviewer_is_not_admin
    errors.add(:reviewer, 'El reviewer debe ser administrador') if !reviewer || !reviewer.is_admin
  end

  scope :from_date, lambda { |start_time, with_include, user_id|
    query = if with_include
              'reviews.updated_at <= ? and user_id = ?'
            else
              'reviews.updated_at < ? and user_id = ?'
            end

    where(query, start_time, user_id)
  }

  private

  def send_notification
    user.send_notification(
      title,
      'Tienes una nueva 1o1',
      { id: id, updated_at: updated_at, type: self.class.to_s }
    )
  end
end
