module EurekaBot
  module Tg
    extend ActiveSupport::Autoload

    autoload :Client
    autoload :Controller
    autoload :Resolver
    autoload :Sender
    autoload :Version
    autoload :Webhook

    cattr_accessor :client

    def self.rake_tasks
      Dir.glob(File.dirname(__FILE__) + '/tasks/*.rake')
    end

    def self.load_rake_tasks(rake)
      rake_tasks.each do |task|
        rake.send(:import, task)
      end
    end
  end
end
