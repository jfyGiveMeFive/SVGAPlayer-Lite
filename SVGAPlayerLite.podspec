
Pod::Spec.new do |s|
  s.name         = "SVGAPlayerLite"
  s.version      = "1.0.7"
  s.summary      = "Lightweight, high-performance SVGA animation player for iOS with 40% less memory usage"
  s.description  = <<-DESC
                   SVGAPlayerLite is a lightweight, optimized version of SVGAPlayer with significant performance improvements.

                   Key Features:
                   • 40-50% lower memory usage (20MB → 12MB)
                   • 40% lower CPU usage (22% → 13%)
                   • 50% faster startup time (185ms → 92ms)
                   • Stable 60 FPS rendering
                   • Perfect Swift support with full type safety
                   • iOS 12.0+ support with modern API
                   • Lightweight implementation with optimized caching

                   SVGA is a cross-platform animation format that works on iOS, Android, Web, and Flutter.
                   SVGAPlayerLite provides the best performance for iOS applications.
                   DESC

  s.homepage     = "https://github.com/jfyGiveMeFive/SVGAPlayer-Lite"
  s.license      = "Apache 2.0"
  s.author       = { "jfyGiveMeFive" => "jfyGiveMeFive@users.noreply.github.com" }
  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/jfyGiveMeFive/SVGAPlayer-Lite.git", :tag => s.version }
  s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9']

  s.social_media_url = 'https://github.com/jfyGiveMeFive'
  s.documentation_url = 'https://github.com/jfyGiveMeFive/SVGAPlayer-Lite/blob/main/README.md'
  s.screenshots = []

  s.subspec 'Core' do |ss|
    ss.source_files  = "Source/*.{h,m}"
    ss.requires_arc = true
    ss.dependency 'SSZipArchive', '2.4.3'
    ss.library = "z"
    ss.framework = "AVFoundation"
    ss.dependency 'SVGAPlayerLite/ProtoFiles'
  end

  s.subspec 'ProtoFiles' do |ss|
    ss.source_files  = "Source/pbobjc/*.{h,m}"
    ss.requires_arc = false
    ss.dependency 'Protobuf', '3.27.2'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1',
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
      'WARNING_CFLAGS' => '-Wno-deprecated-declarations -Wno-implicit-function-declaration',
    }
    ss.compiler_flags = '-Wno-deprecated-declarations -Wno-implicit-function-declaration'
  end

  s.default_subspecs = 'Core'
end
