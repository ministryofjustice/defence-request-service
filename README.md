# Defence Solicitor Deployment System

[![Code Climate](https://codeclimate.com/github/ministryofjustice/defence-solicitor/badges/gpa.svg)] (https://codeclimate.com/github/ministryofjustice/defence-solicitor)

[![Test Coverage](https://codeclimate.com/github/ministryofjustice/defence-solicitor/badges/coverage.svg)] (https://codeclimate.com/github/ministryofjustice/defence-solicitor)

## Environment Variables
See .env.development or .env.test

Override local ENV variables in .env.local [dotenv docs](https://github.com/bkeepers/dotenv#multiple-rails-environments)

## Local Setup

To get the application running locally, you need to:

 * ### Clone the repository
 	``` git clone git@github.com:ministryofjustice/defence-request-service.git```

 * ### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * ### Install postgres
 	http://www.postgresql.org/

 * ### Bundle the gems
       cd defence-request-service
       bundle install

 * ### Create and migrate the database; run seeds

 		bundle exec rake db:create
 		bundle exec rake db:migrate
 		bundle exec rake db:seed

 * ### Follow the same steps to set up the auth app

 	This application uses a corresponding oauth server, which will also need to be running locally. It can be found [here](https://github.com/ministryofjustice/defence-request-service-auth)

 * ### Start both servers

 		cd defence-request-service && bundle exec rails server
 		cd defence-request-service-auth && bundle exec rails server

 * ### Use the app

 	You can find the service app running on `http://localhost:12121`

### Test setup

To run the tests, you will need to install [PhantomJS](http://phantomjs.org/), the test suite is known to be working with version `1.9.7`, it may or may not work with other versions. To run the tests, use the command: ```bundle exec rake```


