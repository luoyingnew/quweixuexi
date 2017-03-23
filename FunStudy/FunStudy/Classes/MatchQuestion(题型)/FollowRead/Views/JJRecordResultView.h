//
//  JJRecordResultView.h
//  FunStudy
//
//  Created by 唐天成 on 2017/2/7.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordGradeType) {
    RecordGrade80,//60-80
    RecordGrade90,//80-90
    RecordGrade100//90-100
};


@interface JJRecordResultView : UIView

@property (nonatomic, assign) RecordGradeType type;


@end
