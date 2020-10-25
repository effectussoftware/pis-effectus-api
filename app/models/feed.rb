# frozen_string_literal: true

class Feed
  attr_reader :id, :type, :text, :title, :updated_at, :image

  def self.from_communication(communication)
    image = communication.image.attached? ? communication.image_url : nil

    new(id: communication.id,
        title: communication.title,
        text: communication.text,
        type: 'communication',
        updated_at: communication.updated_at,
        image: image)
  end

  def initialize(args)
    @id =  args[:id]
    @title = args[:title]
    @text = args[:text]
    @type = args[:type]
    @updated_at = args[:updated_at]
    @image = args[:image]
  end
end
