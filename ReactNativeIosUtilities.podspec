require 'json'

package = JSON.parse(File.read(File.join(__dir__, './', 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'ReactNativeIosUtilities'
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platform       = :ios, '13.0'
  s.swift_version  = '5.4'
  s.source         = { git: 'https://github.com/dominicstop/react-native-ios-utilities' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'
  s.dependency 'DGSwiftUtilities', '~> 0.46.3'
  s.dependency 'ComputableLayout', '~> 0.7'

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }
  
  s.source_files  = "ios/**/*.{h,m,mm,swift}"
end
