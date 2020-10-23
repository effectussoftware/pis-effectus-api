json.review do
  json.partial! 'review', review: @review
end

json.review do
    json.action_items @review.review_action_items
    json.description @review.description
end