//
//  UIViewController+Alert.m
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <objc/runtime.h>

@interface UIViewController ()<UIActionSheetDelegate , UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//确定
@property (nonatomic, copy)AlertViewBlock centerBlock;
//取消
@property (nonatomic, copy)AlertViewBlock cancleBlock;

//选中图片
@property (nonatomic, copy) PickerImageBlock pickerImageBlock;

@end


@implementation UIViewController (Alert)

static char cancleKey;
-(void)setCancleBlock:(AlertViewBlock)cancleBlock{
    objc_setAssociatedObject(self, &cancleKey, cancleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString*)cancleBlock{
    return objc_getAssociatedObject(self, &cancleKey);
}

static char centerKey;
-(void)setCenterBlock:(AlertViewBlock)centerBlock{
    objc_setAssociatedObject(self, &centerKey, centerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString*)centerBlock{
    return objc_getAssociatedObject(self, &centerKey);
}


- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}



- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelBlock:(AlertViewBlock)cancleBlock
              certainBlock:(AlertViewBlock)certainBloack{
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancleBlock();
        }];
        [alert addAction:cancleAction];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            certainBloack();
        }];
        [alert addAction:certainAction];

    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if(cancleBlock){
        self.cancleBlock = cancleBlock;
    }
    if(certainBloack){
        self.centerBlock = certainBloack;
    }
    
        [alert show];
        
    }
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
               cancelBlock:(AlertViewBlock)cancelBloack {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(cancelBloack) {
                cancelBloack();
            }
        }];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
    if(cancelBloack){
        self.cancleBlock = cancelBloack;
    }
        [alert show];
}

}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(self.cancleBlock){
            self.cancleBlock();
        }
    }
    if(buttonIndex == 1){
        if(self.centerBlock){
            self.centerBlock();
        }
    }
    DebugLog(@"%ld",buttonIndex);
}


//=====================================================================


- (void)showActionWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
    
}



- (void)showActionWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelBlock:(AlertViewBlock)cancleBlock
              certainBlock:(AlertViewBlock)certainBloack{
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancleBlock();
        }];
        [alert addAction:cancleAction];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            certainBloack();
        }];
        [alert addAction:certainAction];
        
    } else {//版本向下兼容
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定" , nil];
        [actionSheet showInView:self.view];
        if(cancleBlock){
            self.cancleBlock = cancleBlock;
        }
        if(certainBloack){
            self.centerBlock = certainBloack;
        }
    }
}

- (void)showActionWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
               cancelBlock:(AlertViewBlock)cancelBloack {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(cancelBloack) {
                cancelBloack();
            }
        }];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles: nil];
        [actionSheet showInView:self.view];
        
        if(cancelBloack){
            self.cancleBlock = cancelBloack;
        }
    }
}

#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        if(self.cancleBlock){
            self.cancleBlock();
        }
    }
    if(buttonIndex == 1){
        if(self.centerBlock){
            self.centerBlock();
        }
    }

}

//=====================================================================

#define ACTIONSHEET_TITLE     @"提示"
#define ACTIONSHEET_CANCEL    @"取消"
#define ACTIONSHEET_CAMERA    @"相机"
#define ACTIONSHEET_PHOTO     @"相册"
#define ALERT_CAMERA_UNAVAILABLE @"该设备不支持相机"
#define ALERT_PHOTO_UNAVAILABLE  @"该设备不支持相册"

static char pickerImageKey;
-(void)setPickerImageBlock:(PickerImageBlock)pickerImageBlock {
    objc_setAssociatedObject(self, &pickerImageKey, pickerImageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)pickerImageBlock{
    return objc_getAssociatedObject(self, &pickerImageKey);
}

//展示图片相册
- (void)showActionImagePickerWithPickerImageBlock:(PickerImageBlock)pickerImageBlock {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ACTIONSHEET_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"do something cancel");
        }];
        [alert addAction:cancelAction];
        weakSelf(weakSelf);
        //照片
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:ACTIONSHEET_PHOTO style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![weakSelf isPhotosAlbumAvailabel]) {
                DebugLog(ALERT_PHOTO_UNAVAILABLE);
                return;
            }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = weakSelf;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf presentViewController:pickerController animated:YES completion:nil];
        }];
        [alert addAction:photoAction];
        //相机
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:ACTIONSHEET_CAMERA style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![weakSelf isCameraAvailabel]) {
                DebugLog(ALERT_CAMERA_UNAVAILABLE);
                return;
            }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = weakSelf;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf presentViewController:pickerController animated:YES completion:nil];

        }];
        [alert addAction:cameraAction];
        if(pickerImageBlock) {
            self.pickerImageBlock = pickerImageBlock;
        }
        [self presentViewController:alert animated:YES completion:nil];
    } else {//版本向下兼容
    
        UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:ACTIONSHEET_CANCEL destructiveButtonTitle:nil otherButtonTitles:ACTIONSHEET_PHOTO,ACTIONSHEET_CAMERA, nil];
        [actionSheet showInView:self.view];
        //相册
        
        self.cancleBlock = ^{
            if (![self isPhotosAlbumAvailabel]) {
                DebugLog(ALERT_PHOTO_UNAVAILABLE);
                return;
            }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerController animated:YES completion:nil];
        };
        //相机
        self.centerBlock = ^{
            if (![self isCameraAvailabel]) {
                DebugLog(ALERT_CAMERA_UNAVAILABLE);
                return;
            }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerController animated:YES completion:nil];
        };
        
    }
}

- (BOOL)isCameraAvailabel {//是否支持打开相机
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotosAlbumAvailabel {//是否支持打开相册
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info  {
    UIImage *getimage = [info objectForKey:  UIImagePickerControllerEditedImage];
    if (self.pickerImageBlock) {
        self.pickerImageBlock(getimage);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
