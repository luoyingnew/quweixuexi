//
//  ImagePicker.m
//  HiFun
//
//  Created by attackt on 16/8/9.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "ImagePicker.h"
#define ACTIONSHEET_TITLE     @"提示"
#define ACTIONSHEET_CANCEL    @"取消"
#define ACTIONSHEET_CAMERA    @"相机"
#define ACTIONSHEET_PHOTO     @"相册"
#define ALERT_CAMERA_UNAVAILABLE @"该设备不支持相机"
#define ALERT_PHOTO_UNAVAILABLE  @"该设备不支持相册"

@implementation ImagePicker

#pragma mark Public Method
+ (instancetype)sharedInstance {
    
    static ImagePicker* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImagePicker alloc] init];
    });
    return instance;
}




- (void)showActionSheetWithViewController:(UIViewController *)viewController {
    if (IOS_VERSION < 9.0) {
        UIActionSheet *actionSheet = [self creatActionSheet];
        [actionSheet showInView:viewController.view];
    } else {
        UIAlertController *alertController = [self creatAlertControllerWithActionSheetStyle];
        [alertController addAction:[self cancelAction]];
        [alertController addAction:[self photoAction]];
        [alertController addAction:[self cameraAction]];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    [self pickerControllerInit];
    self.currentViewController = viewController;
}

- (void)iPadShowActionSheetWithViewController:(UIViewController *)viewController WithView:(UIView *)view {
    if (IOS_VERSION < 9.0) {
        UIActionSheet *actionSheet = [self creatActionSheet];
        [actionSheet showInView:viewController.view];
    } else {
        UIAlertController *alertController = [self creatAlertControllerWithActionSheetStyle];
        [alertController addAction:[self cancelAction]];
        [alertController addAction:[self photoAction]];
        [alertController addAction:[self cameraAction]];

            UIPopoverPresentationController *popPresenter = [alertController
                                                             popoverPresentationController];
            popPresenter.sourceView = view;
            popPresenter.sourceRect = view.bounds;
            [viewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    [self pickerControllerInit];
    self.currentViewController = viewController;
}



- (void)getImageWithPicker:(PickerImage)picker {
    self.pickerImage = ^(UIImage *image) {
        picker(image);
    };
}


#pragma mark Priviate Method
- (void)pickerControllerInit {
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    self.pickerController.allowsEditing = YES;
}

- (UIActionSheet *)creatActionSheet {
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:nil
                                    delegate:self
                           cancelButtonTitle:ACTIONSHEET_CANCEL
                      destructiveButtonTitle:nil
                           otherButtonTitles:ACTIONSHEET_PHOTO,ACTIONSHEET_CAMERA, nil];
    
    return actionSheet;
}

- (UIAlertController *)creatAlertControllerWithActionSheetStyle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    return alertController;
}

- (UIAlertAction *)cancelAction {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ACTIONSHEET_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"do something cancel");
    }];
    return cancelAction;
}

//照片
- (UIAlertAction *)photoAction {
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:ACTIONSHEET_PHOTO style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![self isPhotosAlbumAvailabel]) {
            DebugLog(ALERT_PHOTO_UNAVAILABLE);
            return;
        }
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.currentViewController presentViewController:self.pickerController animated:YES completion:nil];
    }];
    return photoAction;
}
//相机
- (UIAlertAction *)cameraAction {
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:ACTIONSHEET_CAMERA style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![self isCameraAvailabel]) {
            DebugLog(ALERT_CAMERA_UNAVAILABLE);
            return;
        }
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.currentViewController presentViewController:self.pickerController animated:YES completion:nil];
    }];
    return cameraAction;
}



- (BOOL)isCameraAvailabel {//是否支持打开相机
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotosAlbumAvailabel {//是否支持打开相册
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // 选择相册
        if (![self isPhotosAlbumAvailabel]) {
            DebugLog(ALERT_PHOTO_UNAVAILABLE);
            return;
        }
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.currentViewController presentViewController:self.pickerController animated:YES completion:nil];

    } else if(buttonIndex == 1) {//选择相机
        if (![self isCameraAvailabel]) {
            DebugLog(ALERT_CAMERA_UNAVAILABLE);
            return;
        }
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.currentViewController presentViewController:self.pickerController animated:YES completion:nil];
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info  {
    UIImage *getimage = [info objectForKey:_isOriginImage ?  UIImagePickerControllerOriginalImage :  UIImagePickerControllerEditedImage];
    if (self.pickerImage) {
        self.pickerImage(getimage);
    }
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
