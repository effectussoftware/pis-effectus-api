# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :invitations, dependent: :delete_all
  has_many :users, through: :invitations
  accepts_nested_attributes_for :invitations

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :invitations_not_empty
  validate :end_time_must_be_greater_than_start_time
  validate :end_time_and_start_time_must_be_greater_than_now
  validate :cant_update_if_cancelled_event
  validate :can_update_published_field

  before_save :set_updated_event_at, if: :public_fields_would_update?
  after_save :send_new_event_notification, if: :just_published
  after_update :notify_invited_users, if: %i[public_fields_updated? published]

  scope :user_event_from_date_confirmed, lambda { |start_time, with_include, user_id|
    query = if with_include
              'events.updated_event_at <= ? AND
              invitations.user_id = ? AND
              (invitations.confirmation OR events.cancelled OR events.start_time < ?)'
            else
              'events.updated_event_at < ? AND
              invitations.user_id = ? AND
              (invitations.confirmation OR events.cancelled OR events.start_time < ?)'
            end
    joins(:invitations).where(query, start_time, user_id, Time.zone.now)
  }

  scope :future, -> { where('start_time > ?', Time.zone.now) }
  scope :on_month, lambda { |date, user_id|
    query = "to_char(events.start_time, 'YYYYMM') = to_char(?::TIMESTAMP,'YYYYMM') and invitations.user_id = ?"
    joins(:invitations).where(query, date, user_id).order(:start_time)
  }

  scope :on_year, lambda { |date|
    query = "to_char(events.start_time, 'YYYY') = to_char(?::TIMESTAMP,'YYYY')"
    where(query, date)
  }

  scope :on_day, lambda { |day|
    where("to_char(start_time, 'YYYYMMDD') = to_char(?::TIMESTAMP, 'YYYYMMDD')", day)
  }

  scope :published, -> { where(published: true) }

  def invitations_not_empty
    errors.add(:invitations, 'Debe haber al menos una invitación') if invitations.empty?
  end

  def end_time_must_be_greater_than_start_time
    return unless check_end_time_and_start_time && public_fields_would_update?

    errors.add(:start_time, 'La fecha de fin debe ser más grande que la fecha de inicio')
  end

  def end_time_and_start_time_must_be_greater_than_now
    return unless start_time_end_time_greater_than_now && public_fields_would_update?

    errors.add(:start_time, 'Las fechas de fin e inicio deben estar en el futuro')
  end

  def check_end_time_and_start_time
    (!start_time || !end_time) || (start_time >= end_time)
  end

  def start_time_end_time_greater_than_now
    (!start_time || !end_time) || (start_time < Time.zone.now || end_time < Time.zone.now)
  end

  private

  def cant_update_if_cancelled_event
    errors.add(:cancelled, 'No es posible actualizar un evento cancelado') if cancelled_was
  end

  def can_update_published_field
    return unless published_was && will_save_change_to_published?

    errors.add(:published, 'No es posible cambiar el campo publicado del evento')
  end

  def set_updated_event_at
    self.updated_event_at = Time.zone.now
  end

  def public_fields_would_update?
    name_changed? || address_changed? ||
      start_time_changed? || end_time_changed? || cancelled_changed? || published_changed?
  end

  def public_fields_updated?
    saved_change_to_name? || saved_change_to_address? ||
      saved_change_to_start_time? || saved_change_to_end_time? || saved_change_to_cancelled?
  end

  def notify_invited_users
    invitations.each(&:send_update_notification)
  end

  def just_published
    saved_change_to_published? && published?
  end

  def send_new_event_notification
    invitations.each(&:send_new_event_notification)
  end
end
