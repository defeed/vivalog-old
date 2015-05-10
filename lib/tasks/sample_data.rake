namespace :sample do
  task :users => :environment do
    User.create!(
      email: "manager@vival.ee",
      name: Faker::Name.name,
      password: 'password',
      role: :manager
    )

    User.create!(
      email: "accountant@vival.ee",
      name: Faker::Name.name,
      password: 'password',
      role: :accountant
    )

    (1..4).each do |n|
      User.create!(
        email: "worker#{n}@example.com",
        name: Faker::Name.name,
        password: 'password',
        role: :worker
      )
    end
  end

  task :projects => :environment do
    (1..20).each do |n|
      start_date = Faker::Date.between(3.months.ago, Date.today)
      Project.create!(
        title: Faker::Address.street_address,
        volume: (rand * 10000).to_i,
        sum_receive: (rand * 100).to_i,
        sum_polish: (rand * 100).to_i,
        hourly_rate: (rand * 100).to_i,
        start_on: start_date,
        end_on: start_date + rand(0..7).days
      )
    end
  end
end
