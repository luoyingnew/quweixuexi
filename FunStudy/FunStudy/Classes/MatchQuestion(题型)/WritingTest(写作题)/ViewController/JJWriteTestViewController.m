//
//  JJWriteTestViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWriteTestViewController.h"
#import "XPTextView.h"
#import "UIViewController+KeyboardCorver.h"
#import "ImagePicker.h"
#import "JJWriteTestModel.h"
#import <ReactiveCocoa.h>
#import "AFNetworking.h"
#import "IQKeyboardManager.h"

@interface JJWriteTestViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *topImageView;
//问题Label
@property (nonatomic, strong) UILabel *questionLabel;

@property (nonatomic, strong) JJWriteTestModel *writeTestModel;

//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

@property (nonatomic, strong) XPTextView *textView;

@property (nonatomic, strong) UIImage *submitImage;//要提交的作业图片

//scrollV主要是为了配合IQKeyboardManager
@property (nonatomic, strong) UIScrollView *scrollV;

@end

@implementation JJWriteTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setUpBaseView];
    //[self addNotification];
    [self requestWithData];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleName = self.navigationTitleName;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    self.backImageView = backImageView;
    backImageView.image = [UIImage imageNamed:@"ReadTestBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIScrollView *scro = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollV = scro;
    //self.scrollV.backgroundColor = [UIColor redColor];
    [backImageView addSubview:scro];
    scro.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height-100 );
    
    //top
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WriteTestTopBack"]];
    topImageV.userInteractionEnabled = YES;
    self.topImageView = topImageV;
    [self.scrollV addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(276 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(156 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        if(isPhone) {
            make.top.mas_equalTo(98 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.mas_equalTo(78 * KWIDTH_IPHONE6_SCALE);
        }
        
    }];
    //scrollerView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    //    scrollView.backgroundColor = [UIColor greenColor];
    [self.topImageView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        make.width.mas_equalTo(232 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-12 * KWIDTH_IPHONE6_SCALE);
    }];
    //问题Label
    self.questionLabel = [[UILabel alloc]init];
    self.questionLabel.font = [UIFont boldSystemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textColor = RGBA(173, 0, 0, 1);
    [scrollView addSubview:self.questionLabel];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(scrollView);
        make.width.mas_equalTo(232 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //上传按钮
    UIButton *uploadBtn = [[UIButton alloc]init];
//    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [uploadBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
//    [uploadBtn setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [self.scrollV addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(143 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(47 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(52 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.top.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.mas_equalTo(271 * KWIDTH_IPHONE6_SCALE);
        }
//        make.top.with.offset(291 * KWIDTH_IPHONE6_SCALE);
    }];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //气泡
    UIImageView *bubbleImageV  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BubbleText"]];
    [self.scrollV addSubview:bubbleImageV];
    [bubbleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(271 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(uploadBtn.mas_right).with.offset(2 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(67 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(45 * KWIDTH_IPHONE6_SCALE);
    }];

    //bottom
    UIImageView *bottomImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WriteTestBottomBack"]];
    bottomImageV.userInteractionEnabled = YES;
//    self.topImageView = bottomImageV;
    [self.scrollV addSubview:bottomImageV];
    [bottomImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(317 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        if(isPhone) {
            make.top.mas_equalTo(360 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.mas_equalTo(340 * KWIDTH_IPHONE6_SCALE);
        }
//        make.top.mas_equalTo(360 * KWIDTH_IPHONE6_SCALE);
    }];
    XPTextView *textView = [[XPTextView alloc]init];
    self.textView = textView;
    @weakify(self);
    [textView.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        if(text.length == 0) {
            self.writeTestModel.myAnswer = @"X";
        } else {
            self.writeTestModel.myAnswer = text;
        }
        
    }];
//    textView.backgroundColor = [UIColor redColor];
    textView.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
    textView.placeholder = @"请输入";
    textView.maxInputLength = 255;
    //    textView.backgroundColor = [UIColor redColor];
    [bottomImageV addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(19*KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(19*KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-19 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-36 *KWIDTH_IPHONE6_SCALE);
    }];
    
    //提交按钮
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageV addSubview:submitBtn];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"writeTestSubmit"] forState:UIControlStateNormal];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.bottom.width.offset(-28 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(64 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 作文数据请求
- (void)requestWithData {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    if([self.name isEqualToString:@"最新测验"]) {
        URL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_EXAM_INFO];
    } else {
        URL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOMEWORK_INFO];
    }

    NSDictionary *params = @{ @"topics_id" : self.topicModel.topics_id};
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        self.homeworkID = self.topicModel.homework_id;
        self.writeTestModel = [JJWriteTestModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"content"]][0];
        self.writeTestModel.myAnswer = @"X";
        self.questionLabel.text = self.writeTestModel.topic_text;
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

//提交按钮点击
- (void)submitBtnClick {
    if(self.submitImage != nil) {
        //提交图片作业
        [self submitImageHomework];
        return;
    }

    if(self.textView.text.length != 0) {
        //提交文字作业
        [self submittextHomework];
        return;
    }
            [JJHud showToast:@"题目没有做完,请继续做题"];
        return;
    
}

//提交图片作业
- (void)submitImageHomework {
    

    
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    if(self.writeTestModel.myAnswer.length != 0) {
        
        NSString *answer_index = self.writeTestModel.unit_id;
        
        NSString *answer_content = self.writeTestModel.myAnswer;
        
        NSDictionary *params = nil;
        NSString *URL = nil;
        if([self.name isEqualToString:@"最新测验"]) {
            params = @{ @"exam_id" : self.homeworkID , @"answer_index" : answer_index, @"fun_user_id" : [User getUserInformation].fun_user_id, @"answer_content" : answer_content};
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_EXAM_MEDIA];
        } else {
            if(self.topicModel.isSelfStudy) {
                //自学
                params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index,@"answer_content" : answer_content};//, @"fun_user_id" : [User getUserInformation].fun_user_id};
                URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_POST_MEDIA];
            } else {
                params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"fun_user_id" : [User getUserInformation].fun_user_id, @"answer_content" : answer_content};
                URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_MEDIA];
            }
            
        }
        AFHTTPSessionManager *httpManager = [HFNetWork AFHTTPSessionManager];
        [JJHud showStatus:nil];
        [httpManager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImagePNGRepresentation(self.submitImage);
            [formData appendPartWithFileData:data name:@"file" fileName:@"fds.png" mimeType:@"application/octet-stream"];
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
            [JJHud showToast:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:TopicListRefreshNotificatiion object:nil];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [JJHud showToast:@"加载失败"];
        }];
    }

}

//提交文字作业
- (void)submittextHomework{

    
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    if(self.writeTestModel.myAnswer.length != 0) {
        NSString *answer_index = self.writeTestModel.unit_id;
        NSString *answer_content = self.writeTestModel.myAnswer;
        NSDictionary *params = nil;
        NSString *URL = nil;
        if([self.name isEqualToString:@"最新测验"]) {
            params = @{ @"exam_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_EXAM];
        } else {
            if(self.topicModel.isSelfStudy) {
                //自学
                URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_POST_HOMEWORK];
                params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content};//, @"fun_user_id" : [User getUserInformation].fun_user_id};
            } else {
                params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
                URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_HOMEWORK];
            }
            
        }
        
        DebugLog(@"%@",params);
        [JJHud showStatus:nil];
        [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
            [JJHud dismiss];
            if (![response isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            DebugLog(@"response = %@", response);
            NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
            if (codeValue) { //详情数据加载失败
                NSString *codeMessage = [response objectForKey:@"error_msg"];
                DebugLog(@"codeMessage = %@", codeMessage);
                [JJHud showToast:codeMessage];
                return ;
            }
            [JJHud showToast:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:TopicListRefreshNotificatiion object:nil];
            });
            
        } fail:^(NSError *error) {
            [JJHud showToast:@"加载失败"];
        }];
    }
}

//上传按钮点击事件
- (void)uploadBtnClick:(UIButton *)btn {
    ImagePicker *imagePicker = [ImagePicker sharedInstance];
    imagePicker.isOriginImage = YES;
    [imagePicker iPadShowActionSheetWithViewController:self WithView:btn];
    
    weakSelf(weakSelf);
    [imagePicker getImageWithPicker:^(UIImage *image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
        image = [UIImage imageWithData:imageData];
        weakSelf.submitImage = image;
    }];
}

- (void)dealloc {
//    [self clearNotificationAndGesture];
}
@end
