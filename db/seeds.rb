# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(email: 'eduardo.candanedo.94@gmail.com', password: 'secretsecret')

tasks = [
  {
    title: 'Mow the lawn',
    completed: false,
    user_id: user.id
  },
  {
    title: 'Go for a run',
    completed: false,
    user_id: user.id
  },
  {
    title: 'Pay the electricity',
    completed: false,
    user_id: user.id
  },
  {
    title: 'Send package to GDL',
    completed: false,
    user_id: user.id
  }
]

tasks.each do |task_attrs|
  if Task.create(task_attrs)
    p 'Created ' + task_attrs[:title]
  end
end
