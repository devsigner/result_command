Gem::Specification.new do |s|
  s.name        = 'SuperSimpleCommand'
  s.version     = '0.0.1'
  s.summary     = "Hola!"
  s.summary     = 'A Super Simple Command Chainable like Monad/Result'
  s.description = 'A Super Simple Command Chainable like Monad/Result'
  s.authors     = ['Cedric Darricau']
  s.email       = 'cedricdarricau@gmail.com'
  s.files       = ['lib/super_simple_command.rb']
  s.license     = 'MIT'

  s.add_development_dependency 'bundler', '~> 2.1'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.1'
end
