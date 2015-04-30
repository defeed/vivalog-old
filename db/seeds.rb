User.create!(
  name: ENV['ADMIN_NAME'],
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  role: :administrator
)
