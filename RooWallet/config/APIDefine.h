//
//  APIDefine.h
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#ifndef APIDefine_h
#define APIDefine_h

//主链图片：域名/blockchains/{chainCode}/logo.png
//币种图片：域名/blockchains/{chainCode}/assets/合约地址/logo.png


//主币图片：域名/token-icons/{chainCode}/assets/0x0000000000000000000000000000000000000000/logo.png
//币种图片：域名/token-icons/{chainCode}/assets/合约地址/logo.png


//例：

//https://api.roo.top/token-icons/heco/assets/0x0298c2b32eae4da002a15f36fdf7615bea3da047/logo.png
//https://api.roo.top/token-icons/heco/assets/0x25d2e80cb6b86881fd7e07dd263fb79f4abe033c/logo.png
//http://192.168.1.3/token-icons/heco/assets/0x0000000000000000000000000000000000000000/logo.png
//https://api.roo.top/token-icons/heco/assets/0x0298c2b32eae4da002a15f36fdf7615bea3da047/logo.png


//http://192.168.2.136/blockchains/eth/assets/0xdac17f958d2ee523a2206206994597c13d831ec7/info.json

#define DebugModel 1  //iOS网络框架环境  0: 开发环境 1：正式环境


//内网环境
/*********************内网环境*********************/
#if DebugModel== 0

#define HostApi  @"http://192.168.4.9/api/core/" //@"https://api.roo.top/api/core/" //@"http://47.243.185.220:9770/api/core/" //@"http://192.168.1.3/api/core/"//

#define RimageApi @"http://192.168.4.9/token-icons"

#define gdsocketHttp @"ws://192.168.4.9/ws"  //行情socket

//外网环境
/*********************外网环境*********************/

#elif DebugModel== 1

#define HostApi @"https://api.faithwalletapi.com/api/core/"

#define RimageApi @"https://api.faithwalletapi.com/token-icons"

#define gdsocketHttp @"wss://api.faithwalletapi.com/ws"  //行情socket


#endif

/*********************接口定义*********************/
#define agreementApi @"https://docs.qq.com/doc/DTHh1dUZyaHBLYXBZ"//用户协议



#define BlockAPI @"blockChain/info"// 主链信息
//#define tokenscAPI @"token/scan" //添加代币
#define sysConfigAPI @"sysConfig/all" //个人中心
#define tigetTickAPI @"ticker/getTickers" //行情
#define otCoinAPI @"otc/coins"//计价方式
#define otCraAPI @"otc/rates"// 计价汇率

#define getGasAPI @"gas/get"//gas获取

#define transactionAPI @"transaction/%@/txs"//交易记录
#define pushTrandAPI @"transaction/%@/tx"//指定哈希查询


#define dapptyAPI @"dapps/types"//dapp分类
#define dalistAPI @"dapps/list"//dapps列表信息
#define dahotsAPI @"dapps/hots"//dapps热门列表
#define versAPI @"version/latest"//最新版本获取
#define pushAddAPI @"push/account/sub"//订阅动账通知[批量提交钱包地址数据，不管删除还是新建]
//#define pushunsubAPI @"push/account/unsub"//取消动账通知

#define finaciAPI @"financial/page"//理财分页
#define getResourAPI @"token/resource/getResource"//查询币种资源
#define getPlatAPI @"ticker/getPlatform"//查询交易平台
#define getKlinAPI @"ticker/getKline"//查询K线
#define getBanAPI @"banner/getBanners"//查询banner
#define defipairAPI @"defi/pair/page"//交易对分页

#define deflistAPI @"defi/pair/list"//交易对自选列表
#define defpargetAPI @"defi/pair/get"//交易对详情
#define defplichartAPI @"defi/price/lineChart"//价格走势图数据

#define defransactionAPI @"defi/transaction/transaction"//最近交易列表
#define blockChaAddtokenAPI @"blockChain"//查询代币信息
#define blockgetbanleAPI @"balance/v1/%@/getBalances"//余额查询
#define blockgetbanleAPI2 @"balance/v1/getBalances"//余额查询
#define messacgAPI @"message"//根据消息id获取消息

#define transubtragdAPI @"https://api.roo.top/api/integral/transfer/v1/submitTransfer"//转账积分
#define getAllBalanAPI @"balance/v1/getAllBalances"//获取所有余额信息
///
#define getquestionAPI @"questionnaire/get"//获取调查问卷题目











///transaction/{chainCode}/txs


#endif /* APIDefine_h */
