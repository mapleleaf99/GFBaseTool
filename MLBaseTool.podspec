#
# Be sure to run `pod lib lint MLBaseTool.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'MLBaseTool'
  s.version          = '0.3.0'
  s.summary          = 'MLBaseTool 是一个 iOS 基础工具库'
  s.description      = <<-DESC
    MLBaseTool 提供常用 Extension、GCD 封装、Toast、网络请求、存储、权限、UI 组件等基础能力，
  适用于快速搭建 iOS 项目的基础设施层。
                       DESC

  s.homepage         = 'https://github.com/mapleleaf99/MLBaseTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '叫我锅先生' => 'mapleleaf99@126.com' }
  s.source           = { :git => 'https://github.com/mapleleaf99/MLBaseTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.0'

  s.subspec 'Core' do |core|
    core.source_files = 'MLBaseTool/Classes/Tool/**/*', 'MLBaseTool/Classes/Toast/**/*'
    core.dependency 'Toast-Swift', '5.0.1'
  end

  s.subspec 'Storage' do |storage|
    storage.source_files = 'MLBaseTool/Classes/Storage/**/*'
    storage.frameworks = 'Security'
    storage.dependency 'MLBaseTool/Core'
  end

  s.subspec 'Permission' do |permission|
    permission.source_files = 'MLBaseTool/Classes/Permission/**/*'
    permission.frameworks = 'AVFoundation', 'Photos', 'CoreLocation', 'UserNotifications'
    permission.dependency 'MLBaseTool/Core'
  end

  s.subspec 'UI' do |ui|
    ui.source_files = 'MLBaseTool/Classes/UI/**/*'
    ui.dependency 'MLBaseTool/Core'
  end

  s.subspec 'Network' do |net|
    net.source_files = 'MLBaseTool/Classes/NetWork/**/*'
    net.dependency 'MLBaseTool/Core'
    net.dependency 'Alamofire', '~> 5.6.1'
  end

  s.default_subspecs = 'Core', 'Storage', 'Permission', 'UI', 'Network'
end
