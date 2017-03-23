//
//  JJFollowReadModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/25.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFollowReadModel.h"

@implementation JJFollowReadModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"translateCHinese" : @"option_desc"};//
}

- (NSString *)lastURL {
    if(!_lastURL) {
        _lastURL = [NSString stringWithFormat:@"%@%@",self.homeworkID,self.unit_id];
    }
    return _lastURL;
}
@end
