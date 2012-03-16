package shop.model
{
	import utils.FormatText;
	import utils.PubUnit;
	
	/**
	 * 商店中卖的道具 
	 * @author StarX
	 * 
	 */	
	[Bindable]
	public class Treasure
	{
		//道具ID
		private var _uniqID:int = 0;
		
		//道具名称
		private var _name:String = "";

		//道具图片地址
		private var _url:String = "";

		//道具大图片地址
		private var _bigUrl:String = "";

		//道具级别
		private var _level:int = 0;

		//道具类型 1：武力，2：智力，3：政治，4：速度，5：友好度，6：VIP，7：忠诚度，8：招贤榜，9：功勋卡
		private var _type:int = 0;
		
		//道具类型名称
		private var _typeName:String = "";
		
		//属性增加值
		private var _propNum:int = 0;
		
		//效果，如+12武力
		private var _effect:String = "";
		
		//道具单价
		private var _price:int = 0;
		
		//道具总价
		private var _totalPrice:int = 0;
		
		//购买数量
		private var _buyNum:int = 1;

		//宝物说明
		private var _description:String = "";
		
		//购买宝物时说明
		private var _buyDes:String = "";
		
		public function clone():Treasure
		{
			var treasure:Treasure = new Treasure();
			
			treasure.uniqID = this.uniqID;
			treasure.name = this.name;
			treasure.url = this.url;
			treasure.level = this.level;
			treasure.type = this.type;
			treasure.propNum = this.propNum;
			treasure.effect = this.effect;
			treasure.price = this.price;
			treasure.description = this.description;
			
			return treasure;
		}
		
		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set name(param:String):void
		{
			this._name = param;
		}

		public function get name():String
		{
			return this._name;
		}

		public function set url(param:String):void
		{
			this._url = param;
		}

		public function get url(): String
		{
			return this._url;
		}

		public function set bigUrl(param:String):void
		{
			this._bigUrl = param;
		}

		public function get bigUrl(): String
		{
			return this._bigUrl;
		}

		public function set type(param:int):void
		{
			this._type = param;
		}

		public function get type():int
		{
			return this._type;
		}

		public function get typeName():String
		{
			_typeName = PubUnit.tsList[type];
			
			return this._typeName;
		}
		
		public function set typeName(param:String):void
		{
			this._typeName = param;
		}
		
		public function set level(param:int):void
		{
			this._level = param;
		}

		public function get level():int
		{
			return this._level;
		}

		public function set propNum(param:int):void
		{
			this._propNum = param;
		}

		public function get propNum():int
		{
			return this._propNum;
		}

		public function set effect(param:String):void
		{
			this._effect = param;
		}

		public function get effect():String
		{
			_effect = "+" + propNum + PubUnit.tsPropList[type];
			
			return this._effect;
		}

		public function set description(param:String):void
		{
			this._description = param;
		}

		public function get description():String
		{
			return this._description;
		}

		public function set buyDes(param:String):void
		{
			this._buyDes = param;
		}

		public function get buyDes():String
		{
			_buyDes = FormatText.packegText(effect, FormatText.YELLOW, "12", "宋体") + "\n" +
		 		      "所需金币：" + FormatText.packegText(price.toString(), FormatText.YELLOW, "12", "宋体"); 
		              
			return this._buyDes;
		}

		public function get price():int
		{
			return _price;
		}
		
		public function set price(param:int):void
		{
			this._price = param;
		}
		
		public function get totalPrice():int
		{
			_totalPrice = price * buyNum;
			return _totalPrice;
		}
		
		public function set totalPrice(param:int):void
		{
			this._totalPrice = param;
		}
		
		public function get buyNum():int
		{
			return _buyNum;
		}
		
		public function set buyNum(param:int):void
		{
			this._buyNum = param;
		}
		
	}
}