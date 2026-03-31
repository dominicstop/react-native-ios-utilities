require 'json'

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name                    = package["name"]
  s.version                 = package['version']
  s.summary                 = package["description"]
  s.license                 = package["license"]

  s.author                  = package["author"]
  s.homepage                = package["homepage"]

  s.ios.deployment_target   = '13.4'
  s.tvos.deployment_target  = '13.0'
  s.visionos.deployment_target = '1.0'

  s.source                  = { :git => "https://github.com/dominicstop/react-native-ios-utilities.git", :tag => "v#{s.version}" }
  s.source_files            = 'ios/**/*.{h,m,mm,swift,cpp}', 'common/cpp/**/*.{h,cpp}'

  s.swift_version           = '5.4'

  # Swift dependencies
  s.dependency 'DGSwiftUtilities', '~> 0.46'
  s.dependency 'ComputableLayout', '~> 0.7'

  if defined?(install_modules_dependencies) then
    Pod::UI.puts("[react-native-ios-utilities] Using install_modules_dependencies")
    install_modules_dependencies(s)

    # Exclude Fabric files when not using New Architecture
    if !(ENV['RCT_NEW_ARCH_ENABLED'] == '1') then
      s.exclude_files = 'ios/Fabric/**', 'ios/Tests/**', 'common/cpp/fabric/**'
    else
      s.exclude_files = 'ios/Tests/**'
    end
  else
    Pod::UI.puts("[react-native-ios-utilities] Installing manually")

    if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
      folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
      s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"

      s.pod_target_xcconfig = {
        "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
        "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
        "DEFINES_MODULE" => "YES",
      }

      s.dependency "React-RCTFabric"
      s.dependency "React-Codegen"
      s.dependency "RCT-Folly"
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"

      s.exclude_files = 'ios/Tests/**'
    else
      s.dependency 'React-Core'
      s.exclude_files = 'ios/Fabric/**', 'ios/Tests/**', 'common/cpp/fabric/**'
    end
  end
end
