Pod::Spec.new do |s|
  s.name             = 'EasyIAPs'
  s.version          = '0.1.0'
  s.summary          = 'An easy way to manage In App Purchases.’
  s.description      = 'An easy way to manage In App Purchases.’
  s.homepage         = 'https://github.com/alvinvarghese/EasyIAPs'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alvin Varghese' => 'alvinvarghese@live.com’ }
  s.source           = { :git => 'https://github.com/alvinvarghese/EasyIAPs.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/aalvinv'

  s.ios.deployment_target = ‘9.0’

  s.source_files = 'EasyIAPs/Classes/**/*'
  
  # s.resource_bundles = {
  #   'EasyIAPs' => ['EasyIAPs/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
