# frozen_string_literal: true

json.cost_summary do
  json.pesos @costs_pesos do |date, cost|
    json.date date
    json.cost cost
  end
  json.dolares @costs_dolares do |date, cost|
    json.date date
    json.cost cost
  end
end
