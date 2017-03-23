//
//  JJReadTestOptionalCell.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJSingleChooseOptionalModel.h"

@interface JJReadTestOptionalCell : UITableViewCell

@property (nonatomic, strong) JJSingleChooseOptionalModel *model;
//字母
@property (nonatomic, strong) UILabel *letterLabel;


@end
