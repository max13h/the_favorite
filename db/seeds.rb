require "faker"

u = User.count
n = Notification.count
c = Family.count
k = Kid.count
e = Event.count
t = Task.count
s = Score.count
co = Competition.count
co_t = CompetitionsTask.count


puts "There is #{u} Users, #{n} Notifications, #{c} Families, #{k} Kids, #{e} Events, #{t} Tasks, #{s} Scores, #{co} Competitions and #{co_t} Competitions_tasks in you database"
puts "Do you want to continue (y/n)"
input = gets.chomp

return unless input == "y" || input == "Y"

puts "Clear database..."
puts ""

Notification.destroy_all
Event.destroy_all
CompetitionsTask.destroy_all
Task.destroy_all
Kid.destroy_all
Score.destroy_all
Competition.destroy_all
User.destroy_all
Family.destroy_all

puts "Database empty"
puts ""

# ==================================================================
# Families creation
# ==================================================================

Family.create!(name: "Smith")
Family.create!(name: "Dupont")

puts "2 families created"
puts ""

# ==================================================================
# Kids creation
# ==================================================================

Family.all.each do |family|
  rand(2..4).times do
    Kid.create!(
    name: Faker::Name.first_name,
    blood_type: Faker::Blood.group,
    doctor_number: Faker::PhoneNumber.cell_phone,
    family: family)
  end
end

puts "#{Kid.count} kids created"
puts ""

# ==================================================================
# Users creation
# ==================================================================

user_nb = 1

Family.all.each do |family|
  2.times do
    User.create!(
      email: "user#{user_nb}@gmail.com",
      password: "1234567890",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      family_id: family.id
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

Family.all.each do |family|
  Competition.create!(
    family: family,
    start_date: Faker::Date.between(from: 4.month.ago, to: 15.week.ago),
    end_date: Faker::Date.between(from: 3.month.ago, to: 10.week.ago),
    reward: reward_list.sample,
    user: family.users.sample
  )
  Competition.create!(
    family: family,
    start_date: Faker::Date.between(from: 2.month.ago, to: 7.week.ago),
    end_date: Faker::Date.between(from: 1.month.ago, to: 3.week.ago),
    reward: reward_list.sample,
    user: family.users.sample
  )
  Competition.create!(
    family: family,
    start_date: Faker::Date.between(from: 1.week.ago, to: 3.days.ago),
    end_date: Faker::Date.between(from: 3.week.from_now, to: 1.month.from_now),
    reward: reward_list.sample,
    user: nil
  )
end

puts "#{Competition.count} competitions created"
puts ""

# ==================================================================
# Scores creation
# ==================================================================

Competition.all.each do |competition|
  if competition.user
    User.all.each do |user|
      if user == competition.user
        Score.create!(
          user: user,
          competition: competition,
          score: rand(20..25)
        )
      else
        Score.create!(
          user: user,
          competition: competition,
          score: rand(10..20)
        )
      end
    end
  else
    User.all.each do |user|
      Score.create!(
        user: user,
        competition: competition,
        score: rand(5..10)
      )
    end
  end
end
puts "#{Score.count} scores created"
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

Family.all.each do |family|
  Competition.where(family: family).each do |competition|

    event_date = Faker::Date.between(from: competition.start_date, to: competition.end_date)

    5.times do
      Event.create!(
        title: events_list.sample,
        content: Faker::Lorem.paragraph(sentence_count: rand(2..8)),
        date: event_date,
        user: nil,
        kid: family.kids.sample,
        competition: competition
      )
    end

    if competition.user
      competition.events.each do |event|
        event.user = competition.user
        event.save
      end
    end

  end
end

puts "#{Event.count} events created"
puts ""

# ==================================================================
# Tasks and Competitions_tasks creation
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

Family.all.each do |family|
  Competition.where(family: family).each do |competition|

    task_deadline = Faker::Date.between(from: competition.start_date, to: competition.end_date)
    winner = competition.user if competition.user

    5.times do
      task = Task.create!(
        title: tasks_list.sample,
        content: Faker::Lorem.paragraph(sentence_count: rand(2..8)),
        deadline: task_deadline,
        is_recurent: rand(5).zero?,
        kid: family.kids.sample
      )

      CompetitionsTask.create!(
        task: task,
        competition: competition,
        is_done: competition.user == true,
        user: winner || nil
      )
    end

  end
end

puts "#{Task.count} tasks created"
puts ""

puts "#{CompetitionsTask.count} competitionsTasks created"
puts ""

puts "Seed completed !"
