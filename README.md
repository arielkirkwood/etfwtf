# etfwtf, by Ariel Kirkwood

Hello! This application is a "work sample" of sorts. I have built it to demonstrate my skills and knowledge with Ruby, the programming language and Rails, the Web framework.

## Ruby version

This application runs on Ruby 3.3.0 at a minimum.

## System dependencies

This application uses the PostgreSQL database to store and retrieve data.
                                                                                                                             
## Configuration

Configuration can be found in the `config/` folder.
                                                                                                                             
## Database creation

Run `rails db:create` to create the database for the relevant environment.
                                                                                                                             
## Database initialization

Whether `rails db:create` has been run or not, `rails db:setup` will create the database, load schema from `db/schema.rb`, as well as insert "seed data" into the database via the instructions in `db/seeds.rb`.

Once the database is seeded, you can run `rails holdings:extract` to fetch the latest holdings for each fund and save the fund's portfolio to the database.
                                                                                                                             
## How to run the test suite

No test suite to run yet.
                                                                                                                             
## Services (job queues, cache servers, search engines, etc.)

The only external service that runs as a dependency of `etfwtf` is [`trading-calendar`](https://github.com/apptastic-software/trading-calendar), a REST API that provides open/close market status for a few dozen markets.
                                                                                                                             
## Deployment instructions

I currently have an instance of `trading-calendar` deployed to [Fly.io](https://fly.io/); this works very well for a Docker-based application that needs little to no additional configuration.

For the `etfwtf` Rails application, I am deploying to a production environment in [Heroku](https://www.heroku.com/), which gives me a little better experience when running post-deploy commands to migrate or seed the database as well as run `rails holdings:extract`.
