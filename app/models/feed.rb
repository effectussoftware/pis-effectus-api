# frozen_string_literal: true

class Feed
  attr_reader :id,
              :type,
              :address,
              :start_time,
              :end_time,
              :text,
              :title,
              :updated_at,
              :image,
              :changed_last_seen,
              :cancelled,
              :attend,
              :confirmation

  def self.from_communication(communication)
    image = communication.image.attached? ? communication.image_url : nil

    new(id: communication.id,
        title: communication.title,
        text: communication.text,
        type: communication.class.to_s,
        updated_at: communication.updated_at,
        image: image)
  end

  def self.from_review(review)
    new(id: review.id,
        title: review.title,
        text: review.comments,
        type: review.class.to_s,
        updated_at: review.updated_at)
  end

  def self.from_event(event, invitation)
    new(id: event.id,
        title: event.name,
        address: event.address,
        start_time: event.start_time,
        end_time: event.end_time,
        text: event.description,
        type: event.class.to_s,
        updated_at: event.updated_event_at,
        changed_last_seen: invitation.new_updates_since_last_seen?,
        cancelled: event.cancelled,
        attend: invitation.attend,
        confirmation: invitation.confirmation)
  end

  def initialize(args) # rubocop:disable Metrics/AbcSize
    @id =  args[:id]
    @title = args[:title]
    @address = args[:address]
    @start_time = args[:start_time]
    @end_time = args[:end_time]
    @text = args[:text]
    @type = args[:type]
    @updated_at = args[:updated_at]
    @image = args[:image]
    @changed_last_seen = args[:changed_last_seen]
    @cancelled = args[:cancelled]
    @attend = args[:attend]
    @confirmation = args[:confirmation]
  end
end
