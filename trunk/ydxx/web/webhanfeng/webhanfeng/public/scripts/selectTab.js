// JavaScript Document
function selectTab(src_url){
	$(document).ready(function() {
		$("#content").load(src_url);
	});	
	
}

function selectTab2(src_url){
	$(document).ready(function() {
		$("#game-ad-index-right").load(src_url);
	});	
	
}

function changeserver(){
	var server_id = document.getElementById("server_id");
	var server_url = document.getElementById("server_url");
	var all_tr = server_url.getElementsByTagName("tr");
	for(var i = 0; i < all_tr.length; i++){
		all_tr[i].style.display = "none";
	}
	var flex_server = document.getElementById("flex" + server_id.value);
	var socket_server = document.getElementById("socket" + server_id.value);
	flex_server.style.display = "";
	socket_server.style.display = "";
}