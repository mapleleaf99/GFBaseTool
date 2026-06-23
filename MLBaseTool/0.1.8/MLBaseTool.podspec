#
# Be sure to run `pod lib lint GFBaseTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GFBaseTool'
  s.version          = '0.1.8'
  s.summary          = 'GFBaseTool是一个基础工具类'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        GFBaseTool是一个基础工具类..
                        DESC

  s.homepage         = 'https://github.com/mapleleaf99/GFBaseTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '叫我锅先生' => 'mapleleaf99@126.com' }
  s.source           = { :git => 'https://github.com/mapleleaf99/GFBaseTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.0'

  s.source_files = 'GFBaseTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GFBaseTool' => ['GFBaseTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Alamofire', '~> 5.6.1'
   s.dependency 'Toast-Swift', '5.0.1'
end
