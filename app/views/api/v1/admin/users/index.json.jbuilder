# frozen_string_literal: true

json.users do
  json.partial! 'user', collection: @users, as: :user
end

json.pagination do
  json.partial! 'api/v1/admin/paginations/pagination', pagination: @pagy
end
