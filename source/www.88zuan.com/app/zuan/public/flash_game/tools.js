var g_head_func = null;
var g_body_func = null;
var g_total_url = null;
var g_query_url = null;
var g_page_total = 0;
var g_cond = '';

function safevar(t)
{
	if (t) {
		return t;
	}
	else {
		return "none";
	}
}

function safeint(t)
{
	if (t) {
		return t;
	}
	else {
		return "0";
	}
}

function strftime(t)
{
	if (!t) {
		return "";
	}
	var d = new Date(parseInt(t) * 1000);
    return d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
}

function _write_table_body(page, limit)
{

	$.ajax({
	   'url': g_query_url, 
	   'cache': false,
	   'dataType': "json",
	   'data': {'page':page, 'limit':limit, 'cond': g_cond},
	   'success': function(data) {
			$("#data_table").html("");
			if (g_head_func) {
				g_head_func();
			}
	
			if (g_body_func) {
				g_body_func(data);
			}
		   }
	   });
	
}

function _get_page_total()
{
	var limit = parseInt($("#limit").val());
	
	$.ajax({
		   'url': g_total_url, 
		   'dataType': "json",
		   'cache': false,
		   'data': {'cond': g_cond},
		   'success': function(data) {
			   	g_page_total = Math.round((parseInt(data) / limit)) + 1;
				$("#pages").html("Total " + data + ", Page " + g_page_total);
				$("#hidden_page_total").html(g_page_total);
				_write_table();
			   }
		   });
	
}
function _write_table()
{
	var limit = $("#limit").val();
	var page = parseInt($("#page_no").val()) - 1;
    var total = parseInt($("#hidden_page_total").html());
	if (page < 0) {
		page = 0;
	}
	if (page > total) {
		page = total;
	}
	_write_table_body(page, limit);
}

function flash_game_pager(head_func, body_func, total_url, query_url) 
{
	g_head_func = head_func;
	g_body_func = body_func;
	g_total_url = total_url;
	g_query_url = query_url;

	_get_page_total();
	
	$("#limit").change(function(){
		_write_table();
	});
	
	$("#go").click(function() {
		_write_table();
	});
	
	$("#next_page").click(function() {
		var cur_page = parseInt($("#page_no").val());
		var total_page = parseInt($("#hidden_page_total").html());
		if (cur_page >= total_page){
			return;
		}
		$("#page_no").val(cur_page + 1);
		_write_table();
	});
	
	$("#pre_page").click(function() {
		var cur_page = parseInt($("#page_no").val());
		if (cur_page <= 1){
			return;
		}
		$("#page_no").val(cur_page - 1);
		_write_table();
	});
	
	$("#first_page").click(function() {
		$("#page_no").val(1);
		_write_table();
	});
	
	$("#last_page").click(function() {
		var total_page = parseInt($("#hidden_page_total").html());
		$("#page_no").val(total_page);
		_write_table();
	});	
}

function flash_game_pager1(head_func, body_func, total_url, query_url, cond)
{
	g_cond = cond;
	pager(head_func, body_func, total_url, query_url);
}
