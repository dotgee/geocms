What is GeoCMS ?
================

GeoCMS is a complete open source solution that allows for the vizualisation of geospatial data on the web built with Ruby on Rails, AngularJS and LeafletJS.
It was built to make it easier for people to consume geospatial data from multiple data sources that are [OGC-compliant] like GeoServer, MapServer ...

GeoCMS actually consists of several different gems, each of which are maintained in a single repository. By requiring the GeoCMS gem you automatically require all of the necessary gem dependencies which are:

* geocms_api (RESTful API)
* geocms_frontend (User-facing components)
* geocms_backend (Admin area)
* geocms_core (Models & Mailers, the basic components of geocms that it can't run without)

All of the gems are designed to work together to provide a vizualisation platform. It is also possible, however, to use only the pieces you are interested in. For example, you could use just the barebones geocms_core gem and build your own user facing interface on top of it.

You can see real-world applications built with GeoCMS at [indigeo.fr], check it out !

[OGC-compliant]: http://www.opengeospatial.org/standards/is
[indigeo.fr]: http://portail.indigeo.fr

![screenshot 2015-03-30 16 41 46](https://cloud.githubusercontent.com/assets/874392/6898676/c49d996e-d6fb-11e4-9e02-28560b958074.png)

Features
--------

With GeoCMS, you can define multiple data sources and pick the data you want to manipulate in your maps.
You can then create maps using these data, combining them and using the multiple tools to manipulate them like opacity or timeline.

Once you are done editing your map, you can save it to retrieve it later and share it with the world with a direct link or embedded in any site !

![screenshot 2015-03-30 16 51 22](https://cloud.githubusercontent.com/assets/874392/6898879/04d812ba-d6fd-11e4-9298-8961490fc67d.png)

![screenshot 2015-03-30 16 46 06](https://cloud.githubusercontent.com/assets/874392/6898775/49f62644-d6fc-11e4-998b-d59ccf99a38d.png)

Installation guide
==================

Dependencies
------------

In order for GeoCMS to work properly, you will need the following installed :
* Ruby 2.1.0 and greater
* Rails 4.1 and greater
* PostgreSQL 9.1 and greater
* Redis-server
* NodeJS
* ImageMagick

Guide
-----

The installation process should be straightforward once you make sure that all dependecies are installed.

* Create a new Rails application :
```bash
$ gem install rails -v 4.1.8
$ rails new myapp -D postgresql
```

* Install GeoCMS in your app :

To use a stable build of GeoCMS, you can manually add GeoCMS to your
Rails application. To use the 2-4-stable branch of GeoCMS, add this line to
your Gemfile.

```ruby
gem 'geocms', github: 'dotgee/geocms', branch: '2-0-stable'
```

Alternatively, if you want to use the bleeding edge version of GeoCMS, use this
line:

```ruby
gem 'geocms', github: 'dotgee/geocms'
```

* Install GeoCMS migrations and data : 

```bash
$ bundle exec rake railties:install:migrations
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
```

* Mount GeoCMS in your application (in config/routes.rb) :

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Geocms::Core::Engine, :at => "/"
end
```

This is it ! You can run your application and everything should "just work" ™
If you run into issues, you should make sure you do have a Geocms::Account in your database, defined with "default: true".

Roadmap
-------

* Support vector layers (GeoJSON)
* Responsive layout
* CQL Filters
* Normalized plugin structure

Authors
-------

* [@jchapron](https://github.com/jchapron)
* [@almerino](https://github.com/almerino)
* [@dotgee](https://github.com/dotgee)

Contributing
------------

GeoCMS is an open source project and we encourage contributions.

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways **you** can contribute:

* by using prerelease versions / master branch
* by reporting [bugs](https://github.com/jchapron/geocms/issues/new)
* by writing or editing documentation
* by writing [specs](https://github.com/jchapron/geocms/labels/specs)
* by writing [needed code](https://github.com/jchapron/geocms/labels/code) or [finishing code](https://github.com/jchapron/geocms/labels/stalled)
* by [refactoring code](https://github.com/jchapron/geocms/labels/performance)
* by resolving [issues](https://github.com/jchapron/geocms/issues)
* by reviewing [pull requests](https://github.com/jchapron/geocms/pulls)

Licence
-------

`GeoCMS` is releasedd under the [GNU GENERAL PUBLIC LICENSE](https://www.gnu.org/licenses/gpl-3.0.html).  See the [`LICENSE.md`](https://github.com/dotgee/geocms/blob/master/LICENSE.md) file.
