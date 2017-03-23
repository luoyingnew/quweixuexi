//
//  NetWorkChecker.h
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetWorkChecker : NSObject

+ (NetWorkChecker *)shareInstance;

/**
 *  获取实时网络状态
 *
 *  @return 网络状态
 */
- (NetworkStatus)networkStatus;//获取实时的网络状态

@end
