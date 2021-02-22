# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Campaign.delete_all
User.delete_all
# user = User.create(email: 'toto@toto.fr', password: 'toto123', username: 'toto')
# puts "Created a new user: #{user.email}"

5.times do
  user = User.create!(
      email: Faker::Internet.email,
      password: 'abcd1234',
      username: Faker::Internet.username(specifier: 6)
  )
  puts "Created a new user: #{user.email}, username: #{user.username}"

  2.times do
    campaign = Campaign.create!(
        title: Faker::Hipster.sentence(word_count: 3),
        purpose: Faker::Hipster.sentences(number: 1),
        starts_on: Faker::Time.between_dates(from: Date.today, to: Date.today + 5, period: :all),
        ends_on: Faker::Time.between_dates(from: Date.today+5, to: Date.today + 90, period: :all),
        user_id: user.id
    )
    puts "Created brand new campaign: #{campaign.title}"
  end
end