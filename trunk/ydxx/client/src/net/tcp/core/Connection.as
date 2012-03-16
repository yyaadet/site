package net.tcp.core
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import net.tcp.events.TcpErrEvent;
	import net.tcp.events.TcpReqEvent;
	import net.tcp.events.TcpSucEvent;
	
	public class Connection extends EventDispatcher 
	{
		private var m_socket:Socket;
		private var m_remote_ip:String = "";
		private var m_remote_port : int = 0;
		private var m_security_ip:String = "";
		private var m_security_port : int = 0;
		
		//buffer 
		private var m_inbuf:ByteArray = new ByteArray();
		private var m_outbuf:ByteArray = new ByteArray();
		
		//input request message list
		public var m_input_req_list:Array = new Array();
		
		private var isConnectSec:Boolean = false;
		
		/**
		 *  
		 * @param serverIP
		 * @param port
		 * @param securityip
		 * @param securityport
		 * 
		 */		
		public function Connection(serverIP:String, port:int, securityip:String , securityport:int)
		{
            m_socket = new Socket();
            m_socket.endian = Endian.BIG_ENDIAN ;
            
            m_remote_ip = serverIP;
            m_remote_port = port;
            m_security_ip = securityip;
            m_security_port = securityport;
            
            m_inbuf.endian = Endian.BIG_ENDIAN;
            
		}  
		
		public function connect(): Boolean
		{
        	try
        	{
        		if (!isConnectSec)
					Security.loadPolicyFile("xmlsocket://" + m_security_ip + ":" + m_security_port.toString());
				isConnectSec = true;
	  			m_socket.connect(m_remote_ip, m_remote_port);
	  			addAllEventListener();
	  			
   				return true;
			}
			catch(ex:ErrorEvent)
			{
				return false;
			} 	
			return false;
        }
        
        public function close():void
        {
        	if (m_socket.connected)
        		m_socket.close();
        }
        
        public function isConnected():Boolean
        {
        	return m_socket.connected;
        }
        
        private function addAllEventListener():void
        {
        	if (m_socket == null) return;
        	
        	if (!m_socket.hasEventListener(Event.CONNECT))
  				m_socket.addEventListener(Event.CONNECT, connectHandler);
  				
        	if (!m_socket.hasEventListener(Event.CLOSE))
	  			m_socket.addEventListener(Event.CLOSE, closeHandler);
	  			
        	if (!m_socket.hasEventListener(IOErrorEvent.IO_ERROR))
	   			m_socket.addEventListener(IOErrorEvent.IO_ERROR, error_event_handle);
	   			
        	if (!m_socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
	   			m_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error_event_handle);
	   			
        	if (!m_socket.hasEventListener(ProgressEvent.SOCKET_DATA))
	   			m_socket.addEventListener(ProgressEvent.SOCKET_DATA,  data_event_handle);
        }
        
        private function removeAllEventListener():void
        {
        	if (m_socket == null) return;
        	
        	if (m_socket.hasEventListener(Event.CONNECT))
  				m_socket.removeEventListener(Event.CONNECT, connectHandler);
  				
        	if (m_socket.hasEventListener(Event.CLOSE))
	  			m_socket.removeEventListener(Event.CLOSE, closeHandler);
	  			
        	if (m_socket.hasEventListener(IOErrorEvent.IO_ERROR))
	   			m_socket.removeEventListener(IOErrorEvent.IO_ERROR, error_event_handle);
	   			
        	if (m_socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
	   			m_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error_event_handle);
	   			
        	if (m_socket.hasEventListener(ProgressEvent.SOCKET_DATA))
	   			m_socket.removeEventListener(ProgressEvent.SOCKET_DATA,  data_event_handle);
        }
        
        private function error_event_handle(evt:Event) :void
        {
        	close();
       		removeAllEventListener();
       		//派发错误事件，通知外面tcp连接错误
       		var errorEvent:TcpErrEvent = new TcpErrEvent(TcpErrEvent.ERROR);
       		
       		errorEvent.errorInfo = evt.type.toString();
       		
       		dispatchEvent(errorEvent);
        }
        
        private function closeHandler(evt:Event):void
        {
        	close();
        	removeAllEventListener();
        	
       		//派发错误事件，通知外面tcp连接错误
       		var errorEvent:TcpErrEvent = new TcpErrEvent(TcpErrEvent.ERROR);
       		
       		errorEvent.errorInfo = evt.type.toString();
       		
       		dispatchEvent(errorEvent);
        }
		
        private function connectHandler(evt:Event):void
        {
        	if(m_socket.connected == true)
        	{
	       		//派发成功，通知外面tcp连接成功
	       		dispatchEvent(new TcpSucEvent(TcpSucEvent.SUCCESS));
        	}
        	else
        	{
	       		//派发错误事件，通知外面tcp连接错误
	       		dispatchEvent(new TcpErrEvent(TcpErrEvent.ERROR));
        	}
        }
        
        //cb type is void (Connection , Response , Object)
        public function write(out:ByteArray):Boolean
        {
        	try
        	{
        		m_socket.writeBytes(out, 0, out.length);
  				m_socket.flush();
  				  				
  				return true;
        	} catch (evt:Error)
        	{
        		return false;
        	}
        	
        	return false;
        }    
        
        public function write_request(req:Request):Boolean
        {
        	var out:ByteArray = req.pack();
        	var res:Boolean = this.write(out);
        	
        	return res;
        }    
        
        private function data_event_handle(eve:Event):void
        {
        	var len:uint = 0;
        	var offset:uint = 0;
        	
        	while ((len = m_socket.bytesAvailable) > 0)
        	{
 				m_socket.readBytes(m_inbuf, m_inbuf.length, len);
        	}
        	
        	//parse inbuf
        	m_inbuf.position = 0;
        	while(m_inbuf.length - offset >= 16)
        	{
				var total:uint = m_inbuf.readUnsignedInt();
				var type:uint = m_inbuf.readUnsignedInt();
				var send_id:uint = m_inbuf.readUnsignedInt();
				var message_id:uint = m_inbuf.readUnsignedInt();
				var body:ByteArray = new ByteArray();
				var body_size:uint = 0;
				var req:Request = null;
				var left:int = 0;
				
				if (total > m_inbuf.length)
					break;
					
				left = m_inbuf.length - offset - 16;	
				body_size = total - 16;
				if (body_size > 0 && body_size > left)
					break;
					
				//receive full request message
				if (body_size > 0)
					m_inbuf.readBytes(body, 0, total - 16);
					
				req = new Request(type, send_id, message_id, body);
				
				m_input_req_list.push(req);
				offset += total;
			}
			
			if (offset > 0) 
			{
				var newbuf:ByteArray = new ByteArray();
				
				newbuf.position = 0;
				newbuf.endian = Endian.BIG_ENDIAN;
				
				newbuf.writeBytes(m_inbuf, offset, m_inbuf.length - offset);
				m_inbuf = newbuf;
			}
        	
        	//消息事件
        	var reqEvent:TcpReqEvent = new TcpReqEvent(TcpReqEvent.RECEIVE);
        	reqEvent.reqList = m_input_req_list;
        	
        	//派发获取消息包事件，通知外面有新的消息
        	dispatchEvent(reqEvent);
        }  
        
        private function onTimer(event:TimerEvent):void
        {
 			connect();
		}    
	}
}