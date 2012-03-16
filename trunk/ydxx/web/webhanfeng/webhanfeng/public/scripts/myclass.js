function myclass(){
/*	
$.ajax({
    url: '/admin/add_class?action=data',        
    type: 'GET',                
    success: function(msg){      //正常返回时执行的方法
        alert('a');
        alert(msg);
    }
});
*/
selectClass = document.getElementById('select0');
selectClass1 = document.getElementById('select1');
selectClass2 = document.getElementById('select2');
values = selectClass.value;

if(values==0){
	selectClass1.length=0;
	selectClass2.length=0;
	selectClass1.disabled=false;
	selectClass2.disabled=false;
	selectClass1.options[0] = new Option("--一级分类--",0);
	selectClass2.options[0] = new Option("--二级分类--",0);
	}

if(values==1){
	selectClass1.length=0;
	selectClass2.length=0;
	selectClass1.disabled=true;
	selectClass2.disabled=true;
	}
if(values==2){
	selectClass1.length=0;
	selectClass2.length=0;
	selectClass2.disabled=true;
	selectClass1.disabled=false;
	$.getJSON(
"/admin/add_class?action=class1",
function(json){
	obj = json;
	
	for (i = 0; i < obj.length; i++) {
				selectClass1.options[i] = new Option(obj[i],
						i);
			}
	});
	}


if(values==3){
	selectClass1.length=0;
	selectClass2.length=0;
	selectClass2.disabled=false;
	selectClass1.disabled=false;
	selectClass1.options[0] = new Option("一级分类",0);
	selectClass2.options[0] = new Option("二级分类",0);
	$.getJSON(
"/admin/add_class?action=class1",
function(json){
	obj = json;
	for (i = 1; i <= obj.length; i++) {
				selectClass1.options[i] = new Option(obj[i-1],
						i);
			}
	});
	}
/*
$.getJSON(
"/admin/add_class?action=data",
function(json){
	obj = json;


	alert(obj);
	$(json).each(
function(i){
	//alert(json[i])
	}		
	);
	}
);
*/

}



function myclass2(){
	selectClass1 = document.getElementById('select1');
	selectClass2 = document.getElementById('select2');
	values1 = selectClass1.value;
	text1 = selectClass1.options[values1].text;
	
	if(selectClass2.disabled){
		
		}
else if(values1==0){
	selectClass2.length=0;
	selectClass2.options[0] = new Option("二级分类",0);
	}
		else{
	
	selectClass2.length=0;
	
			$.getJSON(
"/admin/add_class?action=class2&text="+text1,
function(json){
	obj = json;
	if (obj ==  ""){
		selectClass2.options[0] = new Option("无二级分类",0);
		}
	else{
		selectClass2.options[0] = new Option("二级分类",0);
		for (i = 1; i <= obj.length; i++) {
				selectClass2.options[i] = new Option(obj[i-1],i);
			}
		}
	});
		}
	
	
	}
	
	