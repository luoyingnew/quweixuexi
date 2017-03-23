//
//  JJJoinClassCell.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJClassModel.h"

typedef void(^JoinClassBlock)(JJClassModel *);

@interface JJJoinClassCell : UITableViewCell

@property (nonatomic, strong) JJClassModel *model;
@property (nonatomic, copy) JoinClassBlock block;

@end
