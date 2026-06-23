#
# Be sure to run `pod lib lint GFBaseTool.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'GFBaseTool'
  s.version          = '0.2.0'
  s.summary          = 'GFBaseTool 是一个 iOS 基础工具库'
  s.description      = <<-DESC
    GFBaseTool 提供常用 Extension、GCD 封装、Toast、网络请求、自定义控件等基础能力，
  适用于快速搭建 iOS 项目的基础设施层。
                       DESC

  s.homepage         = 'https://github.com/mapleleaf99/GFBaseTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '叫我锅先生' => 'mapleleaf99@126.com' }
  s.source           = { :git => 'https://github.com/mapleleaf99/GFBaseTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.0'

  s.subspec 'Core' do |core|
    core.source_files = 'GFBaseTool/Classes/Tool/**/*', 'GFBaseTool/Classes/Toast/**/*'
    core.dependency 'Toast-Swift', '5.0.1'
  end

  s.subspec 'Network' do |net|
    net.source_files = 'GFBaseTool/Classes/NetWork/**/*'
    net.dependency 'GFBaseTool/Core'
    net.dependency 'Alamofire', '~> 5.6.1'
  end

  s.default_subspecs = 'Core', 'Network'
end
