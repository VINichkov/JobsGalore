# Project Mango

This is an attempt to create an analogue of the popular sites hh.ru, monster.com, careere.com.au, superjob.ru, jora.com.au, seek.com.au

## Software Requirements

* Ruby and Rails
* PostgresSQL
* Redis
* React js
* Slim

## Installation

    git clone git://github.com/vnochkov/gobsgalore.git
    cd gobsgalore
    bundle
    
Then initialize the database and start the server:

    rake db:create
    rake db:migrate
    rake db:seed
    rails server

At this point you should have a working site with some basic seed data that you can start to customize.

## License

The MIT License - Copyright (c) 2018 Vyacheslav Nichkov
