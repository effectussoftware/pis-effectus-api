# frozen_string_literal: true

json.communications do
  json.partial! 'communication', collection: @communications, as: :communication
end
json.pagination do
  json.partial! 'api/v1/admin/paginations/pagination', pagination: @pagy
end
