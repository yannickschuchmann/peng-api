# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Character.find_or_create_by(name: "prostitute", name_de: "Flittchen", description: "„Die wohl beste Kopfgeldjägerin des Landes. Führt ein Doppelleben als Amüsierdame, um ihre Eltern zu enttäuschen.“", order: 0)
Character.find_or_create_by(name: "medic", name_de: "Arzt", description: "„Hat sich geschworen sein Skalpell erst wieder zu waschen, wenn endlich einer seiner Patienten die Warzenentfernung überlebt.“", order: 1)
Character.find_or_create_by(name: "sheriff", name_de: "Marshall", description: "„Seine diplomatische Verhandlungsstrategie heißt Magnum .44 und löste bisher jeden Konflikt zur Zufriedenheit aller Überlebenden.“", order: 2)
Character.find_or_create_by(name: "amerindian", name_de: "Indianer", description: "„Wurde von seinem Volk verstoßen, als er zum wiederholten Male obszöne Botschaften in seine Rauchzeichen einbaute.“", order: 3)
Character.find_or_create_by(name: "cowboy", name_de: "Cowboy", description: "„Zog nach Amerika aus, um ein echter Draufgänger zu werden. Aufgrund eines Missverständnisses hütet er jetzt Kühe.“", order: 4)
Character.find_or_create_by(name: "prisoner", name_de: "Sträfling", description: "„Als er in Hungerstreik für bessere Haftbedingungen trat, zog man ihm einfach Querstreifen an.“", order: 5)
Character.find_or_create_by(name: "bandit", name_de: "Bandito", description: "„Hat beim Russisch-Roulette erst zweimal verloren. Beleidigt seine Gegner gerne auf spanisch.“", order: 6)
Character.find_or_create_by(name: "hangman", name_de: "Henker", description: "„Seit man den Dorfrichter hängte, richtet der Henker im Dorf. Seine Lieblingsfarbe ist Blut-Rosa.“", order: 7)