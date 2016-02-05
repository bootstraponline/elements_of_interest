require_relative 'lib/elements_of_interest/version'

# rubocop:disable Style/SpaceAroundOperators

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.2.2'

  spec.name        = 'elements_of_interest'
  spec.version     = ElementsOfInterest::VERSION
  spec.date        = ElementsOfInterest::DATE
  spec.license     = 'http://www.apache.org/licenses/LICENSE-2.0.txt'
  spec.description = spec.summary = 'Detect elements of interest from XCUITest Xcode logs'
  spec.description   += '.' # avoid identical warning
  spec.authors       = spec.email = ['code@bootstraponline.com']
  spec.homepage      = 'http://internal'
  spec.require_paths = ['lib']
  spec.executables   = ['elements_of_interest']

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|swift)/})
  end

  spec.add_runtime_dependency 'plist', '~> 3.1'
  spec.add_development_dependency 'thor', '>= 0.19.1'
  spec.add_development_dependency 'rubocop', '>= 0.36.0'
  spec.add_development_dependency 'pry', '~> 0.10.3'
  spec.add_development_dependency 'rspec', '~> 3.4'
end
