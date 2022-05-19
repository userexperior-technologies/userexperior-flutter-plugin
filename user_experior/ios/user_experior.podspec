#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'user_experior'
  s.version          = '2.1.7'
  s.summary          = 'Understand and fix user experience issues.'
  s.homepage         = 'https://www.userexperior.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'UserExperior' => 'hello@userexperior.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'UserExperior', '5.1.2'
  s.ios.deployment_target = '10.0'
  s.user_target_xcconfig    = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig     = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
