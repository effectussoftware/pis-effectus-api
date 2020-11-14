# frozen_string_literal: true

json.cost_summary @costs do |date, cost|
  json.date date
  json.cost cost
end
