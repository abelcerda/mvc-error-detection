json.array!(@analyzers) do |analyzer|
  json.extract! analyzer, :id, :directory, :lenguage
  json.url analyzer_url(analyzer, format: :json)
end
