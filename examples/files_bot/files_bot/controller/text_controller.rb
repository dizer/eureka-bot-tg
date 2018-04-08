class FilesBot::Controller::TextController < FilesBot::Controller

  def text
    answer(
        method: 'sendMessage',
        params: {
            text: 'Please send me document'
        }
    )
  end

end