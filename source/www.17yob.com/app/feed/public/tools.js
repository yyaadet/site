var g_head_func = null;
var g_body_func = null;
var g_total_url = null;
var g_query_url = null;
var g_page_total = 0;
var g_cond = '';
var g_is_full = 0;


function addBookmark(title,url) {
	if(!title){title =document.title};
	if(!url){url=window.location.href}
	if (window.sidebar) {
	window.sidebar.addPanel(title,url ,"");
	} else if( document.all ) {
	window.external.AddFavorite(url,title);
	} else if( window.opera && window.print ) {
	return true;
	}
}

function fmt_file_size(sz)
{
	if (sz > 1024) {
		return (sz/1024) + "K";
	}
	if (sz > 1024 * 1024) {
		return (sz / (1024 * 1024)) + "M";
	}
	return sz;
}

function del_html_tag(str) 
{ 
  	return str.replace(/<[^>]+>/g,"");
}

function short_str(t, len)
{
	var n = "";
	t = del_html_tag(t);
	if (t.length > len) {
		n = t.substr(0, len) + "...";
		return n;
	}
	
	return t
}

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
    return d.toLocaleDateString() + " " + d.toLocaleTimeString();
}

function is_man(sex)
{
	if (sex == 1) {
		return 1;
	}
	else {
		return 0;
	}
}

function is_confirm()
{
	var code = window.confirm("您确定要删除吗？");
	if (code == true) {
		return true;
	}
	else {
		return false;
	}
}