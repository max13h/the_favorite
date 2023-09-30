require "faker"

u = User.count
c = Family.count
k = Kid.count
e = Event.count
t = Task.count
s = Score.count
co = Competition.count
co_t = CompetitionsTask.count


puts "There is #{u} Users, #{c} Families, #{k} Kids, #{e} Events, #{t} Tasks, #{s} Scores, #{co} Competitions and #{co_t} Competitions_tasks in you database"
puts "Do you want to continue (y/n)"
input = gets.chomp

return unless input == "y" || input == "Y"

puts "Clear database..."
puts ""

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

Family.create!()
Family.create!()

puts "2 families created"
puts ""

# ==================================================================
# Kids creation
# ==================================================================

kids_names = [
  ["Lily", "https://i.redd.it/the-kids-this-ai-makes-are-very-adorable-v0-7ma8tg994jkb1.png?s=bdf0496310e182c5ff4420cc110da28c47448365"],
  ["Harry", "https://i.redd.it/el5eik42egjb1.png"],
  ["Mia", nil]
]

Family.all.each do |family|
  kids_names.each do |kid_informations|
    kid = Kid.new(
      name: kid_informations[0],
      blood_type: Faker::Blood.group,
      doctor_number: Faker::PhoneNumber.cell_phone,
      family: family
    )

    kid.picture.attach(io: URI.open(kid_informations[1]), filename: "kid.png") if kid_informations[1]
    kid.save!
  end
end

puts "#{Kid.count} kids created"
puts ""

# ==================================================================
# Users creation
# ==================================================================

user_nb = 1

user_names = [
  ["John", "https://i.pinimg.com/736x/e0/bc/5c/e0bc5cd4f1d7cff7116a325490b3010d.jpg"],
  ["Sarah", "https://i.pinimg.com/736x/d4/15/ec/d415ec1c79b0ae1d1730fffa18a9cb66.jpg"],
  ["William", "https://i.pinimg.com/736x/e5/73/81/e573813e566f68bb5156f2150cee8b69.jpg"],
  ["Linda", "https://i.pinimg.com/736x/ba/98/54/ba985453b52f62bcb8207c6b469a5095.jpg"]
]

Family.all.each do |family|
  2.times do
    user = User.create!(
      email: "user#{user_nb}@gmail.com",
      password: "1234567890",
      first_name: user_names[user_nb - 1][0],
      last_name: Faker::Name.last_name,
      family_id: family.id
    )

    user.picture.attach(io: URI.open(user_names[user_nb - 1][1]), filename: "parent.png")
    user.save!
    user_nb += 1
  end
end

puts "4 users created"
puts ""

# ==================================================================
# Competitions creation
# ==================================================================

reward_list = [
  "A homemade dinner prepared by the other person",
  "A special date night at your favorite restaurant",
  "A day off from baby duty (the other person takes care of the baby for a day)",
  "Breakfast in bed",
  "A movie night with the person's choice of movies"
]

Family.all.each do |family|
  Competition.create!(
    family: family,
    start_date: Faker::Time.between(from: 16.weeks.ago, to: 15.weeks.ago),
    end_date: Faker::Time.between(from: 13.week.ago, to: 12.week.ago),
    reward: reward_list[0],
    user: nil
  )
  Competition.create!(
    family: family,
    start_date: Faker::Time.between(from: 11.weeks.ago, to: 10.weeks.ago),
    end_date: Faker::Time.between(from: 8.week.ago, to: 7.week.ago),
    reward: reward_list[1],
    user: nil
  )
  Competition.create!(
    family: family,
    start_date: Faker::Time.between(from: 6.weeks.ago, to: 5.weeks.ago),
    end_date: Faker::Time.between(from: 3.week.ago, to: 2.week.ago),
    reward: reward_list[2],
    user: nil
  )
  Competition.create!(
    family: family,
    start_date: Faker::Time.between(from: 1.weeks.ago, to: DateTime.current),
    end_date: Faker::Time.between(from: 3.week.from_now, to: 4.week.from_now),
    reward: reward_list[3],
    user: nil
  )
end

puts "#{Competition.count} competitions created"
puts ""

# ==================================================================
# Events creation
# ==================================================================
events_list = [
  ["Pediatrician Checkup", "This is a regular pediatrician checkup at City Clinic"],
  ["Vaccination Appointment", "Time for vaccinations at County Hospital"],
  ["Birthday of friend Kevin", "Celebrate Kevin's birthday at Kevin's House"],
  ["Dental Checkup", "Routine dental checkup at Dental Office"],
  ["Allergy Test", "Get an allergy test done at Allergy Clinic"]
]

Family.all.each do |family|
  Competition.where(family: family).each do |competition|

    event_nb = 0

    5.times do
      event_date = Faker::Time.between_dates(from: competition.start_date, to: competition.end_date, period: :afternoon).to_datetime

      Event.create!(
        title: events_list[event_nb][0],
        content: events_list[event_nb][1],
        date: event_date,
        user: competition.end_date < DateTime.current ? family.users.sample : nil,
        kid: family.kids.sample,
        competition: competition
      )

      event_nb += 1
    end
  end
end

puts "#{Event.count} events created"
puts ""

# ==================================================================
# Tasks and Competitions_tasks creation
# ==================================================================

tasks_list = [
  ["Buy nappies", "Pack of 4", nil],
  ["Complete homework", "Math and History", nil],
  ["Prepare school snack", nil, nil],
  ["Organize toy shelf", nil, nil],
  ["Read a bedtime story", nil, nil]
]

Family.all.each do |family|
  Competition.where(family: family).each do |competition|

    task_nb = 0
    tasks_list[0][2] = Faker::Time.between(from: 2.day.from_now, to: competition.end_date).to_datetime
    tasks_list[1][2] = 2.day.from_now.to_datetime

    5.times do

      task = Task.create!(
        title: tasks_list[task_nb][0],
        content: tasks_list[task_nb][1],
        is_recurent: false,
        kid: family.kids.sample
      )

      CompetitionsTask.create!(
        task: task,
        competition: competition,
        is_done: competition.end_date < DateTime.current,
        user: competition.end_date < DateTime.current ? family.users.sample : nil,
        deadline: tasks_list[task_nb][2]
      )

      task_nb += 1
    end

  end

  # Creation of recurrent tasks

  Task.create!(
    title: "Bring to nursery",
    content: "Every Wednesday",
    is_recurent: true,
    kid: family.kids.last
  )
  Task.create!(
    title: "Pick up from the grandparents' house",
    content: "Every sunday",
    is_recurent: true,
    kid: family.kids.first
  )
end

puts "#{Task.count} tasks created"
puts ""

puts "#{CompetitionsTask.count} competitions_tasks created"
puts ""

# ==================================================================
# Scores creation
# ==================================================================

Competition.all.each do |competition|
  scores = []

  competition.family.users.each do |user|

    nb_of_events_taken = competition.events.where(user: user).count
    nb_of_tasks_taken = competition.competitions_tasks.where(user: user).count

    score = Score.create!(
      user: user,
      competition: competition,
      score: nb_of_events_taken + nb_of_tasks_taken
    )

    scores << score
  end

  if competition.end_date < DateTime.current
    competition.user = scores.max_by { |score| score.score }.user
    competition.user = nil if scores[0].score == scores[1].score
    competition.save!
  end
end

puts "#{Score.count} scores created"
puts ""

puts "Seed completed !"
