# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do |n|
  name  = "User #{n+1}"
  user_name = "user#{n+1}"
  email = "user-#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
               user_name: user_name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at)
5.times do |n|
  title = "Fake Event #{n+1}"
  date = DateTime.now
  description = "Fake description #{n+1} #fake"
  location = "Fake location #{n+1}"
  users.each do |user| 
    user.events.create!(title: title,
                        date: date,
                        location: location,
                        description: description,
                        isprivate: 0,
                        likes_count: 0)
  end
end


# Following relationships
users = User.all
user  = users.first
following = users[2..20]
followers = users[3..12]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }