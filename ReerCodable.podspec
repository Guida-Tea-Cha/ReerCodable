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

  cache_root_rel   = "Library/Caches/ReerCodableMacros/#{s.version}"
  plugin_rel_path  = "#{cache_root_rel}/release/ReerCodableMacros-tool"


  s.prepare_command = <<-CMD
    set -e

    echo "[ReerCodable] Preparing macro plugin (swift build)..."

    BUILD_ROOT="$HOME/#{cache_root_rel}"
    TOOL_PATH="$BUILD_ROOT/release/ReerCodableMacros-tool"

    if [ -f "$TOOL_PATH" ]; then
      echo "[ReerCodable] Existing macro plugin found at $TOOL_PATH, skip swift build."
      exit 0
    fi

    echo "[ReerCodable] Building macro plugin into $BUILD_ROOT ..."
    mkdir -p "$BUILD_ROOT"

    swift build -c release --package-path "$PWD" --build-path "$BUILD_ROOT"

    if [ -f "$TOOL_PATH" ]; then
      echo "[ReerCodable] Macro plugin built at $TOOL_PATH"
    else
      echo "[ReerCodable] ERROR: Macro plugin not found at $TOOL_PATH after build." >&2
      exit 1
    fi

  CMD
  
  plugin_flag = "-Xfrontend -load-plugin-executable -Xfrontend $(HOME)/#{plugin_rel_path}#ReerCodableMacros"

  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => plugin_flag
  }

  s.user_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => plugin_flag
  }
end
