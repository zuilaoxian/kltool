<%
function CreatePic(tu1,tu2)'生成缩略图
    Set Jpeg = Server.CreateObject("Persits.Jpeg")
    Path = server.mappath(tu1)  '图片所在位置
    Jpeg.Open Path  ' 打开
    if Jpeg.OriginalWidth>Jpeg.OriginalHeight then   ' 设置缩略图大小
        Jpeg.Width =300
        Jpeg.Height = Jpeg.OriginalHeight / (Jpeg.OriginalWidth / 300 )
    else
 Jpeg.Height =250
 Jpeg.Width = Jpeg.OriginalWidth / ( Jpeg.OriginalHeight/ 250)
    end if 
 Jpeg.Save server.mappath(tu2)  ' 保存缩略图到指定文件夹下
 Set Jpeg = Nothing  ' 注销实例
end function

sub downFile(url,filePath)
      '远程获取文件
      '------------------------------------------------------
      dim xmlhttp
      set xmlhttp = server.CreateObject("Microsoft.XMLHTTP")
      xmlhttp.open"get",url,false
      xmlhttp.send
      dim html
      html = xmlhttp.ResponseBody
      '获取文件名
      '-----------------------------------------------------
      dim fileName,fileNameSplit
      fileNameSplit = Split(url,"/")
      fileName = fileNameSplit(Ubound(fileNameSplit))
      '开始保存文件到本地
      '-----------------------------------------------------
      Set saveFile = Server.CreateObject("Adodb.Stream")
      saveFile.Type = 1
      saveFile.Open
      saveFile.Write html
      saveFile.SaveToFile server.MapPath(filePath)&"\"&fileName, 2
      end sub
%>
