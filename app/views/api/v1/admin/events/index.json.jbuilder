# frozen_string_literal: true

json.events do
  json.partial! 'event', collection: @events, as: :event
end

json.pagination do
  json.partial! 'api/v1/admin/paginations/pagination', pagination: @pagy
end
