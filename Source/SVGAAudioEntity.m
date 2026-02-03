//
//  SVGAAudioEntity.m
//  SVGAPlayer
//
//  Created by PonyCui on 2018/10/18.
//  Copyright © 2018年 UED Center. All rights reserved.
//

#import "SVGAAudioEntity.h"
#if SVGA_USE_SPM
#import <ProtobufObjC/Svga.pbobjc.h>
#else
#import "Svga.pbobjc.h"
#endif

@interface SVGAAudioEntity ()

@property (nonatomic, readwrite) NSString *audioKey;
@property (nonatomic, readwrite) NSInteger startFrame;
@property (nonatomic, readwrite) NSInteger endFrame;
@property (nonatomic, readwrite) NSInteger startTime;
    
@end

@implementation SVGAAudioEntity

- (instancetype)initWithProtoObject:(SVGAProtoAudioEntity *)protoObject {
    self = [super init];
    if (self) {
        _audioKey = protoObject.audioKey;
        _startFrame = protoObject.startFrame;
        _endFrame = protoObject.endFrame;
        _startTime = protoObject.startTime;
    }
    return self;
}
    
@end
