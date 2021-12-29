# frozen_string_literal: true

json.questions do
  json.partial! 'question', collection: @questions, as: :question
end
