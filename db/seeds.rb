require "faker"

u = User.count
n = Notification.count
c = Couple.count
k = Kid.count
e = Event.count
t = Task.count
s = Scoreboard.count
co = Competition.count
co_t = CompetitionsTask.count


puts "There is #{u} Users, #{n} Notifications, #{c} Couples, #{k} Kids, #{e} Events, #{t} Tasks, #{s} Scoreboards, #{co} Competitions and #{co_t} Competitions_tasks in you database"
puts "Do you want to continue (y/n)"
input = gets.chomp

return unless input == "y" || input == "Y"

puts "Clear database..."
puts ""

Notification.destroy_all
Kid.destroy_all
CompetitionsTask.destroy_all
Scoreboard.destroy_all
Competition.destroy_all
Event.destroy_all
Task.destroy_all
User.destroy_all
Couple.destroy_all

puts "Database empty"
puts ""

# ==================================================================
# Couples creation
# ==================================================================

Couple.create!(name: "Smith")
Couple.create!(name: "Dupont")

puts "2 couples created"
puts ""

# ==================================================================
# Kids creation
# ==================================================================

Couple.all.each do |couple|
  rand(2..4).times do
    Kid.create!(
    name: Faker::Name.first_name,
    blood_type: Faker::Blood.group,
    doctor_number: Faker::PhoneNumber.cell_phone,
    couple: couple)
  end
end

puts "#{Kid.count} kids created"
puts ""

# ==================================================================
# Users creation
# ==================================================================

user_nb = 1

Couple.all.each do |couple|
  2.times do
    User.create!(
      email: "user#{user_nb}@gmail.com",
      password: "1234567890",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      couple_id: couple.id
    )
    user_nb += 1
  end
end

puts "4 users created"
puts ""

# ==================================================================
# Notifications creation
# ==================================================================

User.all.each do |user|
  rand(2..10).times do
    Notification.create!(
      user: user,
      title: Faker::Lorem.sentence(word_count: rand(5..10)),
      content: Faker::Lorem.paragraph(sentence_count: rand(5..15))
    )
  end
end

puts "#{Notification.count} notifications created"
puts ""

# ==================================================================
# Competitions creation
# ==================================================================

reward_list = [
  "A relaxing spa day",
  "A weekend getaway to a cozy cabin",
  "A homemade dinner prepared by the other person",
  "A heartfelt love letter or message",
  "A special date night at your favorite restaurant",
  "A day off from baby duty (the other person takes care of the baby for a day)",
  "A small gift or token of appreciation",
  "Breakfast in bed",
  "A movie night with the person's choice of movies",
  "A romantic picnic in the park",
  "A heartfelt thank-you card",
  "A chance to pick the next family outing or activity",
  "A personalized trophy or certificate",
  "A subscription to a streaming service of their choice",
  "A shopping spree for baby-related items",
  "A surprise date planned by the other person",
  "A day of pampering and self-care",
  "A special dessert or treat of their choice",
]

Couple.all.each do |couple|
  Competition.create!(
    couple: couple,
    start_date: Faker::Date.between(from: 4.month.ago, to: 15.week.ago),
    end_date: Faker::Date.between(from: 3.month.ago, to: 10.week.ago),
    reward: reward_list.sample,
    user: couple.users.sample
  )
  Competition.create!(
    couple: couple,
    start_date: Faker::Date.between(from: 2.month.ago, to: 7.week.ago),
    end_date: Faker::Date.between(from: 1.month.ago, to: 3.week.ago),
    reward: reward_list.sample,
    user: couple.users.sample
  )
  Competition.create!(
    couple: couple,
    start_date: Faker::Date.between(from: 1.week.ago, to: 3.days.ago),
    end_date: Faker::Date.between(from: 3.week.from_now, to: 1.month.from_now),
    reward: reward_list.sample,
    user: nil
  )
end

puts "#{Competition.count} competitions created"
puts ""

# ==================================================================
# Scoreboards creation
# ==================================================================

Competition.all.each do |competition|
  if competition.user
    User.all.each do |user|
      if user == competition.user
        Scoreboard.create!(
          user: user,
          competition: competition,
          score: rand(20..25)
        )
      else
        Scoreboard.create!(
          user: user,
          competition: competition,
          score: rand(10..20)
        )
      end
    end
  else
    User.all.each do |user|
      Scoreboard.create!(
        user: user,
        competition: competition,
        score: rand(5..10)
      )
    end
  end
end
puts "#{Scoreboard.count} scoreboards created"
puts ""

# ==================================================================
# Events creation
# ==================================================================
events_list = [
  "Pediatrician Checkup",
  "Vaccination Appointment",
  "Skin Check",
  "Dental Checkup",
  "Allergy Test",
  "Baby's Music Class",
  "Visit to Grandma and Grandpa's House",
  "Volunteer at a Children's Charity",
  "Food Making Session",
  "Hockey game",
  "Bring to theater"
]

Couple.all.each do |couple|
  5.times do
    Event.create!(
      title: events_list.sample,
      content: Faker::Lorem.paragraph(sentence_count: rand(2..8)),
      date: Faker::Date.forward(days: 100),
      user: nil,
      kid: couple.kids.sample
    )
  end

  couple.users.each do |user|
    rand(1..3) do
      event = couple.events.sample
      event.user = user
    end
  end
end

puts "#{Event.count} events created"
puts ""

# ==================================================================
# Tasks creation
# ==================================================================

tasks_list = [
  "Change Diaper",
  "Bath Time for Baby",
  "Put Baby to Sleep/Nap",
  "Prepare Baby's Formula or Food",
  "Read a Book to Baby",
  "Tummy Time Exercise",
  "Baby Laundry",
  "Organize Baby's Clothes",
  "Baby Proofing the Home",
  "Doctor's Appointment for Baby",
  "Baby's Medication",
  "Baby Massage",
  "Playtime and Baby Stimulation",
  "Shopping for Baby Supplies"
]

Couple.all.each do |couple|
  5.times do
    Task.create!(
      title: tasks_list.sample,
      content: Faker::Lorem.paragraph(sentence_count: rand(2..8)),
      deadline: Faker::Date.forward(days: 30),
      is_recurent: rand(3).zero?,
      user: nil,
      kid: couple.kids.sample
    )
  end

  couple.users.each do |user|
    rand(1..3) do
      task = couple.tasks.sample
      task.user = user
    end
  end
end

puts "#{Task.count} tasks created"
puts ""

# ==================================================================
# Competitions_tasks creation
# ==================================================================

Task.all.each do |task|
  couple = task.kid.couple
  CompetitionsTask.create!(
    task: task,
    competition: Competition.where(couple: couple).sample,
    is_done: rand(3).zero?
  )
end

puts "#{CompetitionsTask.count} competitionsTasks created"
puts ""

puts "Seed completed !"
