FactoryBot.define do
  factory :activity do
    action { %w[created updated noted called emailed].sample }
    description { Faker::Lorem.sentence }
    trackable { association :contact }
  end
end
