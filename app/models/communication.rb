# frozen_string_literal: true

class Communication < ApplicationRecord
  validates :title, presence: true
  before_update :validate_update
  scope :not_recurrent_from_date, lambda { |start_time, with_include|
    query = if with_include
              'communications.updated_at <= ? AND
      communications.published = true AND
      communications.recurrent_on is NULL'
            else
              'communications.updated_at < ? AND
     communications.published = true AND
     communications.recurrent_on is NULL'
            end

    where(query, start_time)
  }
  scope :recurrent_from_date, lambda { |start_time, with_include|
    query = if with_include
              '(extract(month from recurrent_on) < ?) OR
       (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) <= ?)'
            else
              '(extract(month from recurrent_on) < ?) OR
       (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) < ?)'
            end
    where(query, start_time.month, start_time.month, start_time.day)
  }

  private

  def validate_update
    communication = Communication.find(id)
    raise ActionController::BadRequest, 'cannot update a published communication' if communication.published
    raise ActionController::BadRequest, 'cannot update a reccurrent communication' if communication.recurrent_on
  end
end
