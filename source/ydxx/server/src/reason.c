#include "hf.h"

struct ReasonInfo {
	REASON_TYPE m_type;
	const char *m_content;
};
typedef struct ReasonInfo ReasonInfo;

static char g_reason_buf[MAX_BUFFER];

static ReasonInfo g_reason_info[] = {
	{REASON_NOT_FOUND_GENE, "武将不存在"},
	{REASON_NOT_FOUND_CMD, "指令已经不存在了"},
	{REASON_NOT_FOUND_TREA, "道具不存在"},
	{REASON_NOT_FOUND_STATE, "场景不存在"},
	{REASON_NOT_FOUND_CITY, "城池不存在"},
	{REASON_NOT_FOUND_ARMY, "军团不存在"},
	{REASON_NOT_FOUND_IDLE_WUBAO, "无可用坞堡"},
	{REASON_NOT_FOUND_USER, "用户不在本副本"},
	{REASON_NOT_FOUND_SPHERE, "势力不存在"},
	{REASON_NOT_FOUND_IDLE_CITY, "未找到可分配的城池"},
	{REASON_NOT_FOUND_WUBAO, "该坞堡不存在"},
	{REASON_TREA_TYPE_ERR, "道具类型不对"},
	{REASON_TREA_USED, "道具已经被使用了"},
	{REASON_CMD_SPEEDED, "指令已经加速过了"},
	{REASON_CMD_UNABLE_SPEED, "指令不在加速范围之内"},
	{REASON_WEB_ERR, "网站很慢，重试一下"},
	{REASON_UNABLE_EXIT, "游戏未结束，不允许退出游戏"},
	{REASON_AUTH_ERR, "认证失败"},
	{REASON_FOUND_MULTI_ROLE, "发现多个重复角色"},
	{REASON_ROOM_FULL, "副本玩家已满"},
	{REASON_SPHERE_NAME_USED, "势力名已经被占用"},
	{REASON_MEM_SHORTAGE, "服务器内存空间不足"},
	{REASON_FOUND_MULTI_SPHERE, "发现多个重复势力"},
	{REASON_FOUND_MULTI_GENE, "发现多个重复武将"},
	{REASON_GENE_NOT_IN_CITY, "武将不在城中"},
	{REASON_GENE_IS_WORKING, "武将正在工作中"},
	{REASON_AI_ERR, "AI引擎出错"},
	{REASON_MONEY_SHORTAGE, "金币不足"},
	{REASON_SOL_SHORTAGE, "兵力不足"},
	{REASON_EXCEED_GENE_FOLLOW, "所带兵力超过了最大带兵数"},
	{REASON_RESOURCE_SHORTAGE, "资源不足"},
	{REASON_WEAPON_SHORTAGE, "物质不足"},
	{REASON_WEB_DATA_FORMAT_ERR, "Web数据中心格式出错"},
	{REASON_VIP_HOUR_ERR, "Vip时辰不对"},
	{REASON_HAVE_LOGINED, "您已经在其他地点登陆"},
	{REASON_SPHERE_UNMATCHED, "势力不匹配"},
	{REASON_SOL_IS_ZERO, "士兵数为零"}, 
	{REASON_CITY_IN_SAFE_TIME, "城池在保护期中"},
	{REASON_TALK_MSG_TOO_LONG, "聊天消息过长"},
	{REASON_GENE_HAD_SKILL, "武将已经拥有了该技能"},
	{REASON_GENE_HAD_ZHEN, "武将已经拥有了该阵法"},
	{REASON_GENE_NOT_HAVE_ZHEN, "武将未掌握该阵法"},
	{REASON_GENE_FOLLOW_SHORTAGE, "武将带领兵数不足"},
	{REASON_MULT_NAME, "用户名已经被他人使用，不可用"},
	{REASON_UPING, "正在升级中"},
	{REASON_SPEED_HOUR_ERR, "对象未在升级状态中"},
	{REASON_UNREACHED, "条件未满足"},
	{REASON_GENE_HAS_USED_BY_OTHER, "武将已经被他人招募了"},
	{REASON_GENE_HAS_SAME_TYPE_TREA, "武将已经拥有了同类型的道具"},
	{REASON_LEVEL_UP_TYPE_ERR, "升级类型有错"},
	{REASON_LEVEL_UP_TECH_ERR, "升级科技有错"},
	{REASON_LEVEL_UP_BUIL_ERR, "升级建筑有错"},
	{REASON_REQ_FMT_ERR, "请求数据包格式有误"}, 
	{REASON_GENE_HAS_REACHE_MAX, "武将数目已经达到上限"},
	{REASON_WEAP_TYPE_ERR, "装备类型错误"},
	{REASON_WEAP_LEVEL_ERR, "装备等级有误"},
	{REASON_CHANGE_ZHEN_TIME_ERR, "请稍候变阵"},
	{REASON_USER_HAS_SPH, "用户已经拥有了势力"},
	{REASON_DIPL_EXIST, "已有了外交关系"},
	{REASON_EXP_TYPE_ERR, "出征类型错误"},
	{REASON_USER_PRAC, "用户正在修炼中"},
	{REASON_GENE_HAS_HURT, "武将身上还有伤兵"},
	{REASON_RES_TYPE_ERR, "资源类型错误"},
	{REASON_TRADE_TYPE_ERR, "交易类型错误"},
	{REASON_NOT_FOUND_ORDER, "交易单不存在"},
	{REASON_RES_SHORTAGE, "资源不足"},
	{REASON_NOT_FOUND_TASK, "任务不存在"},
	{REASON_NOT_FOUND_BOX, "擂主不存在"},
	{REASON_JL_SHORTAGE, "当前您的军令已经用光了"},
	{REASON_NOT_FOUND_GUANKA, "关卡不存在"},
	{REASON_NOT_FOUND_ROOM, "战场不存在"},
	{REASON_DEF,""},
};

const char *get_reason(int type)
{
	ReasonInfo *info = NULL;

	if (type <= REASON_NONE || type>=REASON_MAX)
		return "未知错误";

	if (type == REASON_DEF)
		return g_reason_buf;

	info = &g_reason_info[type - 1];
	
	return info->m_content;
}


void set_reason(const char *fmt, ...)
{
	va_list ap;
	
	va_start(ap, fmt);

	vsnprintf(g_reason_buf, MAX_BUFFER - 1, fmt, ap);	
	va_end(ap);
}
