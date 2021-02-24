It's a Campaign Manager application designed with Ruby on Rails.

## Demo

Since its only server API's, demo of the software is not hosted on AWS or Heroku.
-- However you can still run it on a localhost with all the URI's and query params.

## How to run

- Pre-requisites: Ruby - ruby 2.7.0 or above, Rails 6.0.3.5 or above, PostgresSql - 12.1 or above
- Clone this Git repository to your development machine, and run `bundle install`
- Run local PostgreSql server `pg_ctl -D /usr/local/var/postgres start`
- Create initial data using `rails db:seed`
- Run test cases: 47 runs, 70 assertions, 0 failures, 0 errors, 0 skips: `rails test`
- Start the local web-server `rails server`

## Design spec

As a requirement or design spec for this project I chose to implement basic user interface from scratch instead of inbuilt authentication services like Devise, Clearance and AuthLogic, just to give basic understanding on how token based authentication works.

- Basic Authorization -- i.e. owner and non-owner users, without going into the complexity of role based authorization
- Basic Searching -- searching models based on keyword, user, time bound -- can be improvised with more complex queries
- Serializing JSON -- generic output format for APIs across all models -- optimal format to reduce JSON size and bandwidth


I've implemented these core model into the application:

- Campaigns
  - List campaigns (with sorting, filtering, and custom ordering)
  - Create new campaign
  - View, Update and Delete campaigns from owner profile
  - Start new discussion within a campaign
- Discussions
  - List discussions for all campaigns (with sorting and filtering)
  - Create new discussion
  - View, Update and Delete discussion from owner profile
  - Add new comments within a discussion
- Comments
  - List Comments (with sorting, filtering, and ordering)
  - Add new comments
  - Delete comments from owner profile
  - Search and List comments with in a discussion, user and tags
- Users
  - List users
  - View user profile
  - Add new, edit, delete users
  - View user activity (with tags and disucssions)
- Tags
  - List tags
  - List campaigns for each tag
  - Associate sub-tags to the tags
  - Remove tags automatically when its not tagged with any campaign

## Improvisations

More optimizations can be performed to improvise performace of production server.
  - Pagination: using will_paginate or kaminari gems 
  - API caching - based on frequency of usage
  - CORS activation - access to different sub-domains, fields, ports, protocols
  - SQL optimizations - improvised SQL queries for more complex search use-cases

