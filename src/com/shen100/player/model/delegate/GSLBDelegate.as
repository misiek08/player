package com.shen100.player.model.delegate {
	
	import com.shen100.core.net.HttpService;
	
	public class GSLBDelegate {
		
		private var httpService:HttpService;
		private var _result:Function;
		private var _fault:Function;
		
		public function GSLBDelegate() {
			httpService = new HttpService();
			httpService.addResponder(result, fault);
		}
		
		public function addResponder(result:Function, fault:Function):void {
			_result = result;
			_fault = fault;
			
		}
		
		public function send(url:String):void {
			httpService.send(url);	
		}
		
		private function result(data:Object):void {
				
		}
		
		private function fault(info:Object):void {
		
		}
		
	}
}