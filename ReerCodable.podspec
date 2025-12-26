#
# Be sure to run `pod lib lint ReerCodable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReerCodable'
  s.version          = '1.5.0'
  s.summary          = 'Codable extensions using Swift Macro'

  s.description      = <<-DESC
  Enhancing Swift's Codable Protocol Using Macros: A Declarative Approach to Serialization
                       DESC

  s.homepage         = 'https://github.com/Guida-Tea-Cha/ReerCodable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Asura19' => 'x.rhythm@qq.com' }
  s.source           = { :git => 'https://github.com/Guida-Tea-Cha/ReerCodable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = "10.15"
  s.watchos.deployment_target = "6.0"
  s.tvos.deployment_target = "13.0"
  s.visionos.deployment_target = "1.0"
  
  s.swift_versions = '5.10'

  s.source_files = 'Sources/ReerCodable/**/*'
  
  s.preserve_paths = ["Package.swift", "Sources/ReerCodableMacros", "Tests"]
  
  plugin_flag = '-Xfrontend -load-plugin-executable -Xfrontend $(PODS_BUILD_DIR)/ReerCodable/debug/ReerCodableMacros-tool#ReerCodableMacros'

  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => plugin_flag
  }

  s.user_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => plugin_flag
  }
  
  script = <<-SCRIPT
    BUILD_DIR="${PODS_BUILD_DIR}/ReerCodable"
    TOOL_DIR="${BUILD_DIR}/debug"
    TOOL_PATH="${TOOL_DIR}/ReerCodableMacros-tool"
    mkdir -p "$TOOL_DIR"
    echo "[ReerCodable] Building macro plugin with swift build 
    env -i PATH="$PATH" "$SHELL" -l -c "swift build -c release --package-path \"$PODS_TARGET_SRCROOT\" --build-path \"$BUILD_DIR\""
    echo "[ReerCodable] Macro plugin built at $TOOL_PATH"
  SCRIPT
  
  s.script_phase = {
    :name => 'Build ReerCodable macro plugin',
    :script => script,
    :execution_position => :before_compile,
    :output_files => [
      '${PODS_BUILD_DIR}/ReerCodable/release/ReerCodableMacros-tool'
    ]
  }
end
