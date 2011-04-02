Sprtr
===

a twitter clone for fun in Sinatra and Redis.

Installation
----

Dependencies are managed trough bundler

    $ bundle install

Database
----

hm-news-filter will connect to Redis on localhost on the default port. You can specify an other setup if you set REDIS_URL in your environment, i.e.:

    $ REDIS_URL='redis://:secret@1.2.3.4:9000/3' ruby service.rb

This would connect to host 1.2.3.4 on port 9000, uses database number 3 using the password 'secret'.

Meta
----

Eger Andreas