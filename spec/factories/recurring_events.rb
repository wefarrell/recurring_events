FactoryBot.define do
  factory :recurring_event do
    start_date { "2018-12-18" }
    end_date { "2019-12-18" }
    start_time { "1:00"}
    duration_minutes { 60 }
    frequency { :weekly }
    name { 'My event' }
  end
end
