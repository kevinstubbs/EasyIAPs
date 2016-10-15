Pod::Spec.new do |s|
  s.name = 'EasyIAPs'
  s.version = '0.1.0'
  s.platform = :ios, '9.0'
  s.license = 'MIT'
  s.summary = 'Helping you to manage your In-App Purchases easily.'
  s.homepage = 'https://github.com/alvinvarghese/EasyIAPs'
  s.author = { 'Alvin Varghese' => 'alvinvarghese@live.com' }
  s.source = { :git => 'https://github.com/alvinvarghese/EasyIAPs.git', :tag => s.version.to_s }

  s.description = 'This library provides a an easy way to manage In-App Purchases '      \
                  'in your iOS app'
  s.frameworks = 'UIKit', 'Foundation'
  s.social_media_url = 'https://twitter.com/aalvinv'
  s.ios.deployment_target = '9.0'
  s.source_files = 'EasyIAPs/**/*.{swift}'
  s.frameworks = 'UIKit', 'Foundation'

end
