# Psyduck

A very basic ftp client using the Ruby Net::FTP class

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'psyduck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install psyduck

## Usage

```ruby
  @ftp_client = Psyduck::FTPClient.new(
    ip_address: '127.0.0.1',
    username: 'username',
    password: 'password',
    command_port: 21212)

  @ftp_client.connect
  @ftp_client.login
  @ftp_client.ftp.mkdir('remote_directory/')
  @ftp_client.upload_file_to_server('file_for_upload.txt', 'remote_directory/')
  @ftp_client.ftp.close
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/psyduck. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

