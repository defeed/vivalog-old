User.create!(
  email: ENV['ADMIN_EMAIL'],
  username: ENV['ADMIN_USERNAME'],
  password: ENV['ADMIN_PASSWORD']
)
