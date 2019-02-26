Pod::Spec.new do |s|
  s.name             = "DeepDiff"
  s.summary          = "Diff in Swift"
  s.version          = "2.0.0"
  s.homepage         = "https://github.com/onmyway133/DeepDiff"
  s.license          = 'MIT'
  s.author           = { "Khoa Pham" => "onmyway133@gmail.com" }
  s.source           = {
    :git => "https://github.com/onmyway133/DeepDiff.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/onmyway133'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.2'
  s.watchos.deployment_target = "3.0"

  s.requires_arc = true
  
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Shared}/**/*'
  s.tvos.source_files = 'Sources/{iOS,Shared}/**/*'
  s.watchos.source_files = 'Sources/Shared/**/*'

  s.ios.framework  = "UIKit"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
