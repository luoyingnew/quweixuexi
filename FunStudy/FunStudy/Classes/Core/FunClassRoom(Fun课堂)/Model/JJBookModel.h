//
//  JJBookModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJBookModel : NSObject

@property (nonatomic, strong) NSString *book_title;
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *book_img;
@property (nonatomic, assign) BOOL is_listen;//是否有随身听(Fun课堂的时候用)

//0代表教材无内容,1代表小学,2代表初中(自学中心用)
@property(nonatomic,assign)NSInteger book_type;

@end
