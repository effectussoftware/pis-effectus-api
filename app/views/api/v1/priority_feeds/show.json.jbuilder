# frozen_string_literal: true

json.feed do
  json.partial! partial: 'api/v1/feeds/feed', collection: @feeds, as: :feed
end
