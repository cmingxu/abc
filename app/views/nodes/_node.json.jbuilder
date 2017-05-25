json.extract! node, :id, :ip, :port, :raw_response, :created_at, :updated_at
json.url node_url(node, format: :json)
