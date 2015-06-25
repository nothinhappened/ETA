json.array!(@unlocked_times) do |unlocked_time|
  json.extract! unlocked_time, :id, :start_time, :end_time
  json.url unlocked_time_url(unlocked_time, format: :json)
end
