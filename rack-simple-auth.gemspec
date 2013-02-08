Gem::Specification.new do |s|
  s.name        = 'rack-simple-auth'
  s.version     = '0.0.1'
  s.date        = '2013-02-08'
  s.summary     = 'A rack middleware for cookie authentication.'
  s.description = 'A middleware the prevents access to a rack app without the proper cookie.'

  s.required_ruby_version     = '>= 1.9.2'

  s.author   = 'Rob Law'
  s.email    = 'rob@robmadethis.com'
  s.homepage = 'http://robmadethis.com'

  s.files              = Dir['{lib}/*']

  s.add_dependency 'rack'
end