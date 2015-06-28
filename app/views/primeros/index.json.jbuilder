json.array!(@primeros) do |primero|
  json.extract! primero, :id, :cadena, :resultado
  json.url primero_url(primero, format: :json)
end
