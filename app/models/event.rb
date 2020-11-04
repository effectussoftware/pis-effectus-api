# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :invitations, dependent: :delete_all
  has_many :users, through: :invitations
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  accepts_nested_attributes_for :invitations
  validate :invitations_not_empty
  validate :end_time_must_be_greater_than_start_time
  validate :end_time_and_start_time_must_be_greater_than_now

  scope :from_date, lambda { |start_time, with_include, user_id|
    query = if with_include
              'events.start_time >= ? and invitations.user_id = ?'
            else
              'events.start_time > ? and invitations.user_id = ?'
            end
    joins(:invitations).where(query, start_time, user_id)
  }

  def invitations_not_empty
    errors.add(:invitations, 'the invitations cannot be empty') if invitations.empty?
  end

  def end_time_must_be_greater_than_start_time
    errors.add(:start_time, 'end_time must be greater than start_time') if check_end_time_and_start_time
  end

  def end_time_and_start_time_must_be_greater_than_now
    errors.add(:start_time, 'end_time and start_time must be greater than now') if start_time_end_time_greater_than_now
  end

  def check_end_time_and_start_time
    (!start_time || !end_time) || (start_time >= end_time)
  end

  def start_time_end_time_greater_than_now
    (!start_time || !end_time) || (start_time < Time.zone.now || end_time < Time.zone.now)
  end
end
