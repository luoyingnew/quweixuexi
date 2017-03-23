//
//  JJErrorCorrectionView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJErrorCorrectionModel.h"

@interface JJErrorCorrectionView : UIView

@property (nonatomic, strong) JJErrorCorrectionModel *errorCorrectionModel;

+(instancetype)errorCorrectionViewWithModel:(JJErrorCorrectionModel *)model;

@end
