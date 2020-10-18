# frozen_string_literal: true

json.communications do
  json.partial! 'communication', collection: @communications, as: :communication
end
