//
//  NetworkInterface.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"
#import "MBProgressHUD.h"

/*
 已完成
 1.注册
 2.登录
 3.找回密码手机验证码
 5.注册验证码
 15.获取终端管理终端列表
 16.指定收单通道
 17.添加终端
 18.找回POS密码
 19.视频认证
 20.同步
 21.终端详情
 22.商品搜索条件
 23.商品列表
 24.商品详细
 27.购物车列表
 29.删除购物车
 30.修改购物车数量
 35.获取终端列表
 36.查询交易流水
 37.交易流水详情
 38.统计交易流水
 39.获取用户信息
 40.修改用户信息
 41.修改用户密码
 42.我的积分列表
 */




typedef enum {
    RequestTokenOverdue = -2,   //token失效
    RequestFail = -1,           //请求错误
    RequestSuccess = 1,         //请求成功
}RequestCode;

typedef enum {
    OrderFilterNone = -1,
    OrderFilterDefault,       //商品默认排序
    OrderFilterSales,         //销量排序
    OrderFilterPriceDown,     //价格降序
    OrderFilterPriceUp,       //价格升序
    OrderFilterScore,         //评分排序
}OrderFilter;

typedef enum {
    TradeTypeNone = -1,
    TradeTypeTransfer = 1,    //转账
    TradeTypeRepayment,       //还款
    TradeTypeConsume,         //消费
    TradeTypeLife,            //生活充值
    TradeTypeTelephoneFare,   //话费充值
}TradeType;

//注册
static NSString *s_register_method = @"user/userRegistration";

//登录
static NSString *s_login_method = @"user/studentLogin";

//注册手机验证码
static NSString *s_registerValidate_method = @"user/sendPhoneVerificationCodeReg";

//找回密码手机验证码
static NSString *s_findValidate_method = @"user/sendPhoneVerificationCodeFind";

//开通申请
static NSString *s_applyList_method = @"apply/getApplyList";

//终端管理列表
static NSString *s_terminalManagerList_method = @"terminal/getApplyList";

//收单机构
static NSString *s_organzationList_method = @"terminal/getFactories";

//添加终端
static NSString *s_addTerminal_method = @"terminal/addTerminal";

//找回POS密码
static NSString *s_terminalFindPsw_method = @"terminal/Encryption";

//视频认证
static NSString *s_videoAuth_method = @"terminal/videoAuthentication";

//同步
static NSString *s_synchronize_method = @"terminal/synchronous";

//终端详情
static NSString *s_termainlDetail_method = @"terminal/getApplyDetails";

//商品列表
static NSString *s_goodList_method = @"good/list";

//商品搜索条件获取
static NSString *s_goodSearch_method = @"good/search";

//商品详细
static NSString *s_goodDetail_method = @"good/goodinfo";

//购物车列表
static NSString *s_shoppingList_method = @"cart/list";

//删除购物车
static NSString *s_deleteShoppingList_method = @"cart/delete";

//修改购物车数量
static NSString *s_updateShoppingList_method = @"cart/update";

//获取交易流水终端列表
static NSString *s_terminalList_method = @"trade/record/getTerminals";

//查询交易流水
static NSString *s_tradeRecord_method = @"trade/record/getTradeRecords";

//交易流水详情
static NSString *s_tradeDetail_method = @"trade/record/getTradeRecord";

//统计交易流水
static NSString *s_tradeTotal_method = @"trade/record/getTradeRecordTotal";

//获取用户信息
static NSString *s_userInfo_method = @"customers/getOne";

//修改用户信息
static NSString *s_userUpdate_method = @"customers/update";

//修改用户密码
static NSString *s_mofityUserPassword_method = @"customers/updatePassword";

//我的积分列表
static NSString *s_scoreList_method = @"customers/getIntegralList";

//我的积分总计
static NSString *s_scoreTotal_method = @"customers/getIntegralTotal";

//积分兑换
static NSString *s_exchangeScore_method = @"customers/insertIntegralConvert";

@interface NetworkInterface : NSObject

/*!
 @abstract 1.注册
 @param activation      激活码
 @param username        邮箱
 @param userPassword    密码
 @param cityID          城市ID
 @param isEmailRegister 是否邮箱注册
 @result finish  请求回调结果
 */
+ (void)registerWithActivation:(NSString *)activation
                     username:(NSString *)username
                  userPassword:(NSString *)userPassword
                        cityID:(NSString *)cityID
               isEmailRegister:(BOOL)isEmailRegister
                      finished:(requestDidFinished)finish;

/*!
 @abstract 2.登录
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @result finish  请求回调结果
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish;

/*!
 @abstract 3.找回密码手机验证码
 @param mobileNumber    手机号
 @result finish  请求回调结果
 */
+ (void)getFindValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                   finished:(requestDidFinished)finish;

/*!
 @abstract 5.获取注册手机验证码
 @param mobileNumber    手机号
 @result finish  请求回调结果
 */
+ (void)getRegisterValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                       finished:(requestDidFinished)finish;


/*!
 @abstract 6.获取开通申请列表
 @param token       登录返回
 @param userID      用户ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getApplyListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 15.获取终端管理终端列表
 @param token       登录返回
 @param userID      用户ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTerminalManagerListWithToken:(NSString *)token
                                 userID:(NSString *)userID
                                   page:(int)page
                                   rows:(int)rows
                               finished:(requestDidFinished)finish;

/*!
 @abstract 16.指定收单通道
 @param token       登录返回
 @result finish  请求回调结果
 */
+ (void)getCollectionChannelWithToken:(NSString *)token
                             finished:(requestDidFinished)finish;

/*!
 @abstract 17.添加终端
 @param token       登录返回
 @param userID      用户id
 @param institutionID    收单机构id
 @param terminalNumber   终端号
 @param merchantName     商家名
 @result finish  请求回调结果
 */
+ (void)addTerminalWithToken:(NSString *)token
                      userID:(NSString *)userID
               institutionID:(NSString *)institutionID
              terminalNumber:(NSString *)terminalNumber
                merchantName:(NSString *)merchantName
                    finished:(requestDidFinished)finish;

/*!
 @abstract 18.找回POS密码
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)findPOSPasswordWithToken:(NSString *)token
                            tmID:(NSString *)tmID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 19.视频认证
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)videoAuthWithToken:(NSString *)token
                      tmID:(NSString *)tmID
                  finished:(requestDidFinished)finish;

/*!
 @abstract 20.同步
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)synchronizeWithToken:(NSString *)token
                        tmID:(NSString *)tmID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 21.终端详情
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)getTerminalDetailWithToken:(NSString *)token
                              tmID:(NSString *)tmID
                          finished:(requestDidFinished)finish;

/*!
 @abstract 22.商品搜索条件
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)goodSearchInfoWithCityID:(NSString *)cityID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 23.商品列表
 @param cityID      城市ID
 @param filterType  排序类型
 @param brandID     POS机品牌ID
 @param category    POS机类型
 @param channelID   支付通道
 @param cardID      支付卡类型
 @param tradeID     支持交易类型
 @param slipID      签单方式
 @param date        对账日期
 @param maxPrice    最高价
 @param minPrice    最低价
 @param keyword     搜索关键字
 @param rent        是否只支持租赁 
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getGoodListWithCityID:(NSString *)cityID
                     sortType:(OrderFilter)filterType
                      brandID:(NSArray *)brandID
                     category:(NSArray *)category
                    channelID:(NSArray *)channelID
                    payCardID:(NSArray *)cardID
                      tradeID:(NSArray *)tradeID
                       slipID:(NSArray *)slipID
                         date:(NSArray *)date
                     maxPrice:(CGFloat)maxPrice
                     minPrice:(CGFloat)minPrice
                      keyword:(NSString *)keyword
                     onlyRent:(BOOL)rent
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 24.商品详细
 @param cityID      城市ID
 @param goodID      商品ID
 @result finish  请求回调结果
 */
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                         goodID:(NSString *)goodID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 27.购物车列表
 @param token       登录返回
 @param userID      用户ID
 @result finish  请求回调结果
 */
+ (void)getShoppingCartWithToken:(NSString *)token
                          userID:(NSString *)userID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 29.删除购物车
 @param token       登录返回
 @param cartID      某一订单ID
 @result finish  请求回调结果
 */
+ (void)deleteShoppingCartWithToken:(NSString *)token
                             cartID:(NSString *)cartID
                           finished:(requestDidFinished)finish;

/*!
 @abstract 30.修改购物车
 @param token       登录返回
 @param cartID      某一订单ID
 @param count      数量
 @result finish  请求回调结果
 */
+ (void)updateShoppingCartWithToken:(NSString *)token
                             cartID:(NSString *)cartID
                              count:(int)count
                           finished:(requestDidFinished)finish;

/*!
 @abstract 35.获取终端列表
 @param token       登录返回
 @param userID      登录用户id
 @result finish  请求回调结果
 */
+ (void)getTerminalListWithToken:(NSString *)token
                          userID:(NSString *)userID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 36.查询交易流水
 @param token       登录返回
 @param tradeType   交易类型
 @param terminalNum  终端号
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)searchTradeRecordWithToken:(NSString *)token
                         tradeType:(TradeType)tradeType
                    terminalNumber:(NSString *)terminalNum
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;

/*!
 @abstract 37.交易流水详情
 @param token       登录返回
 @param tradeID   交易流水id
 @result finish  请求回调结果
 */
+ (void)getTradeDetailWithToken:(NSString *)token
                        tradeID:(NSString *)tradeID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 38.统计交易流水
 @param token       登录返回
 @param tradeType   交易类型
 @param terminalNum  终端号
 @param startTime   开始时间
 @param endTime     结束时间
 @result finish  请求回调结果
 */
+ (void)getTradeTotalWithToken:(NSString *)token
                     tradeType:(TradeType)tradeType
                terminalNumber:(NSString *)terminalNum
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                      finished:(requestDidFinished)finish;

/*!
 @abstract 39.获取用户信息
 @param token       登录返回
 @param userID      用户ID
 @result finish  请求回调结果
 */
+ (void)getUserInfoWithToken:(NSString *)token
                      userID:(NSString *)userID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 40.修改用户信息
 @param token       登录返回
 @param userID      用户ID
 @param username    用户姓名
 @param mobilePhone   手机
 @param email         邮箱
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)modifyUserInfoWithToken:(NSString *)token
                         userID:(NSString *)userID
                        username:(NSString *)username
                     mobilePhone:(NSString *)mobilePhone
                           email:(NSString *)email
                          cityID:(NSString *)cityID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 41.修改用户密码
 @param token       登录返回
 @param userID      用户ID
 @param primayPassword   原密码
 @param newPassword      新密码
 @result finish  请求回调结果
 */
+ (void)modifyUserPasswordWithToken:(NSString *)token
                             userID:(NSString *)userID
                    primaryPassword:(NSString *)primayPassword
                        newPassword:(NSString *)newPassword
                           finished:(requestDidFinished)finish;

/*!
 @abstract 42.我的积分列表
 @param token       登录返回
 @param userID   交易类型
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getScoreListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 43.我的积分总计
 @param token       登录返回
 @param userID   交易类型
 @result finish  请求回调结果
 */
+ (void)getScoreTotalWithToken:(NSString *)token
                        userID:(NSString *)userID
                      finished:(requestDidFinished)finish;

/*!
 @abstract 44.兑换积分
 @param token       登录返回
 @param userID   交易类型
 @param handler  姓名
 @param phoneNumber   手机号
 @param money   金额
 @result finish  请求回调结果
 */
+ (void)exchangeScoreWithToken:(NSString *)token
                        userID:(NSString *)userID
                   handlerName:(NSString *)handlerName
            handlerPhoneNumber:(NSString *)phoneNumber
                         money:(int)money
                      finished:(requestDidFinished)finish;

@end
