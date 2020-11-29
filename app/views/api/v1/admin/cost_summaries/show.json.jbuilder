# frozen_string_literal: true

json.cost_summary do
  json.pesos do
    json.array! @costs_pesos, :date, :cost
  end
  json.dolares do
    json.array! @costs_dolares, :date, :cost
  end
end
