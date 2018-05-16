# Restforce::Query

This gem provides a DSL for making restforce queries and avoid writing SOQL by hand.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'restforce-query'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restforce-query

## Usage

Example:
```ruby
Restforce::Query.select('LeadSource', 'COUNT(id)')
                .from('Opportunity')
                .where(StageName: 'Closed Won')
                .group_by('LeadSource')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/santi698/restforce-query.
