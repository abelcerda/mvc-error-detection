json.array!(@analyzers) do |analyzer|
  json.extract! analyzer, :id, :cadena, :resultado
  json.url analyzer_url(analyzer, format: :json)
end
