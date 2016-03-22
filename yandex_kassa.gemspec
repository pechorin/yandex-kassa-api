# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yandex_kassa/version'

Gem::Specification.new do |spec|
  spec.name          = "yandex_kassa"
  spec.version       = YandexKassa::VERSION
  spec.authors       = ["Evgeniy Burdaev"]
  spec.email         = ["inqify@gmail.com"]

  spec.summary       = %q{Interaction with Yandex Kassa for Mass depositions}
  spec.description   = %q{Yandex Kassa API}
  spec.homepage      = "https://www.github.com/creepycheese/yandex-kassa-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "rest-client"
end
