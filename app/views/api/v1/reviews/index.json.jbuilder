

json.reviews do
  json.partial! 'review', collection: @reviews, as: :review
end
