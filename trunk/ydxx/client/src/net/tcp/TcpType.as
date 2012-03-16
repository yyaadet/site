package net.tcp
{
	/**
	 * 消息包类型 
	 * @author StarX
	 * 
	 */	
	public class TcpType
	{
		
		/////////////////////////////////客户端发送的消息////////////////////////////////////////////////
		//登陆
		public static const SEND_USER_LOGIN:int = 100;
		public static const USER_LOGIN_NAME:String = "登录";
		
		//创建角色
		public static const SEND_CREATE_USER:int = SEND_USER_LOGIN + 1;
		public static const CREATE_USER_NAME:String = "创建角色";
		
		//建筑升级
		public static const SEND_LEVEL_UP:int = SEND_CREATE_USER + 1;
		public static const LEVEL_UP_NAME:String = "建筑升级";
		
		//取消升级
		public static const SEND_CANCEL:int = SEND_LEVEL_UP + 1;
		public static const CANCEL_NAME:String = "取消升级";
		
		//加速升级
		public static const SEND_ACCE:int = SEND_CANCEL + 1;
		public static const ACCE_NAME:String = "加速升级";
		
		//校验升级
		public static const SEND_CHECK:int = SEND_ACCE + 1;
		public static const CHECK_NAME:String = "校验升级";
		
		//生产装备
		public static const SEND_MADE:int = SEND_CHECK + 1;
		public static const MADE_NAME:String = "生产";
		
		//合成装备
		public static const SEND_COMPOSE:int = SEND_MADE + 1;
		public static const COMPOSE_NAME:String = "强化";
		
		//回收装备
		public static const SEND_DESTROY:int = SEND_COMPOSE + 1;
		public static const DESTROY_NAME:String = "回收";
		
		//配兵
		public static const SEND_FIT:int = SEND_DESTROY + 1;
		public static const FIT_NAME:String = "配兵";
		
		//出征
		public static const SEND_MARCH:int = SEND_FIT + 1;
		public static const MARCH_NAME:String = "出征";
		
		//治疗
		public static const SEND_CURE:int = SEND_MARCH + 1;
		public static const CURE_NAME:String = "治疗";
		
		//刷新武将
		public static const SEND_REF_GEN:int = SEND_CURE + 1;
		public static const REF_GEN_NAME:String = "刷新武将";
		
		//登用武将
		public static const SEND_APP_GEN:int = SEND_REF_GEN + 1;
		public static const APP_GEN_NAME:String = "登用武将";
		
		//输送武将
		public static const SEND_TRAN_GEN:int = SEND_APP_GEN + 1;
		public static const TRAN_GEN_NAME:String = "输送武将";
		
		//拜访武将
		public static const SEND_VISIT_GEN:int = SEND_TRAN_GEN + 1;
		public static const VISIT_GEN_NAME:String = "拜访武将";
		
		//赐予
		public static const SEND_GRANT:int = SEND_VISIT_GEN + 1;
		public static const GRANT_NAME:String = "赐予";
		
		//购买宝物
		public static const SEND_BUY:int = SEND_GRANT + 1;
		public static const BUY_NAME:String = "购买宝物";
		
		//解雇武将
		public static const SEND_FIRE:int = SEND_BUY + 1;
		public static const FIRE_NAME:String = "解雇武将";
		
		//创建势力
		public static const SEND_CREATE_SPHERE:int = SEND_FIRE + 1;
		public static const CREATE_SPHERE_NAME:String = "创建势力";
		
		//势力禅让
		public static const SEND_DEMISE_SPHERE:int = SEND_CREATE_SPHERE + 1;
		public static const DEMISE_SPHERE_NAME:String = "势力禅让";
		
		//修改势力简介
		public static const SEND_MODIFY_SPHERE:int = SEND_DEMISE_SPHERE + 1;
		public static const MODIFY_SPHERE_NAME:String = "修改势力简介";
		
		//解散势力
		public static const SEND_DISSOLVE:int = SEND_MODIFY_SPHERE + 1;
		public static const DISSOLVE_NAME:String = "解散势力";
		
		//开除势力成员
		public static const SEND_FIRE_USER:int = SEND_DISSOLVE + 1;
		public static const FIRE_USER_NAME:String = "开除成员";
		
		//加入势力
		public static const SEND_JOIN_SPHERE:int = SEND_FIRE_USER + 1;
		public static const JOIN_SPHERE_NAME:String = "申请发送";
		
		//确认加入势力
		public static const SEND_CONF_JOIN:int = SEND_JOIN_SPHERE + 1;
		public static const CONF_JOIN_NAME:String = "加入势力";
		
		//退出势力
		public static const SEND_EXIT_SPHERE:int = SEND_CONF_JOIN + 1;
		public static const EXIT_SPHERE_NAME:String = "退出势力";
		
		//申请官位
		public static const SEND_APPLY_OFF:int = SEND_EXIT_SPHERE + 1;
		public static const APPLY_OFF_NAME:String = "申请官位";
		
		//申请同盟
		public static const SEND_APPLY_ALLI:int = SEND_APPLY_OFF + 1;
		public static const APPLY_ALLI_NAME:String = "申请同盟";
		
		//确认同盟
		public static const SEND_CONF_ALLI:int = SEND_APPLY_ALLI + 1;
		public static const CONF_ALLI_NAME:String = "确认同盟";
		
		//宣战
		public static const SEND_DECLARE_WAR:int = SEND_CONF_ALLI + 1;
		public static const DECLARE_WAR_NAME:String = "宣战";
		
		//移动
		public static const SEND_MOVE:int = SEND_DECLARE_WAR + 1;
		public static const MOVE_NAME:String = "移动";
		
		//军团变阵
		public static const SEND_ZHEN:int = SEND_MOVE + 1;
		public static const ZHEN_NAME:String = "变阵";
		
		//发送邮件
		public static const SEND_MAIL:int = SEND_ZHEN + 1;
		public static const MAIL_NAME:String = "发送邮件";
		
		//聊天
		public static const SEND_CHAT:int = SEND_MAIL + 1;
		public static const CHAT_NAME:String = "聊天";
		
		//学习技能，阵法
		public static const SEND_STUDY:int = SEND_CHAT + 1;
		public static const STUDY_NAME:String = "学习";
		
		//系统交易
		public static const SEND_DEAL_SYS:int = SEND_STUDY + 1;
		public static const DEAL_SYS_NAME:String = "交易";
		
		//挂单交易
		public static const SEND_DEAL_BILL:int = SEND_DEAL_SYS + 1;
		public static const DEAL_BILL_NAME:String = "挂单";
		
		//出售武器
		public static const SEND_DEAL_SELL:int = SEND_DEAL_BILL + 1;
		public static const DEAL_SELL_NAME:String = "出售";
		
		//购买武器
		public static const SEND_DEAL_BUY:int = SEND_DEAL_SELL + 1;
		public static const DEAL_BUY_NAME:String = "购买";
		
		//撤销交易
		public static const SEND_DEAL_CANCEL:int = SEND_DEAL_BUY + 1;
		public static const DEAL_CANCEL_NAME:String = "撤销";
		
		//接收任务
		public static const SEND_TASK:int = SEND_DEAL_CANCEL + 1;
		public static const TASK_NAME:String = "接收";
		
		//撤销任务
		public static const SEND_CANCEL_TASK:int = SEND_TASK + 1;
		public static const CANCEL_TASK_NAME:String = "撤销";
		
		//任务状态检查
		public static const SEND_TASK_STATE:int = SEND_CANCEL_TASK + 1;
		
		//领取奖励
		public static const SEND_BONUS:int = SEND_TASK_STATE + 1;
		public static const BONUS_NAME:String = "领取";
		
		//战役
		public static const SEND_FIGHT:int = SEND_BONUS + 1;
		public static const FIGHT_NAME:String = "战役";
		
		//领取俸禄
		public static const SEND_SALARY:int = SEND_FIGHT + 1;
		public static const SALARY_NAME:String = "领取俸禄";
		
		//掠夺
		public static const SEND_ROB:int = SEND_SALARY + 1;
		public static const ROB_NAME:String = "掠夺";
		
		//训练
		public static const SEND_TRAIN:int = SEND_ROB + 1;
		public static const TRAIN_NAME:String = "训练";
		
		//迁城
		public static const SEND_CHANGE_CITY:int = SEND_TRAIN + 1;
		public static const CHANGE_CITY_NAME:String = "迁城";
		
		//挑战玩家
		public static const SEND_FIGHT_USER:int = SEND_CHANGE_CITY + 1;
		public static const FIGHT_USR_NAME:String = "挑战玩家";
		
		//回复工时
		public static const SEND_RECOVER_MADE:int = SEND_FIGHT_USER + 1;
		public static const RECOVER_MADE_NAME:String = "回复工时";
		
		//回复兵力
		public static const SEND_RECOVER_SOLIDER:int = SEND_RECOVER_MADE + 1;
		public static const RECOVER_SOLIDER_NAME:String = "回复兵力";
		
		//训练加速
		public static const SEND_ACCE_TRAIN:int = SEND_RECOVER_SOLIDER + 1;
		public static const ACCE_TRAIN_NAME:String = "训练加速";
		
		//军令加速
		public static const SEND_ACCE_ORDER:int = SEND_ACCE_TRAIN + 1;
		public static const ACCE_ORDER_NAME:String = "军令加速";
		
		//购买军令
		public static const SEND_BUY_ORDER:int = SEND_ACCE_ORDER + 1;
		public static const BUY_ORDER_NAME:String = "购买军令";
		
		//申请盟主
		public static const SEND_APPLY_LEADER:int = SEND_BUY_ORDER + 1;
		public static const APPLY_LEADER_NAME:String = "申请盟主";
		
		//购买空间
		public static const SEND_BUY_STORE:int = SEND_APPLY_LEADER + 1;
		public static const BUY_STORE_NAME:String = "购买空间";
		
		//新手指引索引
		public static const SEND_GUID:int = SEND_BUY_STORE + 1;
		public static const GUID_NAME:String = "新手指引";
		
		//宣战攻城
		public static const SEND_ATTACK_CITY:int = SEND_GUID + 1;
		public static const ATTACK_CITY_NAME:String = "宣战";
		
		//报名攻城
		public static const SEND_JOIN_ATTACK:int = SEND_ATTACK_CITY + 1;
		public static const JOIN_ATTACK_NAME:String = "报名";
		
		//退出攻城
		public static const SEND_EXIT_ATTACK:int = SEND_JOIN_ATTACK + 1;
		public static const EXIT_ATTACK_NAME:String = "退出";
		
		//////////////////////////////////////////////////////////////////////////////////////////////
		
		/////////////////////////////////服务器通知的消息////////////////////////////////////////////////
		
		//下线通知
		public static const NOTIFY_OFF_LINE:int = 200;
		
		//创建角色通知
		public static const NOTIFY_CREATE_USER:int = NOTIFY_OFF_LINE + 1;
		
		//游戏时间通知
		public static const NOTIFY_GAME_TIME:int = NOTIFY_CREATE_USER + 1;
		
		//坞堡数据通知
		public static const NOTIFY_WUBAO:int = NOTIFY_GAME_TIME + 1;
		
		//武将数据通知
		public static const NOTIFY_GENERAL:int = NOTIFY_WUBAO + 1;
		
		//城池数据通知
		public static const NOTIFY_CITY:int = NOTIFY_GENERAL + 1;
		
		//势力数据通知
		public static const NOTIFY_SPHERE:int = NOTIFY_CITY + 1;
		
		//军团数据通知
		public static const NOTIFY_ARMY:int = NOTIFY_SPHERE + 1;
		
		//用户数据通知
		public static const NOTIFY_USER:int = NOTIFY_ARMY + 1;
		
		//外交关系通知
		public static const NOTIFY_DIP:int = NOTIFY_USER + 1;
		
		//玩家道具数据通知
		public static const NOTIFY_TREASURE:int = NOTIFY_DIP + 1;
		
		//战争通知
		public static const NOTIFY_WAR:int = NOTIFY_TREASURE + 1;
		
		//新邮件通知
		public static const NOTIFY_MAIL:int = NOTIFY_WAR + 1;
		
		//聊天通知
		public static const NOTIFY_CHAT:int = NOTIFY_MAIL + 1;
		
		//输送通知
		public static const NOTIFY_TRAN:int = NOTIFY_CHAT + 1;
		
		//挂单交易通知
		public static const NOTIFY_BILL:int = NOTIFY_TRAN + 1;
		
		//销售武器通知
		public static const NOTIFY_SELL:int = NOTIFY_BILL + 1;
		
		//战况通知
		public static const NOTIFY_FIGHT:int = NOTIFY_SELL + 1;
		
		//领取俸禄通知
		public static const NOTIFY_SALARY:int = NOTIFY_FIGHT + 1;
		
		//战役数据通知
		public static const NOTIFY_ZHANYI:int = NOTIFY_SALARY + 1;
		
		//关卡数据通知
		public static const NOTIFY_GUANKA:int = NOTIFY_ZHANYI + 1;
		
		//关卡武将通知
		public static const NOTIFY_PK:int = NOTIFY_GUANKA + 1;
		
		//战场通知
		public static const NOTIFY_ATTACK_CITY:int = NOTIFY_PK + 1;
		
		//进入战场通知
		public static const NOTIFY_JOIN_ATTACK:int = NOTIFY_ATTACK_CITY + 1;
		
		//退出战场通知
		public static const NOTIFY_EXIT_ATTACK:int = NOTIFY_JOIN_ATTACK + 1;
		
		//战场结束通知
		public static const NOTIFY_ATTACK_FINISH:int = NOTIFY_EXIT_ATTACK + 1;
		
		//////////////////////////////////////////////////////////////////////////////////////////////
	}
}