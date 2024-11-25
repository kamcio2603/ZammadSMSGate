Gem::Specification.new do |s|
  s.name        = 'zammad_sms_gate'
  s.version     = '0.1.0'
  s.summary     = 'SMS Gate integration for Zammad'
  s.description = 'A Zammad package to send SMS directly from tickets using SMS Gate API'
  s.authors     = ['Your Name']
  s.email       = 'your.email@example.com'
  s.files       = Dir['{lib}/**/*', 'README.md']
  s.homepage    = 'https://github.com/yourusername/zammad_sms_gate'
  s.license     = 'MIT'
  s.add_dependency 'zammad', '~> 5.0'
  s.add_dependency 'httparty', '~> 0.18'
end

