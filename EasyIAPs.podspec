#
# Be sure to run `pod lib lint EasyIAPs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyIAPs'
  s.version          = '0.1.0'
  s.summary          = 'An easy way to manage In App Purchases.’

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/alvinvarghese/EasyIAPs'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alvin Varghese' => 'alvinvarghese@live.com’ }
  s.source           = { :git => 'https://github.com/alvinvarghese/EasyIAPs.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/aalvinv'

  s.ios.deployment_target = '8.0'

  s.source_files = 'EasyIAPs/Classes/**/*'
  
  # s.resource_bundles = {
  #   'EasyIAPs' => ['EasyIAPs/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
