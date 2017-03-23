//
//  JJCommonProblemModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/2.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommonProblemCellModel.h"

@interface JJCommonProblemModel : NSObject

@property (nonatomic, strong) NSString *leftQuestion;
@property (nonatomic, strong) NSString *rightQuestion;



//小问题数组
@property (nonatomic, strong) NSArray<JJCommonProblemCellModel *> *cellModelArray;


@end
