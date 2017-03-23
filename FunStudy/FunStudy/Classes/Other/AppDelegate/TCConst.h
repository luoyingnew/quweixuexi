//
//  TCConst.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
//主要用于存储一些key值,通知等

//运行环境主机地址
//@"" //测试
//@"" //正式
//@"http://apple.dev.attackt.com"
//@"http://ceshi.bjmti.com"

#define XP_API_TEST 0 // 1-测试环境，0-正式环境
#if XP_API_TEST

#define DEVELOP_BASE_URL @"http://apple.dev.attackt.com"
#else
#define DEVELOP_BASE_URL @"http://www.bjmti.com"
#endif

//#define DEVELOP_BASE_URL        @"http://www.bjmti.com"
//#define PRODUCT_BASE_URL        @"***************************"


///**
// *  第三方平台的keys
// */
////极光推送appKey
#define JPUSHAppKey      @"a24ce970f92db0790f3e124d"
//ifly讯飞appid
#define iflyAppID        @"5897e1ad"//@"5897e1ad"
//appStoreID
#define appStoreID       @"1198075728"
//shareSDK AppKey
#define ShareSDKAppKey    @"1b503fa81ff00"
//shanreUrl 分享的链接地址
#define ShanreUrl         @"http://www.bjmti.com/homework_share"
//新浪微博 AppKey       XHT
#define WeiboAppKey        @"2314461869"
#define WeiboAppSecret     @"d795fa8a426969a77bed362aa82023fd"

//腾讯QQ Appkey       XHT
#define QQAppId            @"1105988248"
#define QQAppSecret        @"k0nxpB3aQktDHlh7"

//微信 AppKey            XHT
#define WeiChatAppId       @"wx8f0b8ba14e9544e5"
#define WeiChatAppSecret   @"0eccada22eb90770ee1755a6e1a64880"



//
//// 友盟统计appKey
//#define UMengAppKey       @"579affc8e0f55a480100385c"
//
////shareSDK AppKey       XHT
//#define ShareSDKAppKey    @"172e2fae8dc3e"
//
////ping++ AppKey
//#define PingPlusAppkey    @"app_0K0qr1TmD8iHLWXL"
//
////新浪微博 AppKey       XHT
//#define WeiboAppKey        @"734327654"
//#define WeiboAppSecret     @"a50b95a0015757cf9b85cded1cb2ddb6"
//
////腾讯QQ Appkey       XHT
//#define QQAppId            @"1105618115"
//#define QQAppSecret        @"GwFFbSdJnjAvDuF6"
//
////微信 AppKey            XHT
//#define WeiChatAppId       @"wxcdc44071a233f753"
//#define WeiChatAppSecret   @"53e036a01246be5e7f994f874e92b50b"

//============================================================== API  ==============================================================

//发送验证码 POST
#define API_SEND_V_CODE          @"/api/v1/send_v_code"

//验证码校验 POST
#define API_CHECK_V_CODE         @"/api/v1/check_v_code"

//手机号注册 POST  XHT
#define API_SIGNUP               @"/api/v1/register"

//忘记密码  POST
#define API_FORGET_PWD           @"/api/v1/forget_pwd"

//找到老师
#define API_FINE_TEACHER         @"/api/v1/find_teacher"

//手机号登录 POST
#define API_LOGIN                @"/api/v1/login"

//首页轮播  是否有新作业  新测试
#define API_CAROUSEL             @"/api/v1/carousel"

//添加班级
#define API_APPLY_JOIN_CLASS     @"/api/v1/apply_join_class"

//获得教材信息   GET
#define API_GET_CLASSBOOKS       @"/api/v1/classroom_books"

//选择教材     POST
#define API_CHOOSE_CLASSBOOK     @"/api/v1/classroom_books"

//选择单元
#define API_CHOOSE_CLASSUNITS    @"/api/v1/classroom_units"

//积分规则
#define API_RULELIST             @"/api/v1/coin_rule_list"

//智慧榜
#define API_COIN_RANKING         @"/api/v1/coin_ranking"

//状元榜
#define API_COIN_UP_RANKING      @"/api/v1/coin_up_ranking"

//消息列表
#define API_PUSH_RECORDS         @"/api/v1/push_records"


//最新作业列表
#define API_TODAY_HOMEWORK_LIST  @"/api/v1/today_homework_list"

//补作业列表
#define API_MAKE_HOMEWORK_LIST   @"/api/v1/make_homework_list"

//测验列表
#define API_TODAY_EXAM_LIST      @"/api/v1/today_exam_list"

//作业大题列表
#define API_HOMEWORK_TOPIC_LIST  @"/api/v1/homework_topics_list"

//自学大题板块列表
#define API_STUDY_HOMEWORK_LIST  @"/api/v1/study_homework_list"

//测验大题列表
#define API_EXAM_TOPIC_LIST      @"/api/v1/exam_topics_list"

//获取题型数据
#define API_HOMEWORK_INFO        @"/api/v1/homework_info"

//获取测验题型数据
#define API_EXAM_INFO            @"/api/v1/exam_info"

//作业提交
#define API_POST_HOMEWORK        @"/api/v1/post_homework"

//自学中心作业提交
#define API_SELFSTUDY_POST_HOMEWORK  @"/api/v1/post_study_homework"

//测验提交
#define API_POST_EXAM            @"/api/v1/post_exam"

//作业提交媒体
#define API_POST_MEDIA           @"/api/v1/post_media"
//自学中心提交媒体
#define API_SELFSTUDY_POST_MEDIA  @"/api/v1/post_study_media"


//测试提交媒体
#define API_POST_EXAM_MEDIA      @"/api/v1/post_exam_media"

//完成作业
#define API_HOMEWORKFINISH       @"/api/v1/homework_finish"
//完成自学作业
#define API_SELFSTUDY_HOMEWORKFINISH    @"/api/v1/study_homework_finish"

//完成测验
#define API_EXAMFINISH           @"/api/v1/exam_finish"

//我的老师
#define API_MYTEACHER_LIST       @"/api/v1/my_teacher_list"

//个人信息
#define API_STUDENT_INFO         @"/api/v1/student_info"

//编辑个人信息
#define API_EDIT_STUDENT_INFO    @"/api/v1/edit_student_info"

//修改手机
#define API_CHANGE_MOBILE        @"/api/v1/change_mobile"

//修改密码
#define API_UPDATE_PWD           @"/api/v1/update_pwd"

//反馈建议
#define API_FEEDBACK             @"/api/v1/feedback"

//我的学币
#define API_COIN_LIST            @"/api/v1/my_coin_list"

//Fun足迹
#define API_FOOTPRINT            @"/api/v1/footprint"

//老师评分详情
#define API_SCORE_DETAIL         @"/api/v1/score_detail"

//我的成绩
#define API_GRADE                @"/api/v1/grade"

//老师奖励
#define API_BOUNSE               @"/api/v1/bonuses"

//成绩单
#define API_GRADE_REPORT         @"/api/v1/grade_report"

//作业详情
#define API_GRADE_DETAILS        @"/api/v1/grade_details"

//检查更新
#define API_LATEST_VERSION       @"/api/v1/latest_version"

//用户协议
#define API_PROTOCOL             @"/service_agreement"

//keys
static NSString *const hf_httpRequestKey = @"hf_httpRequestKey";

//=============================== 系统偏好设置 ===============================
//用户信息存储
#define saveUserInfo    @"userInfo"

//网络状态是否提醒
#define isNoticNetWork  @"isNoticNetWork"

//=========================================== 通知 ==============================================================

//当有推送时的通知(首页消息按钮小红点hideORno)
#define JpushMessageHideNotificatiion @"JpushMessageHideNotificatiion"

//tabBar跳转的通知
#define POP     @"tabbarPop"

//学生加入班级成功后发出的通知
#define SuccessJoinClass     @"SuccessJoinClass"

//作业大题列表页刷新通知
#define TopicListRefreshNotificatiion  @"TopicListRefreshNotificatiion"

//从结果页跳回大题列表页后让大题列表页push进小题页
#define TopicListPushToMatchNotification  @"TopicListPushToMatchNotification"

//个人信息发生改变的通知
#define EditInfoSuccessNotification     @"EditInfoSuccessNotification"

//一个作业或者大题列表全部做完之后发出的通知
#define OverTopicListNotification       @"overTopicListNotification"

////定位后发出的通知          XHT
//#define LocationNotificatiion          @"LocationNotification"


