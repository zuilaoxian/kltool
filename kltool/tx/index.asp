<!--#include file="../inc/head.asp"-->
<title>头像剪切上传</title>
    <link rel="stylesheet" type="text/css" href="webapp/cropper.min.css">
    <link rel="stylesheet" type="text/css" href="webapp/mui.min.css">
    <script type="text/javascript" src="webapp/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="webapp/lrz.all.bundle.js"></script>
    <script type="text/javascript" src="webapp/cropper.min.js"></script>
    <script type="text/javascript">
    $(function() {

        function toFixed2(num) {
            return parseFloat(+num.toFixed(2));
        }
		
        $('#cancleBtn').on('click', function() {
            $("#showEdit").fadeOut();
            $('#showResult').fadeIn();
        });

        $('#confirmBtn').on('click', function() {
            $("#showEdit").fadeOut();

            var $image = $('#report > img');
            var dataURL = $image.cropper("getCroppedCanvas");
            var imgurl = dataURL.toDataURL("image/jpeg", 0.5);
            $("#changeAvatar > img").attr("src", imgurl);
            $("#basetxt").val(imgurl);
            $('#showResult').fadeIn();

        });

        function cutImg() {
            $('#showResult').fadeOut();
            $("#showEdit").fadeIn();
            var $image = $('#report > img');
            $image.cropper({
                aspectRatio: 1 / 1,
                autoCropArea: 0.7,
                strict: true,
                guides: false,
                center: true,
                highlight: false,
                dragCrop: false,
                cropBoxMovable: false,
                cropBoxResizable: false,
                zoom: -0.2,
                checkImageOrigin: true,
                background: false,
                minContainerHeight: 400,
                minContainerWidth: 300
            });
        }

        function doFinish(startTimestamp, sSize, rst) {
            var finishTimestamp = (new Date()).valueOf();
            var elapsedTime = (finishTimestamp - startTimestamp);
            //$('#elapsedTime').text('压缩耗时： ' + elapsedTime + 'ms');

            var sourceSize = toFixed2(sSize / 1024),
                resultSize = toFixed2(rst.base64Len / 1024),
                scale = parseInt(100 - (resultSize / sourceSize * 100));
            $("#report").html('<img src="' + rst.base64 + '" style="width: 100%;height:100%">');
            cutImg();
        }

        $('#image').on('change', function() {
            var startTimestamp = (new Date()).valueOf();
            var that = this;
            lrz(this.files[0], {
                    width: 800,
                    height: 800,
                    quality: 0.7
                })
                .then(function(rst) {
                    //console.log(rst);
                    doFinish(startTimestamp, that.files[0].size, rst);
                    return rst;
                })
                .then(function(rst) {
                    // 这里该上传给后端啦
                    // 伪代码：ajax(rst.base64)..

                    return rst;
                })
                .then(function(rst) {
                    // 如果您需要，一直then下去都行
                    // 因为是Promise对象，可以很方便组织代码 \(^o^)/~
                })
                .catch(function(err) {
                    // 万一出错了，这里可以捕捉到错误信息
                    // 而且以上的then都不会执行

                    alert(err);
                })
                .always(function() {
                    // 不管是成功失败，这里都会执行
                });
        });

    });
function display(obj)
{
  if (obj.style.display=='none') 
    obj.style.display='';
  else
    obj.style.display='none';
}
    </script>
    <div id="showResult">
        <div style="width: 50%;margin: 0 auto;margin-top: 10px;">
            <input id="image" type="file" accept="image/*"/><!--相机属性，添加以后有些浏览器默认启动相机，因此去除 capture="camera" -->
        </div>

        <div id="changeAvatar" style="margin-top: 35px;">
            <img src="default.jpg" style="width: 100px;margin-top: 10px;margin: 0 auto;display:block;">
        </div>
    </div>
    <div id="showEdit" style="display: none;width:100%;height: 100%;position: absolute;top:0;left: 0;z-index: 9;">
        <div style="width:100%;position: absolute;top:10px;left:0px;">
            <button class="mui-btn" data-mui-style="fab" id='cancleBtn' style="margin-left: 10px;">取消</button>
            <button onclick="display(save_pic);return false;" class="mui-btn" data-mui-style="fab" data-mui-color="primary" id='confirmBtn' style="float:right;margin-right: 10px;">确定</button>
        </div>
        <div id="report">
          <img src="image/mei.jpg" style="width: 300px;height:300px"> 
      </div>
        
    </div>
    <div style="width:50%; margin:50px auto;">
<%picexe="jpg"	'图片格式
picname=Getname()&GetnameR()&"."&picexe	'结果图将命名%>
<form method="post" action="?">
<input name="pg" type="hidden" value="up">
<input name="picname" type="hidden" value="<%=picname%>">
    <input type="hidden" name="txt" id="basetxt" onclick="this.checked = true">
<span id="save_pic" style="display:none"><input type="submit" value="确定保存并设置为头像"></span>
</form>
    </div>
<%
pg=Request("pg")
if pg="up" then
content=Request("txt")
picname=Request("picname")
picpath=Server.MapPath("ximg")
picpath=replace(picpath,Server.MapPath("/"),"")
picpath=replace(picpath,"\","/")
arr_picpath=Split(picpath,"/")
For i = 0 To UBound(arr_picpath)
if arr_picpath(i)<>"" then pic_path=pic_path&arr_picpath(i)&"/"
Next
picpath=pic_path&picname
if content="" then Response.redirect"?"
content=unescape(content)
content=replace(content,"data:image/jpeg;base64,","")
if content<>"" then
Dim xml : Set xml=Server.CreateObject("MSXML2.DOMDocument")	'MSXML2.DOMDocument/Microsoft.XMLHTTP
Dim stm : Set stm=Server.CreateObject("ADODB.Stream") 
xml.resolveExternals=false
xml.loadXML("<?xml version=""1.0"" encoding=""gb2312""?><data><![CDATA["&content&"]]></data>")	'加载xml文件中的内容，使用xml解析出
xml.documentElement.setAttribute"xmlns:dt","urn:schemas-microsoft-com:datatypes"
xml.documentElement.dataType ="bin.base64"
stm.Type=1	'adTypeBinary
stm.Open
stm.Write xml.documentElement.nodeTypedValue
stm.SaveToFile Server.MapPath("/"&picpath)	'文件保存到指定路径
response.Write"成功保存并设置为头像<br/><img src='/"&picpath&"'>"
stm.Close
Set xml=Nothing  
Set stm=Nothing
conn.execute("update [user] set headimg='"&picpath&"' where siteid="&siteid&" and userid="&userid)
end if
end if
call kltool_end
%>
