class FilesBot::Controller::DocumentsController < FilesBot::Controller

  def document
    caption = message.dig('message', 'caption').presence || params.dig(:document, 'file_name')
    link    = client.get_file_url(params.dig(:document, 'file_id'))
    answer(
        method: 'sendMessage',
        params: {
            text:       "Download file: [#{caption}](#{link})",
            parse_mode: 'Markdown',
        }
    )
  end

end