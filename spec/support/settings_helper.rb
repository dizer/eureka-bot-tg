module SettingsHelper
  def settings
    @settings ||= YAML.load_file('config/config.yml')['test']
  end
end
