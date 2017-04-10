# README

This is a simple API style rails app to handle creating/accepting/declining/etc
invitations. At a high level once admin user posts JSON to create invitation
for a user then, if necessary, the event is also created.

* The API is versioned
* The ability to create invitations/events has authentication
* Regular users can view invitation once they have the unique URI
* Regular users can accept/decline/tentative accept and invitation
* Invitations belong to Events
* Events can be recurring. There is a simple PORO class to handle the recurring
  events.
* Each invitation is unique to a particular user
* Some integration tests have been written using minitest

Things you may want to cover:

* Ruby version
2.2.2

* System dependencies
none

* Configuration
bundle install

* Database creation
Simple PostgreSQL db used for this. Change credentials in config/database.yml
You will need to create a db and allow user access.

* Database initialization
Simply run migrations
Add seed data if you wish.

* How to run the test suite
rails test test
