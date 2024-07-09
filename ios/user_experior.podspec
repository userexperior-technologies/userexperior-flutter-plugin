#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint user_experior.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'user_experior'
  s.version          = '5.0.0'
  s.summary          = 'Understand and fix user experience issues.'
  s.description      = <<-DESC
'Understand and fix user experience issues..
                       DESC
  s.homepage         = 'https://www.userexperior.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'UserExperior' => 'hello@userexperior.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 i386' }
  s.pod_target_xcconfig  = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 i386' }
  s.swift_version = '5.0'

  s.dependency 'Flutter'
  s.dependency 'UserExperior', '6.0.7'
end
