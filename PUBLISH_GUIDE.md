# 发布 SVGAPlayerLite 到 CocoaPods Trunk 指南

## 当前状态

✅ 项目已推送到 GitHub: https://github.com/jfyGiveMeFive/SVGAPlayer-Lite
✅ 版本标签已创建: 1.0.1
✅ Podspec 验证通过

## 发布步骤

### 1. 注册 CocoaPods Trunk 账号

如果你还没有注册过 CocoaPods Trunk 账号，需要先注册：

```bash
pod trunk register YOUR_EMAIL@example.com 'Your Name' --description='MacBook Pro'
```

**示例：**
```bash
pod trunk register aygtech@qq.com 'jfyGiveMeFive' --description='MacBook Pro'
```

执行后，CocoaPods 会发送一封验证邮件到你的邮箱。

### 2. 验证邮箱

1. 检查你的邮箱（包括垃圾邮件文件夹）
2. 点击邮件中的验证链接
3. 验证成功后，你就可以发布 Pod 了

### 3. 验证你的 Trunk 账号

```bash
pod trunk me
```

这会显示你的账号信息和已发布的 Pods。

### 4. 发布到 CocoaPods Trunk

```bash
cd /Users/ourtalk/Desktop/SVGAPlayer-Lite
pod trunk push SVGAPlayerLite.podspec --allow-warnings
```

**注意：**
- 使用 `--allow-warnings` 是因为有一些不影响功能的警告
- 发布过程可能需要几分钟
- 发布成功后，CocoaPods 会自动更新索引

### 5. 验证发布成功

发布成功后，等待 5-10 分钟，然后可以搜索你的 Pod：

```bash
pod search SVGAPlayerLite
```

或者访问 CocoaPods 官网查看：
https://cocoapods.org/pods/SVGAPlayerLite

## 使用方式

发布成功后，其他开发者可以通过以下方式使用：

### 方式一：直接使用（推荐）

```ruby
pod 'SVGAPlayerLite'
```

### 方式二：指定版本

```ruby
pod 'SVGAPlayerLite', '~> 1.0.1'
```

### 方式三：使用 Git（发布前或测试）

```ruby
pod 'SVGAPlayerLite', :git => 'https://github.com/jfyGiveMeFive/SVGAPlayer-Lite.git', :tag => '1.0.1'
```

## 更新版本

当你需要发布新版本时：

### 1. 修改代码并测试

### 2. 更新版本号

编辑 `SVGAPlayerLite.podspec`，修改版本号：
```ruby
s.version = "1.0.2"
```

### 3. 提交并推送

```bash
git add .
git commit -m "Release version 1.0.2"
git push origin main
```

### 4. 创建新标签

```bash
git tag 1.0.2
git push origin 1.0.2
```

### 5. 验证 podspec

```bash
pod spec lint SVGAPlayerLite.podspec --allow-warnings
```

### 6. 发布新版本

```bash
pod trunk push SVGAPlayerLite.podspec --allow-warnings
```

## 常见问题

### Q: 发布失败，提示 "Unable to find a pod with name"
A: 这是正常的，因为这是第一次发布。继续执行发布命令即可。

### Q: 发布后搜索不到
A: 等待 5-10 分钟让 CocoaPods 更新索引，然后更新本地 Pod 仓库：
```bash
pod repo update
pod search SVGAPlayerLite
```

### Q: 如何删除已发布的版本
A: CocoaPods 不支持删除已发布的版本。如果有问题，只能发布新版本修复。

### Q: 发布时提示权限错误
A: 确保你已经注册并验证了 CocoaPods Trunk 账号。运行 `pod trunk me` 检查。

### Q: 如何转移 Pod 所有权
A: 使用以下命令添加其他维护者：
```bash
pod trunk add-owner SVGAPlayerLite other-email@example.com
```

## 维护建议

1. **语义化版本控制**
   - 主版本号：不兼容的 API 修改
   - 次版本号：向下兼容的功能性新增
   - 修订号：向下兼容的问题修正

2. **更新日志**
   - 在 README.md 中维护 CHANGELOG
   - 每次发布都记录主要变更

3. **测试**
   - 发布前在实际项目中测试
   - 确保 podspec 验证通过

4. **文档**
   - 保持 README.md 更新
   - 提供清晰的使用示例

## 相关链接

- GitHub 仓库: https://github.com/jfyGiveMeFive/SVGAPlayer-Lite
- CocoaPods 官网: https://cocoapods.org
- CocoaPods Trunk 指南: https://guides.cocoapods.org/making/getting-setup-with-trunk.html

## 当前版本信息

- **版本**: 1.0.1
- **最低支持**: iOS 12.0+
- **依赖**:
  - SSZipArchive >= 1.8.1
  - Protobuf ~> 3.27
- **许可证**: Apache 2.0
