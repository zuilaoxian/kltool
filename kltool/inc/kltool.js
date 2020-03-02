  /**
	@作者：唯一丶(qq:721796631)
	@value 传入的值，当在输入框时就用
		<input onkeyup="ajaxQuerySetDom(this.value,'地址','查询串','设置Dom的id')" />
	@url 请求地址
	@query 请求参数key
	@setDom 请求完成后操作哪个Dom
  */
	function ajaxQuerySetDom(value,url,query,setDom)
	{
		var	xmlhttp;
		var	Data=url+""+query+"="+value;
		/**
		@url = './key.asp';
		@query = 'key';
		@getDom.value ='wonly';
		@Data = './key.asp?key=wonly';
		@这段是演示组成的请求地址
		*/
		if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
			  xmlhttp=new XMLHttpRequest();
		  }else{// code for IE6, IE5
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
			xmlhttp.onreadystatechange=function(){
		  if (xmlhttp.readyState==4 && xmlhttp.status==200){
			  //请求成功，操作setDom，将返回的内置添加到setDom
				document.getElementById(setDom).innerHTML=xmlhttp.responseText;
			}
		  }
		xmlhttp.open("GET",Data,true);
		xmlhttp.send();
		//return false;
	}

//全选反选
function check_all(obj,cName) 
{
    var checkboxs = document.getElementsByName(cName); 
    for(var i=0;i<checkboxs.length;i++){checkboxs[i].checked = obj.checked;} 
}
//点击提示内容
function ConfirmDel(message)
{
   if (confirm(message))
   {
   document.formDel.submit();
   }else{
   //history.go(0);
   }
}
//隐藏部分内容,点击显示
function display(obj)
{
  if (obj.style.display=='none') 
    obj.style.display='';
  else
    obj.style.display='none';
}

function getValues(obj,val,arr){
var Dom=document.getElementById(obj);
	if (arr.indexOf(val)<0){
		Dom.style.display='none';
	}else{
		Dom.style.display='';
	}
}