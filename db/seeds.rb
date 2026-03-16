puts "Seeding database..."

companies = 8.times.map do
  Company.create!(
    name: Faker::Company.unique.name,
    industry: Faker::Company.industry,
    website: Faker::Internet.url,
    phone: Faker::PhoneNumber.phone_number,
    notes: Faker::Company.catch_phrase
  )
end

contacts = companies.flat_map do |company|
  rand(1..3).times.map do
    Contact.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      title: Faker::Job.title,
      company: company,
      notes: Faker::Lorem.sentence
    )
  end
end

Deal::STAGES.first(4).each do |stage|
  rand(2..4).times do
    company = companies.sample
    Deal.create!(
      name: "#{Faker::Company.bs.titleize}",
      stage: stage,
      value: rand(5_000..200_000),
      company: company,
      contact: company.contacts.sample,
      notes: Faker::Lorem.sentence
    )
  end
end

puts "Created #{Company.count} companies, #{Contact.count} contacts, #{Deal.count} deals, #{Activity.count} activities"
