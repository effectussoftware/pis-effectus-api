# frozen_string_literal: true

json.users do
  json.partial! 'user', collection: @users, as: :user
end
