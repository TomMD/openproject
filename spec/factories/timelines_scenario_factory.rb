FactoryGirl.define do
  factory(:timelines_scenario, :class => Timelines::Scenario) do
    sequence(:name) { |n| "Scenario No. #{n}" }
    sequence(:description) { |n| "Scenario No. #{n} would allow us to launch last week." }

    association :project
  end
end
