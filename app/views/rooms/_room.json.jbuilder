json.extract! room, :id, :loginname, :opponent, :myfield, :hits, :created_at, :updated_at
json.url room_url(room, format: :json)
