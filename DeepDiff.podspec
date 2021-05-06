Pod::Spec.new do |s|
  s.name             = "DeepDiff"
  s.summary          = "Amazingly incredible extraordinary lightning fast diffing in Swift"
  s.version          = "2.2.0"
  s.homepage         = "https://github.com/onmyway133/DeepDiff"
  s.license          = 'MIT'
  s.author           = { "Khoa Pham" => "onmyway133@gmail.com" }
  s.source           = {
    :git => "https://github.com/onmyway133/DeepDiff.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/onmyway133'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.2'
  s.watchos.deployment_target = "6.0"

  s.requires_arc = true
  
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Shared}/**/*'
  s.tvos.source_files = 'Sources/{iOS,Shared}/**/*'
  s.watchos.source_files = 'Sources/Shared/**/*'

  s.ios.framework  = "UIKit"
  s.swift_version = '5.0'
end
