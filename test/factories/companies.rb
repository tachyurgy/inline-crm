FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    industry { Faker::Company.industry }
    website { Faker::Internet.url }
    phone { Faker::PhoneNumber.phone_number }
  end
end
