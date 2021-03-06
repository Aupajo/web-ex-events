# WebEx::Events

[![Gem Version](https://badge.fury.io/rb/web-ex-events.png)](http://badge.fury.io/rb/web-ex-events)
[![Build Status](https://travis-ci.org/Aupajo/web-ex-events.png?branch=master)](https://travis-ci.org/Aupajo/web-ex-events)
[![Code Climate](https://codeclimate.com/github/Aupajo/web-ex-events.png)](https://codeclimate.com/github/Aupajo/web-ex-events)

A library to read WebEx events through the WebEx API.

Tested against Ruby 2.0.0, 2.1.0, 2.1.1.

## Installation

Add this line to your application's Gemfile:

    gem 'web-ex-events'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install web-ex-events

## Usage

```ruby
require 'web_ex/events'

# Set WebEx site name
ENV['WEB_EX_SITE_NAME'] = "…"

# WebEx Site and Partner ID (available through WebEx support request)
ENV['WEB_EX_SITE_ID'] = "…"
ENV['WEB_EX_PARTNER_ID'] = "…"

# Your WebEx credentials
ENV['WEB_EX_USERNAME'] = "…"
ENV['WEB_EX_PASSWORD'] = "…"

next_30_days = 30 * 24 * 60 * 60
events = WebEx::Events::Event.fetch(next_30_days)

# Print event details
events.each do |event|
  puts event.name
  puts event.start_date
  puts "#{event.duration} mins"
  puts event.description
end

# Print all events as JSON
puts events.to_json
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
