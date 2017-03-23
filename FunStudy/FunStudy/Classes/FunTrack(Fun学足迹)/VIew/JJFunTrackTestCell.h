//
//  JJFunTrackTestCell.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJFunTrackModel.h"

//查看Block
typedef void(^CheckLookBlock)(void);
//查看分数评语Block
typedef void(^CheckCommandBlock)(void);
//补做作业Block
typedef void(^ContinueDoHomeworkBlock)(NSString *typeName, NSString *homeworkTitle, NSString *homeworkID);


@interface JJFunTrackTestCell : UITableViewCell

//查看Block
@property (nonatomic, copy) CheckLookBlock checkLookBlock;
//查看分数评语Block
@property (nonatomic, copy) CheckCommandBlock checkCommandBlock;
//补做作业block
@property (nonatomic, copy) ContinueDoHomeworkBlock continueDoHomeworkBlock;

@property (nonatomic, strong) JJFunTrackModel *funTrackModel;


@end
