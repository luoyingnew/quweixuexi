//
//  JJMessageModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMessageModel.h"
#import "UILabel+LabelStyle.h"

@implementation JJMessageModel

- (NSString *)detailALlString {
    NSString *stringMutable = nil;
    for(NSString *string in self.detail_list) {
        if(stringMutable.length == 0) {
            stringMutable = string;
        } else {
            stringMutable = [NSString stringWithFormat:@"%@\n%@",stringMutable,string];
        }
    }
    return stringMutable;
}

@end
