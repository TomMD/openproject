FactoryGirl.define do
  factory(:timelines_alternate_date, :class => Timelines::AlternateDate) do
    sequence(:start_date) { |n| ((n - 1) * 7).days.since.to_date }
    sequence(:end_date)   { |n| (n * 7).days.since.to_date }

    planning_element { |e| e.association(:timelines_planning_element) }
  end
end

FactoryGirl.define do
  factory(:timelines_alternate_scenaric_date, :parent => :timelines_alternate_date) do |d|
    scenario { |e| e.association(:timelines_scenario) }
  end
end

FactoryGirl.define do
  factory(:timelines_alternate_historic_date, :parent => :timelines_alternate_date) do |d|
    scenario nil

    sequence(:created_at) { |n| n.weeks.ago.to_date }
    sequence(:updated_at) { |n| n.weeks.ago.to_date }
  end
end
