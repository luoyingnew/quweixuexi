//
//  JJEditPersonalMessageViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJEditPersonalMessageViewController.h"
#import <UIImageView+WebCache.h>
#import "NSString+XPKit.h"
#import "DatePickerView.h"
#import "UIButton+Custom.h"
#import "UIImage+XPKit.h"

@interface JJEditPersonalMessageViewController ()<UITextFieldDelegate>

//头像
@property (nonatomic, strong) UIImageView *imageView;
//姓名textField
@property (nonatomic, strong)UITextField *nameTextField;
//女孩选择按钮
@property (nonatomic, strong)UIButton *girlBtn;
//男孩选择按钮
@property (nonatomic, strong)UIButton *boyBtn;
//当前选中的按钮
@property (nonatomic, strong) UIButton *currentSelectedBtn;
//生日textField
@property (nonatomic, strong)UIButton *birthBtn;

//@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
//
//@property (strong, nonatomic) dispatch_source_t timer;//定时器

@end

@implementation JJEditPersonalMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseView];
    [self setNavigationBar];
    [self showTopView];
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}
//设置导航条
- (void)setNavigationBar {
    self.titleName = @"编辑信息";
}

- (void)showTopView
{
    weakSelf(weakSelf);
    User *user = [User getUserInformation];
    
    UIView *backView= [[UIView alloc]init];
    [self.view addSubview:backView];
    backView.backgroundColor = RGBA(190, 246, 255, 1);
    [backView createBordersWithColor:RGBA(0, 160, 204, 1) withCornerRadius:15 * KWIDTH_IPHONE6_SCALE andWidth:4 * KWIDTH_IPHONE6_SCALE];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(323 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(452 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.top.with.offset(89 * KWIDTH_IPHONE6_SCALE);
    }];
    [self.view addSubview:backView];
    
    //会员头像Label
    UILabel *iconLabel = [[UILabel alloc]init];
    iconLabel.text = @"会员头像:";
    iconLabel.textColor = RGBA(0, 206, 255, 1);
    iconLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
//    iconLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:iconLabel];
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(26 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-224 * KWIDTH_IPHONE6_SCALE);
    }];

    
    //头像
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView createBordersWithColor:[UIColor clearColor] withCornerRadius:47 * KWIDTH_IPHONE6_SCALE andWidth:0];
    self.imageView = imageView;
    [imageView whenTapped:^{
        //打开相册
        [weakSelf openPhoto];
    }];
    [imageView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholderImage:[UIImage imageNamed:@"icon_image_new"]];
    [backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(94 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backView);
        make.top.with.offset(50 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //点击图片更新头像
    UILabel *tapLabel = [[UILabel alloc]init];
    tapLabel.text = @"点击图片更新头像";
    tapLabel.textColor = RGBA(0, 206, 255, 1);
    tapLabel.font = [UIFont boldSystemFontOfSize:10 * KWIDTH_IPHONE6_SCALE];
    //    iconLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:tapLabel];
    [tapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(9 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backView);
    }];
    //图片最佳尺寸
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"图片最佳尺寸:200px * 200px";
    detailLabel.textColor = RGBA(0, 206, 255, 1);
    detailLabel.font = [UIFont boldSystemFontOfSize:10 * KWIDTH_IPHONE6_SCALE];
    //    iconLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tapLabel.mas_bottom).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backView);
    }];
    
    //真实姓名Label
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"真实姓名:";
    nameLabel.textColor = RGBA(0, 206, 255, 1);
    nameLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(226 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-224 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UITextField *nameTextField = [[UITextField alloc]init];
    self.nameTextField = nameTextField;
    UIView *leftView = [[UIView alloc]init];
    leftView.width = 11 * KWIDTH_IPHONE6_SCALE;
    self.nameTextField.leftView = leftView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
//    nameTextField.textAlignment = NSTextAlignmentCenter;
    nameTextField.text = user.user_nicename;
    nameTextField.textColor = [UIColor whiteColor];
    nameTextField.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    nameTextField.backgroundColor = RGBA(0, 206, 255, 1);
    [nameTextField createBordersWithColor:RGBA(0, 206, 255, 1) withCornerRadius:11*KWIDTH_IPHONE6_SCALE andWidth:0];
    [backView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(nameLabel);
        make.width.mas_equalTo(132 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(22 * KWIDTH_IPHONE6_SCALE);
    }];

    //性别lable
    UILabel *sexLabel = [[UILabel alloc]init];
    sexLabel.text = @"性别:";
    sexLabel.textColor = RGBA(0, 206, 255, 1);
    sexLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    sexLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(275 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-224 * KWIDTH_IPHONE6_SCALE);
    }];

    //女孩头像
    UIImageView *girlImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"editGirlicon"]];
    [backView addSubview:girlImageV];
    [girlImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel.mas_right).with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(sexLabel);
        make.width.mas_equalTo(38* KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
    }];
    //女孩选择按钮
    UIButton *girlBtn = [[UIButton alloc]init];
    [girlBtn setEnlargeEdgeWithTop:16 * KWIDTH_IPHONE6_SCALE right:0 bottom:16 * KWIDTH_IPHONE6_SCALE left:26 * KWIDTH_IPHONE6_SCALE];
    [girlBtn addTarget:self action:@selector(sexBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    if(user.sex.integerValue == 2) {
        girlBtn.selected = YES;
        self.currentSelectedBtn = girlBtn;
    }
    self.girlBtn = girlBtn;
    [backView addSubview:girlBtn];
    [girlBtn setBackgroundImage:[UIImage imageNamed:@"sexNoSelected"] forState:UIControlStateNormal];
    [girlBtn setBackgroundImage:[UIImage imageNamed:@"sexSelected"] forState:UIControlStateSelected];
    [girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(girlImageV.mas_right).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(sexLabel);
        make.width.mas_equalTo(16* KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
    }];
    //男孩头像
    UIImageView *boyImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"editBoyicon"]];
    [backView addSubview:boyImageV];
    [boyImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(girlBtn.mas_right).with.offset(21 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(sexLabel);
        make.width.mas_equalTo(26* KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
    }];
    //男孩选择按钮
    UIButton *boyBtn = [[UIButton alloc]init];self.boyBtn = boyBtn;
    [boyBtn setEnlargeEdgeWithTop:16 * KWIDTH_IPHONE6_SCALE right:0 bottom:16 * KWIDTH_IPHONE6_SCALE left:26 * KWIDTH_IPHONE6_SCALE];
    [boyBtn addTarget:self action:@selector(sexBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    if(user.sex.integerValue == 1) {
        self.currentSelectedBtn = boyBtn;
        boyBtn.selected = YES;
    }
    [backView addSubview:boyBtn];
    [boyBtn setBackgroundImage:[UIImage imageNamed:@"sexNoSelected"] forState:UIControlStateNormal];
    [boyBtn setBackgroundImage:[UIImage imageNamed:@"sexSelected"] forState:UIControlStateSelected];
    [boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boyImageV.mas_right).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(sexLabel);
        make.width.mas_equalTo(16* KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
    }];
    //生日label
    UILabel *birthdayLabel = [[UILabel alloc]init];
    birthdayLabel.text = @"生日:";
    birthdayLabel.textColor = RGBA(0, 206, 255, 1);
    birthdayLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    birthdayLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:birthdayLabel];
    [birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(321 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-224 * KWIDTH_IPHONE6_SCALE);
    }];

    //生日Btn
    UIButton *birthBtn = [[UIButton alloc]init];
    self.birthBtn = birthBtn;
    [birthBtn addTarget:self action:@selector(birthdayChooseAction) forControlEvents:UIControlEventTouchUpInside];
    if([user.birthday isKindOfClass:[NSString class]]) {
        [birthBtn setTitle:[user.birthday stringChangeToDate:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    }
    
    [birthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
    birthBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    birthBtn.backgroundColor = RGBA(0, 206, 255, 1);
    [birthBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:11*KWIDTH_IPHONE6_SCALE andWidth:0];
    [backView addSubview:birthBtn];
    [birthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(birthdayLabel.mas_right).with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(birthdayLabel);
        make.width.mas_equalTo(132 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(22 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //确认提交按钮
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn addTarget:self action:@selector(requestWithChangePersonalMessage) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"editSubmit"] forState:UIControlStateNormal];
    [backView addSubview:submitBtn];
    [submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
    [submitBtn setTitleColor:RGBA(172, 0, 0, 1) forState:UIControlStateNormal];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(birthBtn.mas_bottom).with.offset(26 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backView);
        make.width.mas_equalTo(123 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(34 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 发送编辑个人信息请求
- (void)requestWithChangePersonalMessage {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_EDIT_STUDENT_INFO];
    NSString *sex = @"0";
    if(self.currentSelectedBtn == nil) {
        sex = @"0";
    } else if(self.currentSelectedBtn == self.boyBtn) {
        sex = @"1";
    } else if(self.currentSelectedBtn == self.girlBtn) {
        sex = @"2";
    }
    NSString *birthday = nil;
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:self.birthBtn.currentTitle];
    NSString *datesp =[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"nicename" : self.nameTextField.text, @"gender" : sex, @"birthday" : datesp};
    AFHTTPSessionManager *httpManager = [HFNetWork AFHTTPSessionManager];
//    self.httpManager = httpManager;
    DebugLog(@"%@",httpManager.dataTasks);
    [JJHud showStatus:nil];
    [httpManager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(self.imageView.image);
        [formData appendPartWithFileData:data name:@"media" fileName:@"fds.png" mimeType:@"application/octet-stream"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        DebugLog(@"上传进度-----   %f    %@",progress,uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [JJHud dismiss];
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [JJHud dismiss];
            return ;
        }
        DebugLog(@"response = %@", responseObject);
        NSInteger codeValue = [[responseObject objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [responseObject objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        DebugLog(@"上传成功 %@",responseObject);
        [JJHud showToast:@"修改成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//            //让个人信息页 和 Fun学习页面 刷新
            [[NSNotificationCenter defaultCenter]postNotificationName:EditInfoSuccessNotification object:nil];
//            if(self.editInfoSuccessBlock) {
//                self.editInfoSuccessBlock();
//            }
//        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [JJHud showToast:@"加载失败"];
    }];
}




#pragma mark -选性别
- (void)sexBtnSelected:(UIButton *)btn {
    if(btn.selected == YES) return;
    self.currentSelectedBtn.selected = NO;
    self.currentSelectedBtn = btn;
    self.currentSelectedBtn.selected = YES;
}

#pragma mark --修改生日
//点击出生年月日
- (void)birthdayChooseAction {
    DatePickerView *datePicker = [[DatePickerView alloc] init];
    [datePicker showInView:self.view];
    datePicker.selectBlock = ^(NSDate* date) {
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyy-MM-dd";
        NSString* birthString=[formatter stringFromDate:date];
        [self.birthBtn setTitle:birthString forState:UIControlStateNormal];
    };
}


#pragma mark - 打开相册
- (void)openPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage* image = nil;
    if(isPhone) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image scaleToSize:CGSizeMake(image.size.width/9, image.size.height/9)];
    }
    
    
//    if (!image){
//        image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
    
    self.imageView.image = image;
    //    [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [weakSelf scanResultWithArray:array];
    //        });
    //
    //    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DebugLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //倒计时时间
////    __block NSInteger timeOut = countTime;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    //每秒执行一次
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(_timer, ^{
//        DebugLog(@"--%@   %@   %@   %@--",self.httpManager.tasks,self.httpManager.dataTasks,self.httpManager.uploadTasks,self.httpManager.downloadTasks);
//    });
//    dispatch_resume(_timer);
//    
//}

@end
