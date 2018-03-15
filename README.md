# KeywordFinder

[![Code Climate](https://codeclimate.com/github/murb/keyword_finder.png)](https://codeclimate.com/github/murb/keyword_finder) [![Build Status](https://travis-ci.org/murb/keyword_finder.svg?branch=master)](https://travis-ci.org/murb/keyword_finder) [![Gem Version](https://badge.fury.io/rb/keyword_finder.svg)](http://badge.fury.io/rb/keyword_finder)

We were dealing with the following situation:

Given a set of the following keywords: "aardappelen", "zachtkokende aardappelen", "zout", "schimmelkaas", "kaas", "oude harde kaas", "kikkererwten", "maïs", "bruine bonen", "shiitake", "boter"

Can you recognize:

    "een grote pan zachtkokende aardappelen met een snufje zout"=>["zachtkokende aardappelen", "zout"],
    "schimmelkaas" => ["schimmelkaas"],
    "(schimmel)kaas" => ["schimmelkaas"],
    "old amsterdam (maar een andere oude harde kaas kan natuurlijk ook)" => ["oude harde kaas"],
    "g (verse) shiitake in bitesize stukjes gesneden" => ["shiitake"],
    "pot hak bonenmix (kikkererwten maïs kidney en bruine bonen) afgespoeld en uitgelekt" => ["kikkerwerwten", "maïs", "bruine bonen"],
    "g boter gesmolten en licht afgekoeld" => ["boter"]

Well, this gem helps you do this. It isn't rocket science, but if you need the functionality, go ahead (and submit improvements)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keyword_finder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keyword_finder

## Usage

Since above I wrote a small 'spec', here is the formal rspec:

    a = KeywordFinder::Keywords.new(["aardappelen", "zachtkokende aardappelen", "zout",
      "schimmelkaas", "kaas", "oude harde kaas", "kikkererwten", "maïs",
      "bruine bonen", "shiitake", "boter", "kidney bonen"])

    examples = {"een grote pan zachtkokende aardappelen met een snufje zout"=>["zachtkokende aardappelen", "zout"],
      "schimmelkaas" => ["schimmelkaas"],
      "(schimmel)kaas" => ["schimmelkaas"],
      "old amsterdam (maar een andere oude harde kaas kan natuurlijk ook)" => ["oude harde kaas"],
      "g (verse) shiitake in bitesize stukjes gesneden" => ["shiitake"],
      "pot hak bonenmix (kikkererwten, maïs, kidney en bruine bonen) afgespoeld en uitgelekt" => ["kikkererwten", "maïs", "bruine bonen"],
      "g boter gesmolten en licht afgekoeld" => ["boter"]}

    examples.each do |sentence, expected|
      expect( a.find_in(sentence) ).to eq(expected)
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/murb/keyword_finder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

