# frozen_string_literal: true

class Feed
  attr_reader :id, :type, :address, :start_time, :end_time, :text, :title, :updated_at, :image, :changed_last_seen

  def self.from_communication(communication)
    image = communication.image.attached? ? communication.image_url : nil

    new(id: communication.id,
        title: communication.title,
        address: nil,
        start_time: nil,
        end_time: nil,
        text: communication.text,
        type: 'communication',
        updated_at: communication.updated_at,
        image: image,
        changed_last_seen: nil)
  end

  def self.from_review(review)
    new(id: review.id,
        title: review.title,
        address: nil,
        start_time: nil,
        end_time: nil,
        text: review.comments,
        type: 'review',
        updated_at: review.updated_at,
        image: nil,
        changed_last_seen: nil)
  end

  def self.from_event(event, invitation)
    new(id: event.id,
        title: event.name,
        address: event.address,
        start_time: event.start_time,
        end_time: event.end_time,
        text: event.description,
        type: 'event',
        updated_at: event.updated_event_at,
        image: nil,
        changed_last_seen: invitation.changed_last_seen)
  end

  def initialize(args)
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
  end
end
