#
# Be sure to run `pod lib lint AlphaSwitcher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlphaSwitcher'
  s.version          = '1.0.0'
  s.summary          = 'Another toggle for iOS components'
  
  s.description      = <<-DESC
  Another toggle for iOS components with customizable
                       DESC

  s.homepage         = 'https://github.com/selesai/AlphaSwitcher.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tenko' => 'mrsdwdd@gmail.com' }
  s.source           = { :git => 'https://github.com/selesai/AlphaSwitcher.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = "5.4"

  s.source_files = 'AlphaSwitcher/*.{swift}'
end
