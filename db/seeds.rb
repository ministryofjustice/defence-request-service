# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#CSO test users
User.where(email: 'cso1@example.com').first_or_create(
  email: 'cso1@example.com', password: 'password', role: :cso)
User.where(email: 'cso2@example.com').first_or_create(
  email: 'cso2@example.com', password: 'password', role: :cso)
User.where(email: 'cso3@example.com').first_or_create(
  email: 'cso3@example.com', password: 'password', role: :cso)
User.where(email: 'cso4@example.com').first_or_create(
  email: 'cso4@example.com', password: 'password', role: :cso)
User.where(email: 'cso5@example.com').first_or_create(
  email: 'cso5@example.com', password: 'password', role: :cso)

#CCO test users
User.where(email: 'cco1@example.com').first_or_create(
  email: 'cco1@example.com', password: 'password', role: :cco)
User.where(email: 'cco2@example.com').first_or_create(
  email: 'cco2@example.com', password: 'password', role: :cco)
User.where(email: 'cco3@example.com').first_or_create(
  email: 'cco3@example.com', password: 'password', role: :cco)
User.where(email: 'cco4@example.com').first_or_create(
  email: 'cco4@example.com', password: 'password', role: :cco)
User.where(email: 'cco5@example.com').first_or_create(
  email: 'cco5@example.com', password: 'password', role: :cco)

#Solicitor test users
User.where(email: 'solicitor1@example.com').first_or_create(
  email: 'solicitor1@example.com', password: 'password', role: :solicitor)
User.where(email: 'solicitor2@example.com').first_or_create(
  email: 'solicitor2@example.com', password: 'password', role: :solicitor)
User.where(email: 'solicitor3@example.com').first_or_create(
  email: 'solicitor3@example.com', password: 'password', role: :solicitor)
User.where(email: 'solicitor4@example.com').first_or_create(
  email: 'solicitor4@example.com', password: 'password', role: :solicitor)
User.where(email: 'solicitor5@example.com').first_or_create(
  email: 'solicitor5@example.com', password: 'password', role: :solicitor)


NUMBER_OF_FIRMS = 10
SOLICITORS_PER_FIRM = 25
NUMBER_OF_SOLICITORS = NUMBER_OF_FIRMS * SOLICITORS_PER_FIRM

srand(100)

solicitor_names = Array.new(NUMBER_OF_SOLICITORS) { Faker::Name.name }
solicitor_emails = solicitor_names.map { |name| Faker::Internet.safe_email name }.to_enum

(1..NUMBER_OF_SOLICITORS).each do
  solicitor_email = solicitor_emails.next
  User.where(email: solicitor_email ).first_or_create(
    email: solicitor_email,
    password: 'password',
    role: :solicitor)
end
