class EurekaBot::Tg::Utils

  def self.detect_photo(photos, expected_size = {})
    bigger = photos.select do |photo|
      expected_size.map do |dimension, value|
        photo[dimension] >= value
      end.all?
    end

    if bigger.any?
      bigger.min_by { |photo| photo['file_size'] }
    else
      photos.max_by { |photo| photo['file_size'] }
    end
  end

  def self.cached_file(url)
    require 'open-uri'
    file = File.new(['/tmp', SecureRandom.uuid + '.' + url.split('.').last[-3..-1].to_s].join('/'), 'w+')
    file.binmode
    file.path
    file.write(open(url).read)
    file.rewind
    file
  end

  def self.file_url(telegram_client, file_id)
    file = telegram_client.api.getFile(file_id: file_id)
    "https://api.telegram.org/file/bot#{telegram_client.api.token}/#{file['result']['file_path']}"
  rescue Faraday::ConnectionFailed => e
    retry if (_r = (_r || 0) + 1) and _r < 4
    raise
  end

end
