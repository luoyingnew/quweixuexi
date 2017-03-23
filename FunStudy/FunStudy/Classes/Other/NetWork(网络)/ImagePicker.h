//
//  ImagePicker.h
//  HiFun
//
//  Created by attackt on 16/8/9.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^PickerImage)(UIImage *image);

@interface ImagePicker : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, copy) PickerImage pickerImage;
@property (nonatomic, assign) BOOL isOriginImage;

+ (instancetype)sharedInstance;

/** iphone
 *  初始化ActionSheet 所要显示的 viewController
 *
 *  @param viewController ActionSheet 将要显示的控制器
 */
- (void)showActionSheetWithViewController:(UIViewController *)viewController;
/** ipad
 *  初始化ActionSheet 所要显示的 viewController
 *
 *  @param viewController ActionSheet 将要显示的控制器
 */
- (void)iPadShowActionSheetWithViewController:(UIViewController *)viewController WithView:(UIView *)view;


/**
 *  获取选择后的图片
 *
 *  @param picker 选择图片后的回调处理
 */
- (void)getImageWithPicker:(PickerImage)picker;

@end
