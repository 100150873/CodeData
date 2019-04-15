//
//  SFNetSpeedMeasurer.h
//  NIM
//
//  Created by gzc on 2019/3/28.
//  Copyright © 2019 YzChina. All rights reserved.
//



#import <Foundation/Foundation.h>

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
typedef long RLong;
typedef unsigned long RULong;
#else
typedef long long RLong;
typedef unsigned long long RULong;
#endif

typedef NS_ENUM(NSUInteger, SFNetConnectionType) {
    SFNetConnectionType_WiFi = 0,
    SFNetConnectionType_WWAN = 1,
};

NS_ASSUME_NONNULL_BEGIN
@class SFNetMeasurerResult;
typedef void(^SFNetworkSpeedAttributeCallback)(SFNetMeasurerResult *result);

@protocol ISpeedMeasurerProtocol;
@protocol SFNetSpeedMeasurerDelegate <NSObject>
- (void)measurer:(id<ISpeedMeasurerProtocol>)measurer didCompletedByInterval:(SFNetMeasurerResult *)result;
@end

@protocol ISpeedMeasurerProtocol <NSObject>
@property (nonatomic, assign) NSUInteger accuracyLevel;//精度等级 1~5
@property (nonatomic, assign) NSTimeInterval measurerInterval;
@property (nonatomic, weak) id<SFNetSpeedMeasurerDelegate> delegate;//Block和Delegate 二选一, Block优先级更高.
@property (nonatomic, strong) SFNetworkSpeedAttributeCallback measurerBlock;//Block和Delegate 二选一, Block优先级更高.
- (instancetype)initWithAccuracyLevel:(NSUInteger)accuracyLevel interval:(NSTimeInterval)interval;
- (void)execute;
- (void)shutdown;
@end

@interface SFNetFragmentation : NSObject
@property (nonatomic, assign) SFNetConnectionType connectionType;
@property (nonatomic, assign) u_int32_t inputBytesCount;
@property (nonatomic, assign) u_int32_t outputBytesCount;
@property (nonatomic) NSTimeInterval beginTimestamp;
@property (nonatomic) NSTimeInterval endTimestamp;
+ (NSString *)maxValueInputKeyPath;
+ (NSString *)minValueInputKeyPath;
+ (NSString *)avgValueInputKeyPath;
+ (NSString *)maxValueOutputKeyPath;
+ (NSString *)minValueOutputKeyPath;
+ (NSString *)avgValueOutputKeyPath;
+ (NSString *)realTimeInputKeyPath;
+ (NSString *)realTimeOutputKeyPath;
@end

@interface SFNetMeasurerResult : NSObject
@property (nonatomic, assign) SFNetConnectionType connectionType;
@property (nonatomic, assign) double uplinkMaxSpeed;
@property (nonatomic, assign) double uplinkMinSpeed;
@property (nonatomic, assign) double uplinkAvgSpeed;
@property (nonatomic, assign) double uplinkCurSpeed;
@property (nonatomic, assign) double downlinkMaxSpeed;
@property (nonatomic, assign) double downlinkMinSpeed;
@property (nonatomic, assign) double downlinkAvgSpeed;
@property (nonatomic, assign) double downlinkCurSpeed;
@end

@interface SFNetSpeedMeasurer : NSObject <ISpeedMeasurerProtocol>

@end



NS_ASSUME_NONNULL_END
