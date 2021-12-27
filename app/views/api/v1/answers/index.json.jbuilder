# frozen_string_literal: true

json.answers do
  json.partial! 'answer', collection: @answers, as: :answer
end
