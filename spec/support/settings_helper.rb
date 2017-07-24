module SettingsHelper

  def settings
    @settings ||= YAML.load_file('spec/config.yml')
  end

  def tg_token
    with_web? ? settings['token'].strip : 'MYTOKEN'
  end

  def chat_id
    with_web? ? settings['chat_id'] : 745
  end

  def with_web?
    self.class.metadata[:with_web]
  end
end
