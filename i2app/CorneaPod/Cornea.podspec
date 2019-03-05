#
# Be sure to run `pod lib lint Cornea.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Cornea'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Cornea.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Communicate with the Arcus Platform using Observables"
  s.homepage         = ''
  s.license          = { :type => '', :file => '' }
  s.author           = { ''s' => '' }
  s.source           = { :path => "." }

  s.ios.deployment_target = '8.0'
  s.swift_version = '3.2'
  s.source_files = 'Cornea/Classes/**/*', 'Cornea/Classes/**/**/*' # Only have 2 Levels of Files
  
  # s.resource_bundles = {
  #   'Cornea' => ['CorneaPod/Assets/*.png']
  # }

  s.public_header_files = 'Cornea/Classes/PublicHeaders/*.h', 'Cornea/Classes/**/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency  'PromiseKit/Promise'
  s.dependency  'CocoaLumberjack/Swift', '~> 3.0'
  s.dependency  'Locksmith'
  s.dependency  'Starscream', '2.1.1'
  s.dependency  'RxSwift'
  s.dependency  'RxSwiftExt', '2.5.1'
  s.dependency  'RxReachability'
end
