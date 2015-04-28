namespace :sample do
  task :users => :environment do
    User.create!(
      email: "admin@example.com",
      username: "admin",
      name: Faker::Name.name,
      password: 'password'
    )

    (1..4).each do |n|
      User.create!(
        email: "user#{n}@example.com",
        username: "user#{n}",
        name: Faker::Name.name,
        password: 'password'
      )
    end
  end

  task :projects => :environment do
    (1..50).each do |n|
      Project.create!(
        title: Faker::Address.street_address,
        volume: (rand * 10000).to_i,
        price_receive: (rand * 100).to_i,
        price_polish: (rand * 100).to_i,
        price_other: (rand * 100).to_i,
        date: Faker::Date.between(5.months.ago, Date.today)
      )
    end
  end
end
