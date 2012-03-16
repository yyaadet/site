package wubao.model
{
	import flash.display.Bitmap;
	
	import images.AssetsManager;
	
	import utils.FormatText;
	import utils.PubUnit;
	
	/**
	 * 士兵装备 
	 * 1，剑；2，戟；3，弩；4，盾；5，皮甲；6，铁甲；7，甲车；8，弩车；9，战马； 10"百炼刀", 11"点钢枪", 12"神臂弩", 13"虎纹盾", 14"鱼鳞甲", 15"乌孙马"
	 * @author bxl
	 * 
	 */	
	public class Weapon
	{
		public static const JIAN:int = 1;
		
		public static const JI:int = JIAN + 1;
		
		public static const NU:int = JI + 1;
		
		public static const DUN:int = NU + 1;
		
		public static const PI:int = DUN + 1;
		
		public static const TIE:int = PI + 1;
		
		public static const JIACHE:int = TIE + 1;
		
		public static const NUCHE:int = JIACHE + 1;
		
		public static const MA:int = NUCHE + 1;
		
		public static const DAO:int = MA + 1;
		
		public static const QIANG:int = DAO + 1;
		
		public static const SHENBI:int = QIANG + 1;
		
		public static const HUWEN:int = SHENBI + 1;
		
		public static const YULIN:int = HUWEN + 1;
		
		public static const WUSUN:int = YULIN + 1;
		
		//唯一ID
		private var _uniqID:int = 0;
		
		//类型
		private var _type:int = 0;
		
		//名称
		private var _name:String = "";
		
		//等级
		private var _level:int = 0;
		
		//等级名称，如：1星 剑
		private var _levelName:String = "";
		
		//提示信息
		private var _tip:String = "";
		
		//数量
		private var _num:int = 0;
		
		//装备图片
		private var _imgBmp:Bitmap = null;

		public function Weapon()
		{
			
		}
		
		public var equal:Function = function (source:Weapon):Boolean
		{
			if (source == null) return false;
			
			if (source.type == type && source.level == level)
				return true
			
			return false;
		}
		
		public static function getSmallImg(wType:int):Class
		{
			var imgClass:Class;

			switch (wType)
			{
				case JIAN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SWORD_S;
					break;
				}
				
				case JI:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HALBERD_S;
					break;
				}
				
				case NU:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HNAID_S;
					break;
				}
				
				case DUN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SHIELD_S;
					break;
				}
				
				case PI:
				{
					imgClass = AssetsManager.assetsMgr.WPN_LEATHER_S;
					break;
				}
				
				case TIE:
				{
					imgClass = AssetsManager.assetsMgr.WPN_ARMOUR_S;
					break;
				}
				
				case JIACHE:
				{
					imgClass = AssetsManager.assetsMgr.WPN_BLOWING_S;
					break;
				}
				
				case NUCHE:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SHIP_S;
					break;
				}
				
				case MA:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HORSE_S;
					break;
				}
				
				case DAO:
				{
					imgClass = AssetsManager.assetsMgr.WPN_DAO_S;
					break;
				}
				
				case QIANG:
				{
					imgClass = AssetsManager.assetsMgr.WPN_QIANG_S;
					break;
				}
				
				case SHENBI:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SHENBI_S;
					break;
				}
				
				case HUWEN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HUWEN_S;
					break;
				}
				
				case YULIN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_YULIN_S;
					break;
				}
				
				case WUSUN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_WUSUN_S;
					break;
				}
				
			}
			
			return imgClass;
		}

		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}

		public function get name():String
		{
			_name = PubUnit.weaponList[type];
			
			return _name;
		}
		
		public function set name(param:String):void
		{
			_name = param;
		}

		public function get level():int
		{
			return _level;
		}
		
		public function set level(param:int):void
		{
			_level = param;
		}

		public function get levelName():String
		{
			_levelName = level.toString() + PubUnit.wpLevelUnit + name; 
			
			return _levelName;
		}
		
		public function set levelName(param:String):void
		{
			_levelName = param;
		}

		public function get tip():String
		{
			var ary:Array = PubUnit.getWeaponProp(type, level);
			
			_tip = FormatText.packegText(name) + "\n";
			if (type == JIAN || type == DUN || type == DAO || type == HUWEN)
				_tip += FormatText.packegText("单手使用") + "\n";
			else if (type == JI || type == NU || type == QIANG || type == SHENBI)
				_tip += FormatText.packegText("双手使用") + "\n";
			
			_tip += FormatText.packegText("等级 ") + FormatText.packegText(level.toString(), FormatText.GREEN) + "\n" + 
			        FormatText.packegText("攻击 ") + FormatText.packegText(ary[0].toString(), FormatText.GREEN) + "\n" + 
			        FormatText.packegText("防御 ") + FormatText.packegText(ary[1].toString(), FormatText.GREEN) + "\n" +
			        FormatText.packegText("机动 ") + FormatText.packegText(ary[2].toString(), FormatText.GREEN);
			
			return _tip;
		}
		
		public function set tip(param:String):void
		{
			_tip = param;
		}

		public function get num():int
		{
			return _num;
		}
		
		public function set num(param:int):void
		{
			_num = param;
		}

		public function get imgBmp():Bitmap
		{
			var imgClass:Class;
			switch (type)
			{
				case JIAN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SWORD;
					break;
				}
				
				case JI:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HALBERD;
					break;
				}
				
				case NU:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HNAID;
					break;
				}
				
				case DUN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SHIELD;
					break;
				}
				
				case PI:
				{
					imgClass = AssetsManager.assetsMgr.WPN_LEATHER;
					break;
				}
				
				case TIE:
				{
					imgClass = AssetsManager.assetsMgr.WPN_ARMOUR;
					break;
				}
				
				case JIACHE:
				{
					imgClass = AssetsManager.assetsMgr.WPN_BLOWING;
					break;
				}
				
				case NUCHE:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SHIP;
					break;
				}
				
				case MA:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HORSE;
					break;
				}
				
				case DAO:
				{
					imgClass = AssetsManager.assetsMgr.WPN_DAO;
					break;
				}
				
				case QIANG:
				{
					imgClass = AssetsManager.assetsMgr.WPN_QIANG;
					break;
				}
				
				case SHENBI:
				{
					imgClass = AssetsManager.assetsMgr.WPN_SHENBI;
					break;
				}
				
				case HUWEN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_HUWEN;
					break;
				}
				
				case YULIN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_YULIN;
					break;
				}
				
				case WUSUN:
				{
					imgClass = AssetsManager.assetsMgr.WPN_WUSUN;
					break;
				}
				
			}
			
			_imgBmp = new imgClass();
			return _imgBmp;
		}
		
		public function set imgBmp(param:Bitmap):void
		{
			_imgBmp = param;
		}
		
	}
}