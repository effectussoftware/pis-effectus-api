# frozen_string_literal: true

json.surveys do
  json.partial! 'survey', collection: @surveys, as: :survey
end
