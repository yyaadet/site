package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import task.list.TaskList;
	import task.model.Task;
	
	import utils.GameManager;
	
	/**
	 * Http获取任务列表信息 
	 * @author StarX
	 * 
	 */	
	public class HttpTask extends HttpBase
	{
		//定义任务信息列表类
		private var taskList:TaskList = new TaskList();
		
		public function HttpTask()
		{
			super();
		}
		
		public function getInfo():void
		{
			//设置httpService的web访问路径
			httpService.url = HttpURL.GET_TASK;
			
			//发送请求 
			httpService.send(urlVariables);
		}
		
		override protected function onGetInfo(evt:ResultEvent):void
		{
			var resultXML:XML = XML(evt.result);
			var i:int = 0;
			var count:int = 0;
			
			if (resultXML == "" || resultXML == null)
			{
				dispatchErrorEvent("返回的xml数据为空");
				return;
			}
			
			try
			{
				//判断xml文件是否存在节点 "task"
				if (resultXML.hasOwnProperty("task"))
				{
					count = resultXML.child("task").length();
					
					if (count < 1)
					{
						dispatchErrorEvent("任务数目为0");
						return;
					}
				}
				
				//将返回的xml数据放入数组中
				for(i = 0; i < count; i++)
				{
					var gameTask:Task = new Task();
					
					if (resultXML.task[i].hasOwnProperty("id"))
						gameTask.uniqID = int(resultXML.task[i].id);
						
					if (resultXML.task[i].hasOwnProperty("before_id"))
						gameTask.beforeID = int(resultXML.task[i].before_id);
						
					if (resultXML.task[i].hasOwnProperty("type"))
						gameTask.type = int(resultXML.task[i].type);
						
					if (resultXML.task[i].hasOwnProperty("num1"))
						gameTask.value1 = int(resultXML.task[i].num1);
						
					if (resultXML.task[i].hasOwnProperty("num2"))
						gameTask.value2 = int(resultXML.task[i].num2);
						
					if (resultXML.task[i].hasOwnProperty("num3"))
						gameTask.value3 = int(resultXML.task[i].num3);
						
					if (resultXML.task[i].hasOwnProperty("prestige"))
						gameTask.bonus.push(int(resultXML.task[i].prestige));
						
					if (resultXML.task[i].hasOwnProperty("res1"))
						gameTask.bonus.push(int(resultXML.task[i].res1));
						
					if (resultXML.task[i].hasOwnProperty("res2"))
						gameTask.bonus.push(int(resultXML.task[i].res2));
						
					if (resultXML.task[i].hasOwnProperty("res3"))
						gameTask.bonus.push(int(resultXML.task[i].res3));
						
					if (resultXML.task[i].hasOwnProperty("res4"))
						gameTask.bonus.push(int(resultXML.task[i].res4));
						
					if (resultXML.task[i].hasOwnProperty("res5"))
						gameTask.bonus.push(int(resultXML.task[i].res5));
						
					if (resultXML.task[i].hasOwnProperty("res6"))
						gameTask.bonus.push(int(resultXML.task[i].res6));
						
					if (resultXML.task[i].hasOwnProperty("gold"))
						gameTask.bonus.push(int(resultXML.task[i].gold));
						
					if (resultXML.task[i].hasOwnProperty("tre1"))
						gameTask.bonus.push(int(resultXML.task[i].tre1));
						
					if (resultXML.task[i].hasOwnProperty("solider"))
						gameTask.bonus.push(int(resultXML.task[i].solider));
						
					if (resultXML.task[i].hasOwnProperty("title"))
						gameTask.title = resultXML.task[i].title;
						
					if (resultXML.task[i].hasOwnProperty("info"))
						gameTask.info = resultXML.task[i].info;
						
					if (resultXML.task[i].hasOwnProperty("guide"))
						gameTask.guid = resultXML.task[i].guide;
						
					if (resultXML.task[i].hasOwnProperty("target"))
						gameTask.target = resultXML.task[i].target;
						
					taskList.add(gameTask);
				}
				
				GameManager.gameMgr.taskList = taskList;
				taskList.getBeginLen();
				
			}
			catch(evt:ErrorEvent)
			{
				dispatchErrorEvent("解析xml数据有误");
				return;
			}
			
			//派发道具列表事件，通知外面信息获取成功
			var e:HttpSucEvent = new HttpSucEvent(HttpSucEvent.SUCCESS);
			dispatchEvent(e);
			
			removeAllEventListener();
		}

	}
}