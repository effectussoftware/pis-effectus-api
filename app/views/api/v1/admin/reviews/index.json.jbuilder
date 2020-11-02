# frozen_string_literal: true

json.reviews do
  json.partial! 'review', collection: @reviews, as: :review
end

json.pagination do
  json.partial! 'api/v1/admin/paginations/pagination', pagination: @pagy
end
