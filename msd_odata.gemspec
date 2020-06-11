
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "msd_odata/version"

Gem::Specification.new do |spec|
  spec.name          = "msd_odata"
  spec.version       = MsdOdata::VERSION

  spec.authors       = ["Hungerstation team"]
  spec.email         = ["tech@hungerstation"]

  spec.summary       = "Microsoft dynamics AX integration library"
  spec.description   = "Microsoft dynamics AX integration library"
  spec.homepage      = "https://github.com/hungerstation/msd_ruby.git"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"

  spec.add_dependency 'faraday'
  spec.add_dependency 'json'
end
