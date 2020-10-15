# frozen_string_literal: true

json.communications @communications do |communication|
  json.partial 'communication', obj: communication
end
