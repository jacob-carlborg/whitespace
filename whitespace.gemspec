# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whitespace/version'

Gem::Specification.new do |spec|
  spec.name          = 'whitespace'
  spec.version       = Whitespace::VERSION
  spec.authors       = ['Jacob Carlborg']
  spec.email         = ['jacob.carlborg@snowmen.se']

  spec.summary       = 'Tool for validating and stripping whitespace'
  spec.description   = 'Tool for validating and stripping whitespace'
  spec.homepage      = 'http://gitlab.a.snowmen.se/tools/whitespace'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'pry-byebug', '~> 3.3'
  spec.add_development_dependency 'pry-rescue', '~> 1.4'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redcarpet', '~> 3.3'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 0.38'
  spec.add_development_dependency 'yard', '~> 0.8.7'
end
