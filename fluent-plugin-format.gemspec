# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-format"
  spec.version       = "0.0.1"
  spec.authors       = ["Akinori Machino"]
  spec.email         = ["akinori.machino@icloud.com"]
  spec.description   = %q{Output plugin to format fields of records and re-emit them.}
  spec.summary       = %q{Output plugin to format fields and re-emit them.}
  spec.homepage      = "https://github.com/mach/fluent-plugin-format"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fluentd"
  spec.add_runtime_dependency "fluentd"
end
