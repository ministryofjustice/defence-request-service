# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where(email: 'cso@example.com').first_or_create(
  email: 'cso@example.com', password: 'password', role: :cso)

User.where(email: 'cco@example.com').first_or_create(
  email: 'cco@example.com', password: 'password', role: :cco)
