//
//  JJTopicCell.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJTopicModel.h"

@interface JJTopicCell : UITableViewCell

@property (nonatomic, strong) JJTopicModel *model;

//遮罩(当大题已做完的时候显示)
@property (nonatomic, strong) UIView *shadowView;

@end
