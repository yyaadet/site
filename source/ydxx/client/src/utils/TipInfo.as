package utils
{
	import wubao.model.Tech;
	
	/**
	 * 界面提示信息 
	 * @author bxl
	 * 
	 */	
	public class TipInfo
	{
		public function TipInfo()
		{
		}
		
		/**
		 * VIP提示信息 
		 * @return 
		 * 
		 */		
		public static function getVIPInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "VIP功能" + "\n" +
                   "1： 可增加资源产量20%" + "\n" + 
		           "2： 战斗中伤兵比率99%" + "\n" + 
		           "3： 客栈中来访武将属性更高" + "\n" + 
		           "4： 增加1个建筑队列";
		           
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 议事堂提示信息 
		 * @return 
		 * 
		 */		
		public static function getYstInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　议事堂是坞堡的核心建筑，民居、军营、库房、医馆、书院的等级受限于议事堂的等级。\n" + 
					"　　议事堂20级时可加入势力，30级可以创建势力。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 民居提示信息 
		 * @return 
		 * 
		 */		
		public static function getRoomInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　民居是坞堡内居民居住之所，升级民居可提高居住上限。农田等资源产地和工坊的等级也受限于民居的等级。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 矿山提示信息 
		 * @return 
		 * 
		 */		
		public static function getMineInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　矿山生产的资源是矿石，每月月初交纳。升级矿山可提升矿石产量。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 伐木场提示信息 
		 * @return 
		 * 
		 */		
		public static function getWoodInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　伐木场生产的资源是木料，每月月初交纳。升级伐木场可提升木料产量。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 革坊提示信息 
		 * @return 
		 * 
		 */		
		public static function getSkinInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　革坊生产的资源是皮革，每月月初交纳。升级革坊可提升皮革产量。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 牧场提示信息 
		 * @return 
		 * 
		 */		
		public static function getRanchInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　牧场生产的资源是马匹，每月月初交纳。升级牧场可提升马匹产量。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 集市提示信息 
		 * @return 
		 * 
		 */		
		public static function getMarketInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　集市生产的资源是钱币，每月月初交纳。升级集市可提升钱币产量。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 农田提示信息 
		 * @return 
		 * 
		 */		
		public static function getFarmInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　农田生产的资源是粮食，每年九月初交纳。升级农田可提升粮食产量。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 医馆提示信息 
		 * @return 
		 * 
		 */		
		public static function getHospitalInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　医馆可治疗战斗中受伤的士卒，升级医馆可提升每日治疗量。治疗量每日自动恢复。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 军营提示信息 
		 * @return 
		 * 
		 */		
		public static function getCampInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　军营自动募集步卒，升级军营可提升步卒募集上限。并且可以提升武将的训练经验值。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 强化提示信息 
		 * @return 
		 * 
		 */		
		public static function getComposeInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　武器装备每强化一次可提升基础值100%的效能，最高可强化至10星装备。强化等级上限由相应的装备强化技术等级决定。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 科技提示信息 
		 * @return 
		 * 
		 */		
		public static function getTechInfo(tech:Tech):String
		{
			var info:String = "";
			var type:int = 0;
			var ret:String = "";
			
			type = tech.type;
			
			if (type == 1)
				info = "研究铸剑可提升剑的强化等级上限。";
			else if (type == 2)
				info = "研究制戟可提升戟的强化等级上限。";
			else if (type == 3)
				info = "研究机括可提升弩的强化等级上限。";
			else if (type == 4)
				info = "研究制盾可提升盾的强化等级上限。";
			else if (type == 5)
				info = "研究鞣皮可提升皮甲的强化等级上限。";
			else if (type == 6)
				info = "研究浇铸可提升铁甲的强化等级上限。";
			else if (type == 7)
				info = "研究木工可提升甲车的强化等级上限。";
			else if (type == 8)
				info = "研究机械可提升弩车的强化等级上限。";
			else if (type == 9)
				info = "研究驯马可提升战马的强化等级上限。";
			else if (type == 10)
				info = "每研究一级种植可提升农田的产量5%。";
			else if (type == 11)
				info = "每研究一级伐木可提升伐木场的产量5%。";
			else if (type == 12)
				info = "每研究一级采矿可提升矿山的产量5%。";
			else if (type == 13)
				info = "每研究一级放牧可提升牧场的产量5%。";
			else if (type == 14)
				info = "每研究一级制革可提升革坊的产量5%。";
			else if (type == 15)
				info = "每研究一级贸易可提升集市的产量5%。";
				
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 

		/**
		 * 武将部曲提示信息 
		 * @return 
		 * 
		 */		
		public static function getSoliderInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　武将所率部曲的战斗力和健卒数量、装备、训练、士气相关。伤兵可在医馆通过治疗恢复。\n" + 
					"　　装备有盾的部队在受到弓弩攻击的时候，所受伤害减半；但受到戟兵攻击时，" + 
					"受伤害加倍；装备戟的部队能够对剑盾兵造成双倍的攻击；但在受弓弩攻击时，受到的伤害加倍。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		} 
		
		/**
		 * 系统交易提示信息 
		 * @return 
		 * 
		 */		
		public static function getDealSys():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　交易系统支持3种交易模式。玩家在卫氏商行进行资源交易没有任何限制，但资源的卖出价格较为低廉，仅为买入价的50%。\n" + 
					"　　如果不想承受卖出价格损失，可通过交易所与玩家交易资源。\n" + 
					"　　玩家的闲置武器装备或者资源均可在自由市场发布最多5条售卖信息。\n" + 
					"　　玩家可在交易所发布最多5笔单位为100倍数的资源交易，同时可在交易厅得知当前的5种资源最高的5笔买入单价和最低的5笔卖出单价。\n" + 
					"　　只要玩家的卖出交易单价低于买入交易的最高单价，或者玩家发布的买入单价高于最低的卖出单价，即可立即成交，成交价以先出价者为准。\n" + 
					"　　交易单有效时间为游戏时间1年，玩家随时可查看自己的交易单成交状况，也可随时撤销未完成的交易单。";
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 剿匪兵种选择信息 
		 * @return 
		 * 
		 */		
		public static function getXiuLian():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　剿匪可供选择出阵的兵种有4种，其中弩兵和弩骑兵为远程攻击（可攻击对角和间距1格的敌军），如果所攻击的敌军是近战型部队，则不受反击。\n" + 
					"　　选择合适的兵种可得到武将技能的增益作用，从而提升部队的攻击力。需要注意的是某些阵型是专用的，" + 
					"如选择弩兵，则骑兵、步兵、弓骑所专用的锥形阵、鱼鳞阵和雁行阵将无法使用。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 武将忠诚度提示信息 
		 * @return 
		 * 
		 */		
		public static function getFaith():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　玩家如果无法支付武将俸禄，将会导致忠诚度降低5点。当武将的忠诚度降低至0时，武将会自动离去。\n　　如果武将忠诚度过低，可在商城购买宝物【千金】或【百金】赐予该武将，即可恢复其忠诚度。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 武将等级提示信息 
		 * @return 
		 * 
		 */		
		public static function getTrain():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "武将等级\n等级越高，则战斗力越强。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 武将士气提示信息 
		 * @return 
		 * 
		 */		
		public static function getSpirit():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "士气越高，【无双】【破阵】等特殊技能的爆发概率越高。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将学习提示信息 
		 * @return 
		 * 
		 */		
		public static function getStudyInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　武将技能中增加20%、40%、60%效果的技能只有效果较高的技能可以发生作用。如果已经学习高级的技能，则无需再学习低级技能造成功勋的浪费。\n提示：学习技能或阵法后，如收回宝物导致武将属性不足，已学习技能或阵法将失去效果。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将训练提示信息 
		 * @return 
		 * 
		 */		
		public static function getTrainInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　武将可通过训练提升等级，武将等级越高，战斗力越强。随着武将等级的增加，每次升级所需的经验也越多。\n提示：军营等级越高，每次训练得到的经验越多。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将攻击提示信息 
		 * @return 
		 * 
		 */		
		public static function getAttackInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "攻击力主要受士兵装备、武将等级、兵种技能以及阵型的影响。在战斗中每次攻击所能造成的伤害还与部曲中的健卒数量有关。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将防御提示信息 
		 * @return 
		 * 
		 */		
		public static function getDefenseInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "防御力主要受士兵装备、武将等级、兵种技能以及阵型的影响。防御越高，战斗中敌方的攻击造成的伤害越少。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将机动提示信息 
		 * @return 
		 * 
		 */		
		public static function getSpeedInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "机动力主要受士兵装备、武将坐骑以及阵型的影响。在战斗中，如果己方的机动低于敌方，则己方对敌方的伤害将减少20%。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将武力提示信息 
		 * @return 
		 * 
		 */		
		public static function getKongfuInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "武将的武力属性越高，在攻击力上的增益越高！武力属性还影响骑兵技能和骑射技能的学习，同时也会对甲车技能和某些阵法的学习造成影响。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将智力提示信息 
		 * @return 
		 * 
		 */		
		public static function getInteInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "武将的智力属性越高，在防御力上的增益越高！智力属性还影响弩兵技能和弩车技能的学习，同时也会对骑射技能和某些阵法的学习造成影响。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将政治提示信息 
		 * @return 
		 * 
		 */		
		public static function getPolityInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "武将的政治属性越高，在机动力上的增益越高！政治属性还影响步兵技能和甲车技能的学习，同时也会对弩车技能和某些阵法的学习造成影响。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		/**
		 * 获取武将宝物提示信息 
		 * @return 
		 * 
		 */		
		public static function getTreasureInfo():String
		{
			var info:String = "";
			var ret:String = "";
			
			info = "　　赐予武将宝物可增加武将的属性值以获得更高的攻防增益，并且可以学习属性要求更高的技能！如果武将的属性值低于50，将会在一定程度上削弱该属性对应的攻防或机动。\n" + 
					"提示：如果在学习后收回宝物导致属性值达不到技能要求，则该技能将会暂时失效。";
					
			ret = FormatText.packegText(info, FormatText.WHITE); 
			
			return ret;
		}
		
		
	}
}