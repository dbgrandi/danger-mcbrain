# danger-mcbrain

[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/dbgrandi/danger-mcbrain/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/danger-mcbrain.svg?style=flat)](http://rubygems.org/gems/danger-mcbrain)

Give Danger a memory, so she can check your PR today, and then answer questions about it tomorrow. Uses Redis for the persistence.

## Installation

    $ gem install danger-mcbrain

## Usage

Methods and attributes from this plugin are available in
your `Dangerfile` under the `brain` namespace.

You need to connect Danger's `brain` to a redis instance by
calling `brain.connect` somewhere in your `Dangerfile`. You
can pass any arguments into `connect` that you would normally
pass directly into `Redis.new`. You can read more about that
in their [Getting Started](https://github.com/redis/redis-rb#getting-started)
guide.

After you have connected, `brain` acts quite like a regular old
Ruby Hash, so you can use the `[]` operator and `[]=` operator to
get or set key/value pairs.

You can set a `namespace` on the `brain` if needed. This can be handy
in cases where you want to share a redis instance across multiple projecs
or repositories.

e.g.

```ruby
brain.namespace = "dbgrandi/danger-prose"

last_build_time = brain[last_pr + ":build_time"]

if last_build_time > build_time
    warn "Your build time is getting longer. #{last_pr}: #{last_build_time} -> #{pr}: #{build_time}"
end
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
