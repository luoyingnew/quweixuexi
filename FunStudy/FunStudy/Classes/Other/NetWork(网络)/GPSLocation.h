//
//  GPSLocation.h
//  Chocolate
//
//  Created by lwb on 2016/10/18.
//  Copyright © 2016年 北京进击科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSLocation : NSObject

@property (nonatomic, assign) double latitude; //当前纬度
@property (nonatomic, assign) double longitude; //当前经度
@property (nonatomic, assign) BOOL isLocateSucceed; //是否成功定位

+ (GPSLocation *)shareInstance;

- (void)setupLocationManager;

- (void)stopUpdateLocations;

@end
