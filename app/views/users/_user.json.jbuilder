json.extract! user, :id, :loginname, :created_at, :updated_at
json.url user_url(user, format: :json)
