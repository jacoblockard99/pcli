# frozen_string_literal: true

require_relative "lib/pcli/version"

Gem::Specification.new do |spec|
  spec.name = "pcli"
  spec.version = Pcli::VERSION
  spec.authors = ["Jacob Lockard"]
  spec.email = ["jacoblockard99@gmail.com"]

  spec.summary = "Ponsqb admin CLI."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  #

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'byebug'

  spec.add_dependency 'tty-option', '~> 0.2.0'
  spec.add_dependency 'tty-prompt', '~> 0.23.1'
  spec.add_dependency 'tty-cursor', '~> 0.7.1'
  spec.add_dependency 'tty-progressbar', '~> 0.18.2'
  spec.add_dependency 'tty-spinner', '~> 0.9.3'
  spec.add_dependency 'tty-screen', '~> 0.8.1'
  spec.add_dependency 'pastel', '~> 0.8.0'
  spec.add_dependency 'http', '~> 5.1'
  spec.add_dependency 'actionview', '~> 7.0'
  spec.add_dependency 'activesupport', '~> 7.0'
  spec.add_dependency 'dry-system', '~> 1.0'
end
