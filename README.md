# Project Mango

This is an attempt to create an analogue of the popular sites hh.ru, monster.com, careere.com.au, superjob.ru

## Software Requirements

* Ruby and Rails
* PostgresSQL
* React js
* Slim
* coffee script

## Installation

    git clone git://github.com/vnochkov/mongo.git
    cd mongo
    bundle
    
Then initialize the database and start the server:

    rake db:create
    rake db:migrate
    rake db:seed
    rails server

At this point you should have a working site with some basic seed data that you can start to customize.

## ER Diagram
 ![Image alt](https://github.com/vnichkov/mongo/raw/master/diagram.png)

## License

The MIT License - Copyright (c) 2016 Vyacheslav Nichkov