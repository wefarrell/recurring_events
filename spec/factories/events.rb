FactoryBot.define do
  factory :event do
    date { "2018-12-19" }
    start_time { "1:00"}
    duration_minutes { 60 }
    name { 'My event' }
  end
end
