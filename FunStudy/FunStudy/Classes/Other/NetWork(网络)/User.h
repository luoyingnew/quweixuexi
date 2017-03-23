
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, strong) NSString *mobile;//手机号

@property (nonatomic, strong) NSString *birthday;//生日时间戳

@property (nonatomic, copy) NSString *token; // 请求的token

@property (nonatomic, strong) NSString *fun_user_id; // 用户id

@property (nonatomic, strong) NSString *user_login;//用户名

@property (nonatomic, strong) NSString *user_nicename;//真实姓名

@property (nonatomic, strong) NSNumber *sex;//性别

@property (nonatomic, strong) NSString *avatar_url;//头像

@property (nonatomic, assign) NSInteger user_coin;//学币

@property (nonatomic, strong) NSString *school_name;//学校名称

@property (nonatomic, strong) NSString *user_code;//学号

@property (nonatomic, strong) NSString *class_name;//班级名称

@property(nonatomic,assign)BOOL user_class;//是否有班级

@property(nonatomic,assign)NSInteger class_type;//班级类型 1:小学 2:初中

@property(nonatomic,assign)BOOL wait_homework;//是否有补作业

@property(nonatomic,assign)BOOL new_homework;//是否有最新作业
@property (nonatomic, strong) NSString *last_new_homeworkID;//最新作业id
@property (nonatomic, strong) NSString *last_new_homework_title;//最新作业名称


@property(nonatomic,assign)BOOL new_test;//是否有最新测验
@property (nonatomic, strong) NSString *last_new_testID;//最新测验id;
@property (nonatomic, strong) NSString *last_new_test_title;//最新测验名称




//@property (nonatomic, copy) NSString *username; //昵称
//
//@property (nonatomic, copy) NSString *nickname; // 用户名
//
//@property (nonatomic, strong) NSNumber *gender; //性别
//
//@property (nonatomic, assign) NSInteger birthday; //出生年月
//
//@property (nonatomic, copy) NSString *avatar; // 头像
//
//@property (nonatomic, copy) NSString *baby_name; //昵称
//
//@property (nonatomic, strong) NSNumber *baby_gender;//宝宝性别
//
//@property (nonatomic, assign) NSInteger baby_birthday; //宝宝出生年月
//
//@property (nonatomic, copy) NSString *mobile; // 手机号
//
//@property (nonatomic, copy) NSString *balance;//余额
//
//@property (nonatomic, strong) NSNumber *city;//城市



//- (id) initWithDicionary:(NSDictionary *)dic;
//
//- (void)updateUserInfo:(NSDictionary *)dic;


/**
 *  保存用户信息
 *
 *  @param user 用户
 */
+ (void)saveUserInformation:(User *)user;

/**
 *  获取用户信息
 *
 *  @return 用户
 */
+ (User *)getUserInformation;

/**
 *  注销用户信息
 */
+ (void)removeUserInformation;


@end


//"error_code": 0,
//"token": "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf",
//"user": [
//         "id": 12,
//         "username": "蓝求",
//         "nickname": "张三",
//         "gender": 1,
//         "avatar": "http://adf2212sss.jgp",
//         "baby_gender": 1,
//         "baby_birthday": 123412341234123,
//         "mobile":1852222222,
//         "balance":12,
//         ],
