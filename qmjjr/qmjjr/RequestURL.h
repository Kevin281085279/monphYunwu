//
//  RequestURL.h
//  JingWaiYou
//
//  Created by SaNPanG.K on 14-9-10.
//  Copyright (c) 2014年 ZhunNa. All rights reserved.
//

#ifndef JingWaiYou_RequestURL_h
#define JingWaiYou_RequestURL_h

#define YU_MIMG_LOG @"http://api.monph.com/v4/"
#define YU_MIMGV1 @"https://api.monph.com:4433/v1/"
#define YU_MINGV3 @"http://api.monph.com/v3/"
#define YU_MING @"http://api.monph.com/quanminjingjiren/"
#define YU_MIMG_JJR @"http://api.monph.com/jingji_v3/"

#define NET_WORKING [LKNetWorkingUtil shareUtil]

//接口名称
#define POST_REGISTER @"reg.php?"
#define POST_LOGIN @"chkLogin.php?"
#define ADD_DEVICE_TOKEN @"addDeviceToken.php?"
#define GET_BACK_PASSWORD @"getBackPassword.php?"
#define YZM_LOGIN @"yzmLogin.php?"
//获取验证码
#define GET_CAPTCHA @"getCaptcha.php?"
//首页获取推荐数量
#define GET_TUIJIAN_NUM @"getTuijianNum.php?"
//获取用户信息
#define GET_USER_INFO @"getUserInfo.php?"
//上传用户头像
#define UPDATE_USERFACE @"uploadUserFace.php?"
//上传图片（身份证等）
#define UPLOAD_PICTURE @"uploadPicture.php?"
//上传实名认证信息
#define UPDATE_USER_SHIMING @"updateUserShiming.php?"
//推荐出房
#define ADD_TUIJIAN_CHUFANG @"addTuijianChufang.php?"
//推荐托管
#define ADD_TUIJIAN_TUOGUAN @"addTuijianTuoguan.php?"
//搜索小区信息
#define SEARCH_XIAOQU @"searchXiaoQu.php?"
//我的佣金
#define GET_MY_YONGJIN @"getMyYongjin.php?"
//获取银行卡列表
#define GET_USER_BANK_LIST @"getUserBankList.php?"
//申请提现
#define ADD_TIXIAN @"addTixian.php?"
//获取开户城市
#define GET_CITY @"getCity.php?"
//获取开户银行
#define GET_BANK_INFO @"getBankInfo.php?"
//添加银行卡
#define ADD_USER_BANK @"addUserBank.php?"
//提现列表
#define GET_TIXIAN_LIST @"getTixianList.php?"
//我的出房客户列表
#define GET_TUIJIAN_CHUFANG_LIST @"getTuijianChufangList.php?"
//我的托管客户列表
#define GET_TUIJIAN_TUOGUAN_LIST @"getTuijianTuoguanList.php?"
//搜索客户
#define GET_TUIJIAN_SEARCH_LIST @"getTuijianSearchList.php?"
//记录设备token
#define ADD_DEVICE_TOKEN @"addDeviceToken.php?"

//消息列表
#define GET_DEVICE_MSGS @"getDeviceMsgs.php?"
//更新消息查看状态
#define SET_DEVICE_MSG @"setDeviceMsg.php?"
//获取未读消息数量
#define GET_MSG_NUM @"getMsgNum.php?"

#endif
