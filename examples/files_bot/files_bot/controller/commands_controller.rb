class FilesBot::Controller::CommandsController < FilesBot::Controller

  def start
    answer(
        method: 'sendMessage',
        params: {
            text:       [
                            '*Welcome!*',
                            'Please send me document'
                        ].join("\n"),
            parse_mode: 'Markdown',
        }
    )
  end

end