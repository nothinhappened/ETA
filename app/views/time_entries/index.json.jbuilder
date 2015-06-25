json.array!(@time_entries) do |time_entry|
  json.extract! time_entry, :id, :start_time, :duration, :organization_id, :task_id, :user_id
  json.url time_entry_url(time_entry, format: :json)
end
