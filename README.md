# Eureka Bot telegram adapter

```ruby
# Telegram Echo server

require 'eureka-bot'

class TgController::CommandsController < TgController
  def start
    answer(
        method: 'sendMessage',
        params: {
            text:       'Hi! Please send me _some_ message',
            parse_mode: 'Markdown',
        }
    )
  end

  def help
    answer(
        method: 'sendMessage',
        params: {
            text: 'Just send message'
        }
    )
  end
end

class TgController::TextController < TgController
  def text
    answer(
        method: 'sendMessage',
        params: {
            text: message.dig('message', 'text'),
        }
    )
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eureka-bot-tg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eureka-bot-tg

## Usage

Please check examples directory

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dizer/eureka-bot-tg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

