package wubao.model
{
	import flash.display.Bitmap;
	
	import images.AssetsManager;
	
	import utils.PubUnit;
	
	/**
	 * 坞堡科技
	 * @author bxl
	 * 
	 */	
	public class Tech
	{
		private var _uniqID:int = 0;
		
		//类型
		//1，铸剑；2，制戟；3，机括；4，制盾；5，鞣皮；6，浇铸；7，木工；8，机械；9，驯马；10，种植；11，伐木；12，采矿；13，放牧；14，制革；15，贸易；
		private var _type:int = 0;
		
		//名称
		private var _name:String = "";
		
		//等级
		private var _level:int = 0;
		
		//升级结束时间戳
		private var _endTime:int = 0;

		//科技图片
		private var _imgBmp:Class;

		public function Tech()
		{
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
			_name = PubUnit.techList[type];
			
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

		public function get endTime():int
		{
			return _endTime;
		}
		
		public function set endTime(param:int):void
		{
			_endTime = param;
		}

		public function get imgBmp():Class
		{
			var imgClass:Class;
			switch (type)
			{
				case 1:
				{
					imgClass = AssetsManager.assetsMgr.TECH_ZHUJIAN;
					break;
				}
				
				case 2:
				{
					imgClass = AssetsManager.assetsMgr.TECH_ZHIJI;
					break;
				}
				
				case 3:
				{
					imgClass = AssetsManager.assetsMgr.TECH_JIKUO;
					break;
				}
				
				case 4:
				{
					imgClass = AssetsManager.assetsMgr.TECH_ZHIDUN;
					break;
				}
				
				case 5:
				{
					imgClass = AssetsManager.assetsMgr.TECH_ROUPI;
					break;
				}
				
				case 6:
				{
					imgClass = AssetsManager.assetsMgr.TECH_JIAOZHU;
					break;
				}
				
				case 7:
				{
					imgClass = AssetsManager.assetsMgr.TECH_MUGONG;
					break;
				}
				
				case 8:
				{
					imgClass = AssetsManager.assetsMgr.TECH_JIXIE;
					break;
				}
				
				case 9:
				{
					imgClass = AssetsManager.assetsMgr.TECH_XUNMA;
					break;
				}
				
				case 10:
				{
					imgClass = AssetsManager.assetsMgr.TECH_ZHONGZHI;
					break;
				}
				
				case 11:
				{
					imgClass = AssetsManager.assetsMgr.TECH_FAMU;
					break;
				}
				
				case 12:
				{
					imgClass = AssetsManager.assetsMgr.TECH_CAIKUANG;
					break;
				}
				
				case 13:
				{
					imgClass = AssetsManager.assetsMgr.TECH_FANGMU;
					break;
				}
				
				case 14:
				{
					imgClass = AssetsManager.assetsMgr.TECH_ZHIGE;
					break;
				}
				
				case 15:
				{
					imgClass = AssetsManager.assetsMgr.TECH_MAOYI;
					break;
				}
			}
			return imgClass;
		}
		
		public function set imgBmp(param:Class):void
		{
			_imgBmp = param;
		}

	}
}