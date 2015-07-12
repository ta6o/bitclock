Gem::Specification.new do |s|
  s.name        = 'bitclock'
  s.version     = '0.0.1'
  s.date        = '2015-07-11'
  s.summary     = "A digital clock for your terminal"
  s.description = "Automatically resizes itself on the terminal, with customizable colors!"
  s.authors     = ["Yakup Cetinkaya"]
  s.email       = 'yakup.cetinkaya@gmail.com'
  s.files       = ["lib/bitclock.rb"]
  s.homepage    =
    'http://rubygems.org/gems/bitclock'
  s.license       = 'GPL-3.0'
  s.platform = Gem::Platform.local
  s.add_runtime_dependency 'rainbow', '~> 2.0', '>= 2.0.0'
  s.executables << 'bitclock'
end
