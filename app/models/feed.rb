class Feed
    attr_reader :id, :type, :text, :title, :updated_at

    def self.from_communication(communication)
      new(id: communication.id,
          title: communication.title,
          text: communication.text,
          type: 'communication',
          updated_at: communication.updated_at)
    end

    def initialize(args)
      @id =  args[:id]
      @title = args[:title]
      @text = args[:text]
      @type = args[:type]
      @updated_at = args[:updated_at]
    end
end
