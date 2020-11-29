# frozen_string_literal: true

json.cost_summary do
  json.pesos @costs_pesos do |date_cost|
    json.extract! date_cost, :date, :cost
  end
  json.dolares @costs_dolares do |date_cost|
    json.extract! date_cost, :date, :cost
  end
end
