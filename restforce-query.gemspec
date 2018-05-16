
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restforce/query/version'

Gem::Specification.new do |spec|
  spec.name          = 'restforce-query'
  spec.version       = Restforce::Query::VERSION
  spec.authors       = ['Santiago Ocamica']
  spec.email         = ['santi6982@gmail.com']

  spec.summary       = 'A Query DSL for Restforce'
  spec.homepage      = 'https://github.com/santi698/restforce-query'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'restforce'
end
