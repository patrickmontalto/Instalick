#
# Be sure to run `pod lib lint SwiftNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftNetworking'
  s.version          = '0.1.4'
  s.summary          = 'A micro networking framework for Swift'

  s.description      = 'SwiftNetworking provides a thin NetworkClient class that builds and executes URLRequests.'

  s.homepage         = 'https://github.com/patrickmontalto/SwiftNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'patrick.montalto@adnas.com' => 'pmontalto@gmail.com' }
  s.source           = { :git => 'https://github.com/patrickmontalto/SwiftNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftNetworking/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
