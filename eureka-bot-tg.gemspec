# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eureka_bot/tg/version'

Gem::Specification.new do |spec|
  spec.name          = "eureka-bot-tg"
  spec.version       = EurekaBot::Tg::VERSION
  spec.authors       = ["dizer"]
  spec.email         = ["dizeru@gmail.com"]

  spec.summary       = %q{Run your messenger bots}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 5.0.0'
  spec.add_dependency 'rest-client', '>= 2.0'

  spec.add_development_dependency 'rspec', '~> 3.6.0'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'webmock'
end
