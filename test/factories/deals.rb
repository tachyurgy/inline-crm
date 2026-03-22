FactoryBot.define do
  factory :deal do
    name { "#{Faker::Company.bs.titleize} Deal" }
    stage { Deal::STAGES.sample }
    value { rand(5_000..500_000) }
    company
    contact
  end
end
