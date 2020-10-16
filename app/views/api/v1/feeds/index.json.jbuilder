# frozen_string_literal: true
json.feeds do
  json.partial! partial: 'feed', collection: @feeds, as: :feed
end
