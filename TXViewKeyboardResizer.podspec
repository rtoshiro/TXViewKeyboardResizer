#
# Be sure to run `pod lib lint TXViewKeyboardResizer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TXViewKeyboardResizer"
  s.version          = "0.9.0"
  s.summary          = "UIView category to allow the target view to resize itself according to UIKeyboardView size"
  s.description      = <<-DESC
                       UIView category to allow the target view to resize itself according to UIKeyboardView size

Pod 'TXViewKeyboardResizer'
                       DESC
  s.homepage         = "https://github.com/rtoshiro/TXViewKeyboardResizer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "rtoshiro" => "rtoshiro@gmail.com" }
  s.source           = { :git => "https://github.com/rtoshiro/TXViewKeyboardResizer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TXViewKeyboardResizer' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
