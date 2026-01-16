
Pod::Spec.new do |s|
  s.name         = "SVGAPlayerLite"
  s.version      = "1.0.4"
  s.summary      = "SVGAPlayerLite 是一个轻量级高性能的动画播放器"
  s.description  = <<-DESC
                   SVGAPlayerLite 是基于 SVGAPlayer 的轻量级版本；
                   SVGA 是一种全新的动画格式，由 YY UED 团队主导开发；
                   SVGA 让动画开发分工明确，大大减少动画交互的沟通成本，提升开发效率；
                   SVGA 可以在 iOS / Android / Web / Flutter 实现高性能的动画播放。
                   SVGAPlayerLite 提供了更轻量级的实现，优化了性能和内存占用。
                   DESC

  s.homepage     = "https://github.com/jfyGiveMeFive/SVGAPlayer-Lite"
  s.license      = "Apache 2.0"
  s.author       = { "jfyGiveMeFive" => "jfyGiveMeFive@users.noreply.github.com" }
  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/jfyGiveMeFive/SVGAPlayer-Lite.git", :tag => s.version }

  s.subspec 'Core' do |ss|
    ss.source_files  = "Source/*.{h,m}"
    ss.requires_arc = true
    ss.dependency 'SSZipArchive', '~> 2.4'
    ss.library = "z"
    ss.framework = "AVFoundation"
    ss.dependency 'SVGAPlayerLite/ProtoFiles'
  end

  s.subspec 'ProtoFiles' do |ss|
    ss.source_files  = "Source/pbobjc/*.{h,m}"
    ss.requires_arc = false
    ss.dependency 'Protobuf', '~> 3.27'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1',
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
      'WARNING_CFLAGS' => '-Wno-deprecated-declarations -Wno-implicit-function-declaration',
    }
    ss.compiler_flags = '-Wno-deprecated-declarations -Wno-implicit-function-declaration'
  end

  s.default_subspecs = 'Core'
end
