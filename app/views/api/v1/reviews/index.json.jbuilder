# frozen_string_literal: true

json.reviews do
  json.partial! 'review', collection: @reviews, as: :review
end
