# StructuredApi

**The aim:** A library you can use to write quick API calls, or (more usefully)
produce classes that - with a very simple DSL - cleanly describe the API to be
connected to.

Eventually, this will encompass:

 - [X] One-liner api calls, e.g. `StructuredApi.new.url("google.com").run!`
 - [X] Simple class-based dsl where you specify url, params, body etc
 - [X] Class hierarchy - e.g. create an ApplicationClient with auth settings,
 and extend that for each endpoint
 - [ ] Path hierarchy - e.g. FooApi set URL as 'foo.com', FooApi::V1 as '/v1', then endpoint
 - [ ] Data munging hooks - how do we transform our domain language into theirs?
 - [ ] Lifecycle hooks - e.g. easily log incoming / outgoing messages across your
 whole project
 - [ ] Virtual Attributes - e.g. specify that your API takes a customer, and use
 that customer in your data munging phase (or anywhere really)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'structured_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install structured_api

## Usage

The easy one-liner way:

```
StructuredApi::Endpoint.new.url('https://foo.com').verb(:get).params(q: 'whee').headers(x: :y).run!
```

The better way, define the way you want to connect using a structured DSL:

```
class MyBlogApi < StructuredApi::Endpoint
  url 'https://myblog.com/v1/' # can contain part of the path if you like, trailing slashes ignored
  headers { "Authorization" => "Basic aa11aa11aa11aa11aa11aa11aa=" }
end

class CreateBlogPost < MyBlogApi
  verb :post
  path '/posts' # leading slashes ignored
end

CreateBlogPost.new.body("<h1>Hello World!</h1>").run!
```

For more information on where we're heading with this, check out ONE_DAY.md

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/undecided/structured_api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
