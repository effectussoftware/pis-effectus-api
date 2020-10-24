# frozen_string_literal: true

json.feed do
  json.partial! partial: 'feed', collection: @feeds, as: :feed
end
