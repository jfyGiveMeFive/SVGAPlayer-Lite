# SVGAPlayer-Lite

[![CocoaPods](https://img.shields.io/cocoapods/v/SVGAPlayerLite.svg)](https://cocoapods.org/pods/SVGAPlayerLite)
[![Platform](https://img.shields.io/cocoapods/p/SVGAPlayerLite.svg)](https://cocoapods.org/pods/SVGAPlayerLite)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/jfyGiveMeFive/SVGAPlayer-Lite/blob/main/LICENSE)
[![Stars](https://img.shields.io/github/stars/jfyGiveMeFive/SVGAPlayer-Lite.svg)](https://github.com/jfyGiveMeFive/SVGAPlayer-Lite/stargazers)

[中文文档](README_CN.md) | English

A lightweight, high-performance SVGA animation player optimized from SVGAPlayer.

## Performance Advantages

Compared to the original SVGAPlayer, SVGAPlayer-Lite achieves significant performance improvements:

- ⚡️ **40-50% Lower Memory Usage** - Reduced from 20MB to 12MB
- ⚡️ **40% Lower CPU Usage** - Reduced from 22% to 13%
- ⚡️ **50% Faster Startup** - Reduced from 185ms to 92ms
- 📦 **15-20% Smaller Package Size** - Removed outdated code
- 🎯 **Stable 60 FPS** - Optimized rendering performance

📊 **[View Detailed Optimization](OPTIMIZATION.md)**

## Features

- 🚀 Lightweight implementation with optimized performance and memory usage
- 📦 CocoaPods integration support
- 🎨 Full SVGA animation format support
- 💪 High-performance rendering engine
- 🔧 Easy integration and usage
- ✅ iOS 12.0+ support
- 🔥 **Perfect Swift Support** - [View Swift Compatibility Guide](SWIFT_COMPATIBILITY.md)

## Installation

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'SVGAPlayerLite'
```

Then run:

```bash
pod install
```

### Manual Integration

1. Clone or download this repository
2. Drag the `Source` folder into your project
3. Add dependencies:
   - SSZipArchive (2.4.3)
   - Protobuf (3.27.2)

## Usage

### Basic Usage

```objective-c
#import <SVGAPlayerLite/SVGA.h>

// Create player
SVGAPlayer *player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
[self.view addSubview:player];

// Create parser
SVGAParser *parser = [[SVGAParser alloc] init];

// Load from network
[parser parseWithURL:[NSURL URLWithString:@"https://example.com/animation.svga"]
     completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
    if (videoItem) {
        player.videoItem = videoItem;
        [player startAnimation];
    }
} failureBlock:^(NSError * _Nullable error) {
    NSLog(@"Load failed: %@", error);
}];

// Or load from local
[parser parseWithNamed:@"animation" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
    if (videoItem) {
        player.videoItem = videoItem;
        [player startAnimation];
    }
} failureBlock:nil];
```

### Swift Usage

```swift
import SVGAPlayerLite

// Create player
let player = SVGAPlayer(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.addSubview(player)

// Create parser
let parser = SVGAParser()

// Load from network
parser.parse(with: URL(string: "https://example.com/animation.svga"), completionBlock: { videoItem in
    player.videoItem = videoItem
    player.startAnimation()
}, failureBlock: { error in
    print("Load failed: \(error)")
})

// Or load from local
parser.parse(withNamed: "animation", in: nil, completionBlock: { videoItem in
    player.videoItem = videoItem
    player.startAnimation()
}, failureBlock: nil)
```

### Advanced Features

#### Loop Playback

```objective-c
player.loops = 0; // 0 means infinite loop
player.loops = 3; // Play 3 times
```

#### Playback Control

```objective-c
[player startAnimation];      // Start playback
[player pauseAnimation];      // Pause playback
[player stopAnimation];       // Stop playback
[player stepToFrame:10 andPlay:YES]; // Jump to specific frame
```

#### Dynamic Element Replacement

```objective-c
// Replace image
UIImage *image = [UIImage imageNamed:@"replacement"];
[player setImage:image forKey:@"key" referenceLayer:nil];

// Replace text
NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"Hello"];
[player setAttributedText:text forKey:@"key"];
```

#### Playback Callbacks

```objective-c
player.delegate = self;

// Implement delegate method
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    NSLog(@"Animation finished");
}
```

## Requirements

- iOS 12.0+
- Xcode 11.0+

## Dependencies

- SSZipArchive (2.4.3)
- Protobuf (3.27.2)

> Note: To ensure all users have the same dependency versions, this project uses fixed version numbers instead of version ranges.

## Differences from SVGAPlayer

SVGAPlayer-Lite is a lightweight version based on SVGAPlayer with the following improvements:

- Optimized memory management
- Improved rendering performance
- Simplified APIs
- Better stability

## License

Apache License 2.0

## Related Links

- [SVGA Official Website](http://svga.io/)
- [SVGAPlayer-iOS](https://github.com/svga/SVGAPlayer-iOS)

## Contributing

Issues and Pull Requests are welcome!

## Changelog

### 1.0.6 (2026-01-15)
- Add English documentation
- Add language switcher between Chinese and English
- Improve international accessibility

### 1.0.5 (2026-01-15)
- Lock dependency versions for consistency
- SSZipArchive fixed to 2.4.3
- Protobuf fixed to 3.27.2
- Prevent compatibility issues from version drift

### 1.0.4 (2026-01-15)
- Update dependency version constraints for better compatibility
- SSZipArchive updated to ~> 2.4
- Protobuf updated to ~> 3.27
- Improved dependency management strategy

### 1.0.3 (2025-01-14)
- Update author email for privacy protection
- Add comprehensive Swift compatibility documentation

### 1.0.2
- Performance optimization and dependency updates

### 1.0.1
- Add CocoaPods Trunk publishing guide

### 1.0.0
- Initial release
- CocoaPods integration support
- Optimized from SVGAPlayer
