//
//  SetModel.h
//  FunStudy
//
//  Created by tang on 16/11/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JJSetType){
    
     JJSetTypeSwitch = 1,
    
};
typedef void(^SetBlock)();
@interface SetModel : NSObject

@property(nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *arrow;
@property (nonatomic,strong)Class class;
@property (nonatomic,strong)SetBlock block;
@property (nonatomic,assign)JJSetType type;
+ (instancetype)configTitle:(NSString *)title icon:(NSString *)arrow;
+ (instancetype)configTitle:(NSString *)title icon:(NSString *)arrow type:(JJSetType)type;

@end
