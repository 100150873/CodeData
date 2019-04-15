//
//  SFNetworkDetectionObj.m
//  NIM
//
//  Created by gzc on 2019/4/9.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import "SFNetworkDetectionObj.h"
#import "XCSessionDefines.h"
#import "NSObject+SBJson.h"

@implementation SFNetworkDetectionObj

+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    
    return [SFNetworkDetectionObj yy_modelWithDictionary:dict];
}

#pragma mark NIMCustomAttachment
- (NSString *)encodeAttachment {
    NSMutableDictionary *dictM=[NSMutableDictionary dictionary];
    if (self.platform) {
        [dictM setObject:_platform forKey:@"platform"];
    }
    if (self.detectionfile) {
        [dictM setObject:_detectionfile forKey:@"detectionfile"];
    }
    if (self.consumingtime) {
        [dictM setObject:_consumingtime forKey:@"consumingtime"];
    }
    NSMutableDictionary *resultDict=[NSMutableDictionary dictionary];
    [resultDict setObject:@(XCSessionMessageTypeNetworkDetect) forKey:XCMessageTypeKey];
    [resultDict setObject:dictM  forKey:@"content"];
    return [resultDict JSONRepresentation];
}

#pragma mark - 上传相关接口
/**
 *  是否需要上传附件
 *
 *  @return 是否需要上传附件
 */
- (BOOL)attachmentNeedsUpload {
    return NO;
}

/**
 *  需要上传的附件路径
 *
 *  @return 路径
 */
- (NSString *)attachmentPathForUploading {
    return nil;
}

/**
 *  更新附件URL
 *
 *  @param urlString 附件url
 */
- (void)updateAttachmentURL:(NSString *)urlString {
    return;
}

#pragma mark - 服务器存储相关接口
/**
 *  是否允许在消息历史中拉取
 *
 *  @return 是否允许在消息历史中拉取
 */
- (BOOL)messageHistoryEnabled {
    return YES;
}

/**
 *  是否支持漫游
 *
 *  @return 是否支持漫游
 */
- (BOOL)messageRoamingEnabled {
    return YES;
}


/**
 *  是否支持多端同步
 *
 *  @return 是否支持多端同步
 */
- (BOOL)messageSyncEnabled {
    return YES;
}

#pragma mark  显示相关接口 add by hcy
/**
 *  内容大小
 *
 *  @return 内容所占用大小
 */
-(CGSize)attachmentSize  {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.6, 40);
    //return CGSizeMake(220, 130);
}

/**
 *  是否需要背景图
 *
 *  @return
 */
-(BOOL)attachmentNeedBackgroundImage  {
    return YES;
}

/**
 *  在消息列表中描述
 *
 *  @return
 */
-(NSString *)attachmentDescInSessionList  {
    NSString* desc = NSLocalizedString(@"f_56", nil);
    return desc;
}



@end
