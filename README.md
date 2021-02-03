# Test::Remote::Redshift

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/test/remote/redshift`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'test-remote-redshift'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install test-remote-redshift

## Usage

database.yml
```
    url: <%= 
          Test::Remote::Redshift::Database.new(uri: ENV['REDSHIFT_CLUSTER_URL'], database_prefix: "test")
             .generate_database_with_schema_sql_file("#{::Rails.root}/spec/support/init_redshift_table.sql")
             .clean_old_database
             .redshift_uri 
         %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/test-remote-redshift.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
