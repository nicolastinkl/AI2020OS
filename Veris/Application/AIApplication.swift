//
//  AIApplication.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Cartography
import UIKit

/*!
*  @author tinkl, 15-03-30 15:03:35
*
*  AI2020OS Application Paramters
*/
struct AIApplication {

    // MARK: LEANCLOUD APPKEY
    internal static let AVOSCLOUDID     = "ONPFU6g90vVGgIzW1oNULbAr-gzGzoHsz"
    internal static let AVOSCLOUDKEY    = "QGaeXgWKLbTBWCAsFL7zG1lz"


    #if DEBUG
//    internal static let KURL_ReleaseURL = "http://localhost:3006" // zx debug ip
    internal static let KURL_ReleaseURL = "http://171.221.254.231:2999/nsboss"
    #else
    internal static let KURL_ReleaseURL = "http://171.221.254.231:2999/nsboss" // RELEASE 服务器根地址
    #endif

    internal static let UMengAppID      = "5784b6a767e58e5d1b003373"      //友盟分享id

    // MARK: XUNFEI APPID
    internal static let XUNFEIAPPID  = "551ba83b"

    // MARK JSON RESPONSE

    struct JSONREPONSE {
        internal static let unassignedNum   =  "unassignedNum"  //未读执行条数
    }

    // MARK: All the ViewController Identifiers
    struct MainStoryboard {

        struct MainStoryboardIdentifiers {
            static let AIMainStoryboard             = "AIMainStoryboard"
            static let AILoginStoryboard            = "AILoginStoryboard"
            static let AILoadingStoryboard          = "AILoadingStoryboard"
            static let AIMenuStoryboard             = "AIMenuStoryboard"
            static let AIMesageCenterStoryboard     = "AIMesageCenterStoryboard"
            static let AIComponentStoryboard        = "AIComponentStoryboard"
            static let AISettingsStoryboard         = "AISettingsStoryboard"
            static let AIOrderStoryboard            = "AIOrderStoryboard"
            static let AIOrderDetailStoryboard      = "AIOrderDetailStoryboard"
            static let AISearchStoryboard           = "AISearchStoryboard"
            static let AIConnectMeunStoryboard      = "AIConnectMeunStoryboard"
            static let AITagFilterStoryboard        = "AITagFilterStoryboard"
            static let AIVideoStoryboard            = "AIVideoStoryboard"
            static let UIMainStoryboard             = "UIMainStoryboard"
            static let UIBuyerStoryboard            = "UIBuyerStoryboard"
            static let UIRrequirementStoryboard     = "UIRrequirementStoryboard"
            static let AIAlertStoryboard            = "AIAlertStoryboard"
            static let TaskExecuteStoryboard        = "TaskExecuteStoryboard"
            static let AIServiceExecuteStoryboard   = "AIServiceExecuteStoryboard"
            static let AIWorkManageStoryboard       = "AIWorkManageStoryboard"

        }

        // MARK: View
        struct ViewControllerIdentifiers {
            static let listViewController           = "listViewController"
            static let favoritsTableViewController  = "AIFavoritsTableViewController"
            static let AIMenuViewController         = "AIMenuViewController"
            static let AIMessageCenterViewController = "AIMessageCenterViewController"
            static let AICalendarViewController     = "AICalendarViewController"
            static let AIComponentChoseViewController   = "AIComponentChoseViewController"
            static let AISearchServiceCollectionViewController = "AISearchServiceCollectionViewController"
            static let AIBuyerDetailViewController = "AIBuyerDetailViewController"
            static let AIPageBueryViewController    = "AIPageBueryViewController"
            static let AIServiceContentViewController   = "AIServiceContentViewController"
            static let AIRequirementViewController  = "AIRequirementViewController"
            static let AIRequireContentViewController   = "AIRequireContentViewController"
            static let AIAssignmentContentViewController = "AIAssignmentContentViewController"
            static let AICollContentViewController = "AICollContentViewController"
            static let AIAlertViewController = "AIAlertViewController"
            static let AIGladOrderViewController    =   "AIGladOrderViewController"
            static let AIContestSuccessViewController = "AIContestSuccessViewController"
            static let AIServiceRouteViewController     = "AIServiceRouteViewController"
            static let TaskDetailViewController = "TaskDetailViewController"
//            static let TaskResultCommitViewController = "TaskResultCommitViewController"
            static let AILocationSearchViewController = "AILocationSearchViewController"
            static let AIConfirmOrderViewController = "AIConfirmOrderViewController"
            //add by liux at 20160615
            static let AIValidateRegistViewController = "AIValidateRegistViewController"
            static let AIRegistViewController = "AIRegistViewController"
            static let AIChangePasswordViewController = "AIChangePasswordViewController"
            static let AICustomerServiceExecuteViewController = "AICustomerServiceExecuteViewController"
            static let AIWorkInfoViewController = "AIWorkInfoViewController"
        }

        /*!
        *  @author tinkl, 15-09-09 15:09:38
        *
        *  Cell ID
        */
        struct CellIdentifiers {

            // MARK: HOME
            static let AIUIMainTopCell              = "UIMainTopCell"
            static let AIUIMainMediaCell            = "UIMainMediaCell"
            static let AIUIMainContentCell          = "UIMainContentCell"
            static let AIUIMainActionCell           = "UIMainActionCell"
            static let AIUIMainSpaceHloderCell      = "UIMainSpaceHloderCell"
            static let AIUISigntureTagsCell         = "UISigntureTagsCell"

            // MARK: Detail
            static let AISDDateCell                 = "AISDDateCell"
            static let AICoverFlowCell              = "AICoverFlowCell"
            static let AISDFightCell                = "AISDFightCell"
            static let AISDParamsCell               = "AISDParamsCell"
            static let AITitleServiceDetailCell     = "AITitleServiceDetailCell"
            static let AITableCellHolder            = "AITableCellHolder"
            static let AITableCellHolderParms       = "AITableCellHolderParms"
            static let AITableCellHolderParmsModel  = "AITableCellHolderParmsModel"

            // MARK: TIME LINE
            static let AITIMELINESDTimesViewCell    = "AITIMELINESDTimesViewCell"
            static let AITIMELINESDContentViewCell  = "AITIMELINESDContentViewCell"
            
            // MARK: SERVICE EXECUTE
            static let AITimelineTableViewCell = "AITimelineTableViewCell"
            static let AITimelineNowTableViewCell = "AITimelineNowTableViewCell"
            // MARK: MY_WALLET
            static let AICurrencyTableViewCell = "AICurrencyTableViewCell"
            static let AICouponTableViewCell = "AICouponTableViewCell"
            static let AIIconCouponTableViewCell = "AIIconCouponTableViewCell"
        }

        /*!
        *  @author tinkl, 15-09-09 15:09:44
        *
        *  DIY View ID
        */
        struct ViewIdentifiers {
            static let AIOrderBuyView           = "AIOrderBuyView"
            static let AILoginViewController    = "AILoginViewController"
            static let AIMessageUnReadView      = "AIMessageUnReadView"
            static let AIHomeViewStyleMultiepleView = "AIHomeViewStyleMultiepleView"
            static let AIHomeViewStyleTitleView = "AIHomeViewStyleTitleView"
            static let AIHomeViewStyleTitleAndContentView = "AIHomeViewStyleTitleAndContentView"
            static let AIServiceDetailsViewCotnroller = "AIServiceDetailsViewCotnroller"
            static let AIErrorRetryView     = "AIErrorRetryView"
            static let AIServerScopeView    = "AIServerScopeView"
            static let AIServerTimeView     = "AIServerTimeView"
            static let AIServerAddressView  = "AIServerAddressView"
            static let AITableViewInsetMakeView =   "AITableViewInsetMakeView"
            static let AITabelViewMenuView  = "AITabelViewMenuView"
            static let AICalendarViewController =   "AICalendarViewController"
            static let AIScanViewController = "AIScanViewController"


        }

        /*!
         *  @author wantsor, 16-06-13 15:09:44
         *
         *  DIY Segue
         */
        struct StoryboardSegues {
            static let SelectRegionSegue = "SelectRegionSegue"
            static let ValidateRegisterSegue = "ValidateRegisterSegue"
            static let RegisterSegue = "RegisterSegue"
        }
    }

    // MARK: Notification with IM or System Push.
    struct Notification {
        // 刷新买家中心数据
        static let AIRefreshBuyerCenterNotification    = "AIRefreshBuyerCenterNotification"
        // 刷新卖家中心数据
        static let AIRefreshSellerCenterNotification   = "AIRefreshSellerCenterNotification"
        //
        static let UIAIASINFOWillShowBarNotification    = "UIAIASINFOWillShowBarNotification"
        static let UIAIASINFOWillhiddenBarNotification  = "UIAIASINFOWillhiddenBarNotification"
        // 用户登录成功之后重新刷新主界面的数据
        static let UIAIASINFOLoginNotification          = "UIAIASINFOLoginDidLoginSuccessNotification"
        
        // 会话过期重新登录
        static let UIRELoginNotification                = "UIRELoginNotification"
        static let UIAIASINFOLogOutNotification         = "UIAIASINFOLogOutNotification"

        static let UIAIASINFOOpenAddViewNotification         = "UIAIASINFOOpenAddViewNotification"
        static let UIAIASINFOOpenRemoveViewNotification         = "UIAIASINFOOpenRemoveViewNotification"
        static let UIAIASINFOChangeDateViewNotification         = "UIAIASINFOChangeDateViewNotification"
        static let UIAIASINFOmotifyParamsNotification =     "UIAIASINFOmotifyParamsNotification"
        //  视频拍摄完成文件地址
        static let NSNotirydidFinishMergingVideosToOutPutFileAtURL  = "NSNotirydidFinishMergingVideosToOutPutFileAtURL"
        //一键清除订单
        static let UIAIASINFORecoverOrdersNotification = "UIAIASINFORecoverOrdersNotification"


        static let AIDatePickerViewNotificationName  = "AIDatePickerViewNotificationName"
        static let AISinglePickerViewNotificationName  = "AISinglePickerViewNotificationName"
        static let AIAIRequirementViewControllerNotificationName    = "AIAIRequirementViewControllerNotificationName"
        static let AIAIRequirementShowViewControllerNotificationName    = "AIAIRequirementShowViewControllerNotificationName"
        static let AIAIRequirementNotifyOperateCellNotificationName    = "AIAIRequirementNotifyOperateCellNotificationName"
        static let AIAIRequirementNotifyClearNumberCellNotificationName    = "AIAIRequirementNotifyClearNumberCellNotificationName"
        static let AIAIRequirementNotifynotifyGenerateModelNotificationName    = "AIAIRequirementNotifynotifyGenerateModelNotificationName"
        static let AIRequireContentViewControllerCellWrappNotificationName    = "AIRequireContentViewControllerCellWrappNotificationName"

        static let AIRequirementViewShowAssignToastNotificationName    = "AIRequirementViewShowAssignToastNotificationName"

        //服务执行页选择一个服务实例的通知 add by liux at 20160330
        static let AIRequirementSelectServiceInstNotificationName = "AIRequirementSelectServiceInstNotificationName"

        //关闭弹出框UI的通知
        static let AIRequirementClosePopupNotificationName = "AIRequirementClosePopupNotificationName"

        //更新查询需求分析数据的通知
        static let AIRequirementReloadDataNotificationName = "AIRequirementReloadDataNotificationName"

    
        // 远程协助状态更新
        static let AIRemoteAssistantConnectionStatusChangeNotificationName = "AIRemoteAssistantConnectionStatusChangeNotificationName"
        static let AIRemoteAssistantManagerMessageReceivedNotificaitonName = "AIRemoteAssistantManagerMessageReceivedNotificaitonName"
        static let AIRemoteAssistantAnchorOperationCompletedNotificationName = "AIRemoteAssistantAnchorOperationCompletedNotificationName"
        static let AIDeepLinkupdateDeepLinkView = "AIDeepLinkupdateDeepLinkView"
        // 刷新时间线通知
        static let AITimelineRefreshNotificationName = "AITimelineRefreshNotificationName"
        
        //语音识别
        
        static let AIListeningAudioTools    =    "AIListeningAudioTools"
        
        static let WeixinPaySuccessNotification =  "WeixinPaySuccessNotification"
        
        // 关闭所有VC
        static let dissMissPresentViewController    = "dissMissPresentViewController"
        
        //许愿详情提交成功后给主界面数据刷新
        static let WishVowViewControllerNOTIFY = "WishVowViewControllerNOTIFY"



        // 登录通知

        static let UserLoginTimeOutNotification = "UserLoginTimeOutNotification"

        static let UserLoginOutNotification = "UserLoginOutNotification"
        // 注册通知
        static let UserDidRegistedNotification = "UserDidRegistedNotification"

        // 收藏成功
        static let DidUserCollectSuccess = "DidUserCollectSuccess"
        static let DidUserCollectCancel = "DidUserCollectCancel"
    }

    // MARK: System theme's color
    struct AIColor {
        static let MainTextColor     = "#FFFFFF"
//        static let MainTextColor     = "#41414C"
        static let MainTabBarBgColor = "#00cec0"
        static let MainYellowBgColor = "#f0ff00"
        static let MainGreenBgColor  = "#5fc30d"

        static let AIVIEWLINEColor   = "#E4E3E4"

        static let MainSystemBlueColor   = "#625885"//"#00CEC3"
        static let MainSystemBlackColor  = "#848484"
        static let MainSystemGreenColor  = "#00cec0"

        static let MainSystemLineColor  = "#F1F1F1"
    }

    struct AIViewTags {
        static let loadingProcessTag        = 101
        static let errorviewTag             = 102
        static let AIMessageUnReadViewTag   = 103
    }

    struct AIStarViewFrame {
        static let width: CGFloat            = 60.0
        static let height: CGFloat           = 9.0
    }

    struct AIImagePlaceHolder {
        static let AIDefaultPlaceHolder = "http://tinkl.qiniudn.com/tinklUpload_scrollball_5.png"
    }

    // MARK: IM ObjectIDS
    struct AIIMOBJECTS {
        static let AIYUJINGID = "556c0a2ae4b09419962544b7"          //预警通知
        static let AIFUWUTUIJISNID = "556c0acce4b0941996254a49"     //服务推荐
        static let AITUIKUAN = "556c0b8fe4b0941996254f8f"           //退款通知
        static let AIXITONG = "556c0c06e4b0941996255223"            //系统通知
    }

    // MARK: The Application preferorm
    internal func SendAction(functionName: String, ownerName: AnyObject) {
        /*!
        *   how to use it ?
        SendAction("minimizeView:", ownerName: self)
        */
        UIApplication.sharedApplication().sendAction(Selector(functionName), to: nil, from: ownerName, forEvent: nil)
    }

    

    /**
     根据不同环境获取服务器Api地址.
     */
    internal enum AIApplicationServerURL: CustomStringConvertible {

        // 获取服务方案
        case getServiceScheme
        // 添加服务Note (文本和语音)
        case addWishListNote
        // 删除服务Note (文本和语音)
        case delWishListNote
        // 保持服务参数
        case saveServiceParameters
        // 提交Proposal订单
        case submitProposalOrder
        // 查询卖家订单列表
        case querySellerOrderList
        // 更新参数设置状态
        case updateParamSettingState
        // 删除服务类别
        case delServiceCategory
        // 查询客户Proposal列表
        case queryCustomerProposalList
        // 查询客户订单列表
        case queryProcOrders
        // 查找客户Proposal详情
        case findCustomerProposalDetail
        // 查找服务详情
        case findServiceDetail
        case findServiceDetailNew
        // 更新心愿单tag状态
        case updateWishListTagChosenState
        //查询热门搜索
        case queryHotSearch
        // 获取Api具体地址.
        case recoverOrders
        // 获取Api具体地址.
        case submitOrderByService
        // 查询价格
        case findServicePrice

        // 查询需求管理初始化信息
        case queryBusinessInfo

        // 原始需求列表
        case queryOriginalRequirements

        // 直接保存为待分配状态
        case saveAsTask

        // 查询待分配标签列表接口
        case queryUnassignedRequirements

        // 转化为标签
        case saveTagsAsTask

        // 转化为备注
        case addNewTag

        // 保存新增备注
        case addNewNote

        //MARK: 增加新的任务节点
        case addNewTask

        //MARK: 设置权限
        case setServiceProviderRights

        //MARK: 派单
        case assginTask

        //MARK: 查询子服务默认标签列表
        case queryServiceDefaultTags

        //MARK: 将需求共享给其它子服务
        case distributeRequirement

        //MARK: 查询所有的任务节点
        case queryTaskList

        //MARK: 提交抢单
        case grabOrder

        //MARK: 查询待抢任务信息
        case queryGrabOrderDetail

        //MARK: 初始化任务实例
        case initTask

        //MARK: 注册
        case register
        //MARK: 登陆
        case login
        // 单一服务评论
        case serviceComment
        // 复合服务评论
        case compondComment
        // 评论规格
        case commentSpec
        // 提交评论
        case saveComment
        // 服务优势介绍
        case preview
        // 产品详情
        case detail
        // 2.6.6 所有推荐（为您推荐）
        case allRecommends
        // 2.6.7 服务者介绍
        case queryProvider
        // 2.6.4 所有问题（常见问题）
        case allQuestions
        // 2.6.4 删除定制服务
        case setProposalItemDisableFlag
        // 2.6.4 提交问题
        case submitQuestions
        // 2.2.1 最近搜索
        case recentlySearch
        case createBrowserHistory
        // 2.2.2 商品搜索并带出过滤条件
        case searchServiceCondition
        // 2.2.3 商品搜索结果过滤
        case filterServices
        // 2.2.4 商品推荐
        case getRecommendedServices
        // 2.11.5 查询某个服务所有的评论列表
        case queryAllComments
        // 3.8.5 查询评论统计信息
        case queryRatingStatistics
        case getOpenTokToken
        // 2.12.2 查询供需最大的工作机会
        case queryMostRequestedWork
        // 2.12.3 查询最新工作机会
        case queryNewestWorkOpportunity
        // 2.12.1 查询最受欢迎的工作机会
        case queryMostPopularWork
        // 2.14.3.	资金帐户列表
        case capitalAccounts
        // 2.14.12.	我的会员卡
        case queryMemberCard
        
        // 图像识别
        case uploadAndIdentify
        // 许愿提交
        case makewish
        // 许愿查询
        case wishpreview
        // 添加收藏
        case favoriteadd
        // 查询服务执行详情
        case queryTimeLine
        // 查询时间线内容
        case queryTimeLineDetail
        // 查询支付订单
        case queryPayment
        // 许愿查询 最热 & 推荐
        case wishhotAndWishrecommand
        // 许愿纪录
        case queryWishRecordList
        // 检查是否可以许愿
        case checkCustomerWish
        // 提交服务执行结果
        case queryQiangDanResult
        case submitServiceNodeResult

        // 服务步骤节点详情
        case queryProcedureInstInfo
        // 更新服务节点执行状态
        case updateServiceNodeStatus
        // 消费者授权操作
        case customerAuthorize
        // 消费者确认子服务/订单完成
        case confirmOrderComplete
        // 请求用户授权
        case submitRequestAuthorization
        // 启动服务流程实例
        case startServiceProcess
        // 查询工作机会详情
        case queryWorkOpportunity
        // 查询工作机会资质
        case getWorkQualification
        // 订阅工作机会
        case subscribeWorkOpportunity
        // 查询已订阅的工作机会
        case querySubscribedWorkOpportunity
        // 更新工作机会状态
        case updateWorkStatus
        // 上传工作机会服务资质
        case uploadWorkQualification
        // 查询我的商家币
        case queryMyCoins
        // 查询优惠券
        case queryMyVoucher
        // 资金流水
        case getCapitalFlowList
        // 资金类型
        case getCapitalTypeList
        //我的钱包首页
        case accountIndex
        //我的余额
        case blanceInfo
        //我的待付
        case waitPayOrders
        //我的待收
        case waitCollectOrders
        //我的待收-提醒
        case noticePay

        //查询我的信用积分
        case queryCreditScore

        //检查支付
        case checkBalancePay
        //检查余额
        case checkBalance

        
        var description: String {

            switch self {
            case .getServiceScheme: return AIApplication.KURL_ReleaseURL+"/getServiceScheme"
            case .addWishListNote: return AIApplication.KURL_ReleaseURL+"/wish/addWishListNote"
            case .delWishListNote: return AIApplication.KURL_ReleaseURL+"/wish/delWishListNote"
            case .saveServiceParameters: return AIApplication.KURL_ReleaseURL+"/proposal/saveServiceParameters"
            case .submitProposalOrder: return AIApplication.KURL_ReleaseURL+"/proposal/submitProposalOrder"
            case .querySellerOrderList: return AIApplication.KURL_ReleaseURL+"/order/querySellerOrderList"
            case .updateParamSettingState: return AIApplication.KURL_ReleaseURL+"/proposal/updateParamSettingState"
            case .delServiceCategory: return AIApplication.KURL_ReleaseURL+"/delServiceCategory"
            case .queryCustomerProposalList: return AIApplication.KURL_ReleaseURL+"/queryCustomerProposalList"
            case .queryProcOrders: return AIApplication.KURL_ReleaseURL + "/order/queryProcOrders"
            case .findCustomerProposalDetail: return AIApplication.KURL_ReleaseURL+"/proposal/findCustomerProposalDetailNew"
            case .findServiceDetail: return AIApplication.KURL_ReleaseURL+"/proposal/findServiceDetail"
            case .updateWishListTagChosenState: return AIApplication.KURL_ReleaseURL+"/wish/updateWishListTagChosenState"
            case .queryHotSearch: return "http://171.221.254.231:8282/sboss/queryHotSearch"
            case .recoverOrders: return AIApplication.KURL_ReleaseURL+"/order/recoverOrders"
            case .submitOrderByService:   return AIApplication.KURL_ReleaseURL + "/order/submitOrderByService"
            case .findServiceDetailNew: return AIApplication.KURL_ReleaseURL+"/proposal/findServiceDetailNew"
            case .findServicePrice: return AIApplication.KURL_ReleaseURL + "/service/findServicePrice"


            // 原始需求列表
            case .queryBusinessInfo: return AIApplication.KURL_ReleaseURL + "/requirement/queryCustomerInfoSubserverList"
            case .queryOriginalRequirements: return AIApplication.KURL_ReleaseURL + "/requirement/queryOriginalRequirements"
            case .saveAsTask: return AIApplication.KURL_ReleaseURL + "/requirement/updateDistributionState"
            case .queryUnassignedRequirements: return AIApplication.KURL_ReleaseURL + "/requirement/queryUnDistributeRequirementList"
            case .saveTagsAsTask: return AIApplication.KURL_ReleaseURL + "/requirement/saveAnalysisTag"
            case .addNewNote: return AIApplication.KURL_ReleaseURL + "/requirement/saveAnalysisNote"
            case .addNewTag : return AIApplication.KURL_ReleaseURL + "/requirement/addWishTag"
            case .addNewTask : return AIApplication.KURL_ReleaseURL + "/requirement/saveAnalysisTaskNode"
            case .setServiceProviderRights : return AIApplication.KURL_ReleaseURL + "/requirement/updateAccessPermission"
            case .assginTask : return AIApplication.KURL_ReleaseURL + "/requirement/submitWorkOrder"
            case .queryServiceDefaultTags : return AIApplication.KURL_ReleaseURL + "/requirement/queryDistributionTagList"
            case .distributeRequirement : return AIApplication.KURL_ReleaseURL + "/requirement/distributeRequirement"
            case .queryTaskList: return AIApplication.KURL_ReleaseURL + "/requirement/queryTaskNodeList"


            //抢单接口
            case .grabOrder: return AIApplication.KURL_ReleaseURL + "/scrambleOrder/submitScrambleOrder"
            case .queryGrabOrderDetail: return AIApplication.KURL_ReleaseURL + "/scrambleOrder/queryScrambleOrderInfo"
            case .initTask: return AIApplication.KURL_ReleaseURL + "/initTask"
                
            //登陆注册接口
            case .register: return AIApplication.KURL_ReleaseURL + "/admin/register"
            case .login: return AIApplication.KURL_ReleaseURL + "/admin/login"
                
            //服务评论接口
            case .serviceComment: return AIApplication.KURL_ReleaseURL + "/comments/queryServiceComments"
            case .compondComment: return AIApplication.KURL_ReleaseURL + "/comments/queryCompServiceComments"
            case .commentSpec: return AIApplication.KURL_ReleaseURL + "/comments/queryCommentSpecification"
            case .saveComment: return AIApplication.KURL_ReleaseURL + "/comments/saveComments"
                
            case .preview: return AIApplication.KURL_ReleaseURL + "/service/preview"
            case .detail: return  AIApplication.KURL_ReleaseURL + "/service/detail"
            case .allRecommends: return AIApplication.KURL_ReleaseURL + "/service/allRecomends"
            case .queryProvider: return AIApplication.KURL_ReleaseURL + "/service/queryProvider"
            case .allQuestions: return AIApplication.KURL_ReleaseURL + "/service/allQuestions"
            case .recentlySearch: return AIApplication.KURL_ReleaseURL + "/search/recentlySearch"
            case .createBrowserHistory: return AIApplication.KURL_ReleaseURL + "/search/createBrowserHistory"
            case .searchServiceCondition: return AIApplication.KURL_ReleaseURL + "/search/searchServiceCondition"
            case .filterServices: return AIApplication.KURL_ReleaseURL + "/search/filterServices"
            case .getRecommendedServices: return AIApplication.KURL_ReleaseURL + "/search/getRecommendedServices"
            case .queryAllComments: return AIApplication.KURL_ReleaseURL + "/comments/queryAllComments"
            case .queryRatingStatistics: return AIApplication.KURL_ReleaseURL + "/comments/queryRatingStatistics"
            case .getOpenTokToken: return AIApplication.KURL_ReleaseURL + "/remoteAssistant/getOpenTokToken"
                
            case .uploadAndIdentify: return "http://171.221.254.231:3001/uploadAndIdentify"

            case .makewish: return AIApplication.KURL_ReleaseURL + "/wish/saveWishRecord"
            case .wishpreview: return AIApplication.KURL_ReleaseURL + "/wish/queryWishList"
            case .favoriteadd: return AIApplication.KURL_ReleaseURL + "/favorite/add"
            case .queryWishRecordList: return AIApplication.KURL_ReleaseURL + "/wish/queryWishRecordList"
            //服务执行相关接口
            case .queryTimeLine: return AIApplication.KURL_ReleaseURL + "/order/queryTimeLine"
            case .queryTimeLineDetail: return AIApplication.KURL_ReleaseURL + "/order/queryTimeLineDetail"
            case .queryPayment: return AIApplication.KURL_ReleaseURL + "/payment/queryPayment"
            case .wishhotAndWishrecommand: return AIApplication.KURL_ReleaseURL + "/wish/queryWishList"
            case .submitServiceNodeResult: return AIApplication.KURL_ReleaseURL + "/serviceProcess/submitServiceNodeResult"
            case .queryQiangDanResult: return AIApplication.KURL_ReleaseURL + "/scrambleOrder/queryScrambleOrderResult"
            case .queryProcedureInstInfo: return AIApplication.KURL_ReleaseURL + "/serviceProcess/queryProcedureInstInfo"
            case .updateServiceNodeStatus: return AIApplication.KURL_ReleaseURL + "/serviceProcess/updateServiceNodeStatus"
            case .customerAuthorize: return AIApplication.KURL_ReleaseURL + "/order/authorize"
            case .confirmOrderComplete: return AIApplication.KURL_ReleaseURL + "/order/confirm"
            case .submitRequestAuthorization: return AIApplication.KURL_ReleaseURL + "/serviceProcess/submitRequestAuthorization"
            case .startServiceProcess: return AIApplication.KURL_ReleaseURL + "/serviceProcess/startServiceProcess"
            case .checkCustomerWish: return  AIApplication.KURL_ReleaseURL + "/wish/checkCustomerWish"

            //工作机会相关接口
            case .queryWorkOpportunity: return AIApplication.KURL_ReleaseURL + "/workopportunity/queryWorkOpportunitySubscribed"
            case .getWorkQualification: return AIApplication.KURL_ReleaseURL + "/workopportunity/getWorkQualification"
            case .subscribeWorkOpportunity: return AIApplication.KURL_ReleaseURL + "/workopportunity/subscribeWorkOpportunity"
            case .querySubscribedWorkOpportunity: return AIApplication.KURL_ReleaseURL + "/workopportunity/querySubscribedWorkOpportunity"
            case .updateWorkStatus: return AIApplication.KURL_ReleaseURL + "/workopportunity/updateWorkStatus"
            case .submitQuestions: return AIApplication.KURL_ReleaseURL + "/service/submitQuestion"
            case .setProposalItemDisableFlag: return  AIApplication.KURL_ReleaseURL + "/proposal/setProposalItemDisableFlag"
            case .queryMostRequestedWork: return AIApplication.KURL_ReleaseURL + "/workopportunity/queryMostRequestedWork"
            case .queryNewestWorkOpportunity: return AIApplication.KURL_ReleaseURL + "/workopportunity/queryNewestWorkOpportunity"
            case .queryMostPopularWork: return AIApplication.KURL_ReleaseURL + "/workopportunity/queryMostPopularWork"
            case .uploadWorkQualification: return AIApplication.KURL_ReleaseURL + "/workopportunity/uploadWorkQualification"
                
            // 我的钱包相关接口
            case .queryMyCoins: return AIApplication.KURL_ReleaseURL + "/account/myCoins"
            case .queryMyVoucher: return AIApplication.KURL_ReleaseURL + "/account/myVouchers"
            case .capitalAccounts: return AIApplication.KURL_ReleaseURL + "/account/capitalAccts"
            case .queryMemberCard: return AIApplication.KURL_ReleaseURL + "/account/queryMemberCard"
                
            // 资金流水相关接口
            case .getCapitalFlowList: return AIApplication.KURL_ReleaseURL + "/account/moneyList"
            case .getCapitalTypeList: return AIApplication.KURL_ReleaseURL + "/account/moneyListType"
                
            case .accountIndex: return AIApplication.KURL_ReleaseURL + "/account/index"
            case .blanceInfo: return  AIApplication.KURL_ReleaseURL + "/account/balance"
            case .waitPayOrders: return  AIApplication.KURL_ReleaseURL + "/account/waitPayOrders"
            case .waitCollectOrders: return  AIApplication.KURL_ReleaseURL + "/account/waitCollectOrders"
            case .noticePay: return  AIApplication.KURL_ReleaseURL + "/account/noticePay"
            case .queryCreditScore: return AIApplication.KURL_ReleaseURL + "/account/queryCreditScore"
            case .checkBalancePay: return AIApplication.KURL_ReleaseURL + "/sboss/checkBalancePay"
            case .checkBalance: return AIApplication.KURL_ReleaseURL + "/account/checkBalance"
            }
        }
    }



    /*!
     隐藏消息按钮
     */
    static func hideMessageUnreadView() {
        if let loadingXibView = UIApplication.sharedApplication().keyWindow!.viewWithTag(AIApplication.AIViewTags.AIMessageUnReadViewTag) {
            loadingXibView.hidden = true
        }
    }


    //MARK: - Case0服务，官方唯一指定抢单任务
    static let AIServiceIdCase0 = "900001001003"

}

/*
增加class泛型工具 一般在引用传递时使用.
*/
class AIWrapper<T> {
    var wrappedValue: T
    init(theValue: T) {
        wrappedValue = theValue
    }
}
