//
//  JJBilingualResultModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/24.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJBilingualResultModel : NSObject

//左边显示文字
@property (nonatomic, strong) NSString *myAnswerleftText;




//是否正确
@property(nonatomic,assign)BOOL isRight;
//小题ID
@property (nonatomic, strong) NSString *unit_id;

@end
