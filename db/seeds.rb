# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Character.find_or_create_by(name: "prostitute", name_de: "Flittchen")
Character.find_or_create_by(name: "medic", name_de: "Arzt")
Character.find_or_create_by(name: "sheriff", name_de: "Sheriff")
Character.find_or_create_by(name: "amerindian", name_de: "Indianer")
Character.find_or_create_by(name: "cowboy", name_de: "Cowboy")
Character.find_or_create_by(name: "prisoner", name_de: "Häftling")
Character.find_or_create_by(name: "bandit", name_de: "Bandit")