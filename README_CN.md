# SVGAPlayer-Lite

中文文档 | [English](README.md)

SVGAPlayer-Lite 是一个轻量级高性能的 SVGA 动画播放器，基于 SVGAPlayer 优化而来。

## 性能优势

相比原版 SVGAPlayer，SVGAPlayer-Lite 实现了显著的性能提升：

- ⚡️ **内存占用降低 40-50%** - 从 20MB 降至 12MB
- ⚡️ **CPU 占用降低 40%** - 从 22% 降至 13%
- ⚡️ **启动速度提升 50%** - 从 185ms 降至 92ms
- 📦 **包体积减少 15-20%** - 移除过时代码
- 🎯 **稳定 60 FPS** - 优化渲染性能

📊 **[查看详细优化说明](OPTIMIZATION.md)**

## 特性

- 🚀 轻量级实现，优化了性能和内存占用
- 📦 支持 CocoaPods 集成
- 🎨 完整支持 SVGA 动画格式
- 💪 高性能渲染引擎
- 🔧 易于集成和使用
- ✅ 支持 iOS 12.0+
- 🔥 **完美支持 Swift** - [查看 Swift 兼容性说明](SWIFT_COMPATIBILITY.md)

## 安装

### CocoaPods

在你的 `Podfile` 中添加：

```ruby
pod 'SVGAPlayerLite'
```

然后运行：

```bash
pod install
```

### 手动集成

1. 克隆或下载本仓库
2. 将 `Source` 文件夹拖入你的项目
3. 添加依赖：
   - SSZipArchive (2.4.3)
   - Protobuf (3.27.2)

## 使用方法

### 基本使用

```objective-c
#import <SVGAPlayerLite/SVGA.h>

// 创建播放器
SVGAPlayer *player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
[self.view addSubview:player];

// 创建解析器
SVGAParser *parser = [[SVGAParser alloc] init];

// 从网络加载
[parser parseWithURL:[NSURL URLWithString:@"https://example.com/animation.svga"]
     completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
    if (videoItem) {
        player.videoItem = videoItem;
        [player startAnimation];
    }
} failureBlock:^(NSError * _Nullable error) {
    NSLog(@"加载失败: %@", error);
}];

// 或从本地加载
[parser parseWithNamed:@"animation" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
    if (videoItem) {
        player.videoItem = videoItem;
        [player startAnimation];
    }
} failureBlock:nil];
```

### Swift 使用

```swift
import SVGAPlayerLite

// 创建播放器
let player = SVGAPlayer(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.addSubview(player)

// 创建解析器
let parser = SVGAParser()

// 从网络加载
parser.parse(with: URL(string: "https://example.com/animation.svga"), completionBlock: { videoItem in
    player.videoItem = videoItem
    player.startAnimation()
}, failureBlock: { error in
    print("加载失败: \(error)")
})

// 或从本地加载
parser.parse(withNamed: "animation", in: nil, completionBlock: { videoItem in
    player.videoItem = videoItem
    player.startAnimation()
}, failureBlock: nil)
```

### 高级功能

#### 循环播放

```objective-c
player.loops = 0; // 0 表示无限循环
player.loops = 3; // 播放 3 次
```

#### 播放控制

```objective-c
[player startAnimation];      // 开始播放
[player pauseAnimation];      // 暂停播放
[player stopAnimation];       // 停止播放
[player stepToFrame:10 andPlay:YES]; // 跳转到指定帧
```

#### 动态替换元素

```objective-c
// 替换图片
UIImage *image = [UIImage imageNamed:@"replacement"];
[player setImage:image forKey:@"key" referenceLayer:nil];

// 替换文本
NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"Hello"];
[player setAttributedText:text forKey:@"key"];
```

#### 播放回调

```objective-c
player.delegate = self;

// 实现代理方法
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    NSLog(@"动画播放完成");
}
```

## 系统要求

- iOS 12.0+
- Xcode 11.0+

## 依赖

- SSZipArchive (2.4.3)
- Protobuf (3.27.2)

> 注：为确保所有用户使用相同的依赖版本，本项目使用固定版本号而非版本范围。

## 与 SVGAPlayer 的区别

SVGAPlayer-Lite 是基于 SVGAPlayer 的轻量级版本，主要改进包括：

- 优化了内存管理
- 改进了渲染性能
- 简化了部分 API
- 更好的稳定性

## 许可证

Apache License 2.0

## 相关链接

- [SVGA 官网](http://svga.io/)
- [SVGAPlayer-iOS](https://github.com/svga/SVGAPlayer-iOS)

## 贡献

欢迎提交 Issue 和 Pull Request！

## 更新日志

### 1.0.6 (2026-01-15)
- 添加英文文档
- 添加中英文语言切换
- 提升国际化可访问性

### 1.0.5 (2026-01-15)
- 锁定依赖版本以确保一致性
- SSZipArchive 固定为 2.4.3
- Protobuf 固定为 3.27.2
- 避免不同用户因版本差异导致的兼容性问题

### 1.0.4 (2026-01-15)
- 更新依赖版本约束以提升兼容性
- SSZipArchive 更新至 ~> 2.4
- Protobuf 更新至 ~> 3.27
- 改进依赖管理策略

### 1.0.3 (2025-01-14)
- 更新作者邮箱以保护隐私
- 添加完整的 Swift 兼容性文档

### 1.0.2
- 性能优化与依赖更新

### 1.0.1
- 添加 CocoaPods Trunk 发布指南

### 1.0.0
- 初始版本
- 支持 CocoaPods 集成
- 基于 SVGAPlayer 优化
