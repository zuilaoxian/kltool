<!--#include file="../config.asp"--><!--#include file="../class/UpLoad_Class.asp"-->
<%
kltool_use(13)
if ObjTest("MSXML2.DOMDocument",0)=False then
	Response.write kltool_code(kltool_head("MSXML2.DOMDocument组件不支持",0)&kltool_alert("MSXML2.DOMDocument组件不支持:<br/>"&ObjTest("MSXML2.DOMDocument",1))&kltool_end(0))
	Response.End()
end if

action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "yes"
		call index1()
end select

sub index()
response.Write kltool_code(kltool_head("头像剪切上传",1))
%>
<link rel="stylesheet" href="css/cropper.css">
  <style>
    .label {
      cursor: pointer;
    }
    .progress {
	  width: 100%;
	  max-width: 320px;
      display: none;
      margin-bottom: 1rem;
    }
    .alert {
      display: none;
    }
    .img-container img {
      max-width: 100%;
    }

    img {
      max-width: 100%;
    }

    .row,
    .preview {
      overflow: hidden;
    }

    .col {
      float: left;
    }

    .col-6 {
      width: 100%;
    }

    .col-3 {
      width: 30%;
    }

    .col-2 {
      width: 20%;
    }

    .col-1 {
      width: 10%;
    }
	
  </style>
</head>
<body>
  <div class="list-group-item">
	使用本插件后不可更改工具箱目录，否则图片无法显示
    <h3>点击当前的头像 选择图片进行裁剪</h3>
    <label class="label" data-toggle="tooltip" title2="Change your avatar">
      <img class="rounded" id="avatar" src="<%=kltool_get_userheadimg(userid,0)%>" alt="avatar">
      <input type="file" class="sr-only" id="input" name="image" accept="image/*">
    </label>
    <div class="progress">
      <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
    </div>
    <div class="alert" role="alert"></div>
    <div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
            <h5 class="modal-title" id="modalLabel">区域选择</h5>
          </div>
          <div class="modal-body">
			  <!--div class="img-container">
				<img id="image" src="<%=kltool_get_userheadimg(userid,0)%>" alt="Picture">
			  </div-->
			<div class="row">
			  <div class="col col-6">
				<img id="image" src="<%=kltool_get_userheadimg(userid,0)%>" alt="Picture">
			  </div>
			  <div class="col col-3">
				<div class="preview"></div>
			  </div>
			  <div class="col col-2">
				<div class="preview"></div>
			  </div>
			  <div class="col col-1">
				<div class="preview"></div>
			  </div>
			</div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" id="crop">确定并设置头像</button>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="js/cropper.js"></script>
  <script>
    function each(arr, callback) {
      var length = arr.length;
      var i;
      for (i = 0; i < length; i++) {
        callback.call(arr, arr[i], i, arr);
      }
      return arr;
    }
    window.addEventListener('DOMContentLoaded', function () {
      var avatar = document.getElementById('avatar');
      var image = document.getElementById('image');
      var input = document.getElementById('input');
	  var previews = document.querySelectorAll('.preview');
      var $progress = $('.progress');
      var $progressBar = $('.progress-bar');
      var $alert = $('.alert');
      var $modal = $('#modal');
      var cropper;
      $('[data-toggle="tooltip"]').tooltip();
      input.addEventListener('change', function (e) {
        var files = e.target.files;
        var done = function (url) {
          input.value = '';
          image.src = url;
          $alert.hide();
		  $modal.attr('data-backdrop','static').attr('data-keyboard','false')
          $modal.modal('show');
        };
        var reader;
        var file;
        var url;
        if (files && files.length > 0) {
          file = files[0];
          if (URL) {
            done(URL.createObjectURL(file));
          } else if (FileReader) {
            reader = new FileReader();
            reader.onload = function (e) {
              done(reader.result);
            };
            reader.readAsDataURL(file);
          }
        }
      });
      $modal.on('shown.bs.modal', function () {
        cropper = new Cropper(image, {
          aspectRatio: 1,
          viewMode: 1,
		  ready: function () {
            var clone = this.cloneNode();
		    clone.className = '';
            clone.style.cssText = (
              'display: block;' +
              'width: 100%;' +
              'min-width: 0;' +
              'min-height: 0;' +
              'max-width: none;' +
              'max-height: none;'
            );
            each(previews, function (elem) {
              elem.appendChild(clone.cloneNode());
            });
          },
		  crop: function (event) {
            var data = event.detail;
            var cropper = this.cropper;
            var imageData = cropper.getImageData();
            var previewAspectRatio = data.width / data.height;

            each(previews, function (elem) {
              var previewImage = elem.getElementsByTagName('img').item(0);
              var previewWidth = elem.offsetWidth;
              var previewHeight = previewWidth / previewAspectRatio;
              var imageScaledRatio = data.width / previewWidth;

              elem.style.height = previewHeight + 'px';
              previewImage.style.width = imageData.naturalWidth / imageScaledRatio + 'px';
              previewImage.style.height = imageData.naturalHeight / imageScaledRatio + 'px';
              previewImage.style.marginLeft = -data.x / imageScaledRatio + 'px';
              previewImage.style.marginTop = -data.y / imageScaledRatio + 'px';
            });
          }
        });
      }).on('hidden.bs.modal', function () {
        cropper.destroy();
        cropper = null;
      });
      document.getElementById('crop').addEventListener('click', function () {
        var initialAvatarURL;
        var canvas;
        $modal.modal('hide');
        if (cropper) {
          canvas = cropper.getCroppedCanvas({
            width: 160,
            height: 160,
          });
          initialAvatarURL = avatar.src;
          avatar.src = canvas.toDataURL();
          $progress.show();
          $alert.removeClass('alert-success alert-warning');
          canvas.toBlob(function (blob) {
            var formData = new FormData();
            formData.append('avatar', blob, 'avatar.jpg');
            $.ajax('index.asp?action=yes', {
              method: 'POST',
              data: formData,
			  async:true,
              processData: false,
              contentType: false,
              xhr: function () {
                var xhr = new XMLHttpRequest();
                xhr.upload.onprogress = function (e) {
                  var percent = '0';
                  var percentage = '0%';

                  if (e.lengthComputable) {
                    percent = Math.round((e.loaded / e.total) * 100);
                    percentage = percent + '%';
                    $progressBar.width(percentage).attr('aria-valuenow', percent).text(percentage);
                  }
                };
                return xhr;
              },
              success: function () {
                $alert.show().addClass('alert-success').text('Upload success 成功保存并设置为头像');
              },
              error: function () {
                avatar.src = initialAvatarURL;
                $alert.show().addClass('alert-warning').text('Upload error 发生了错误 请重试');
              },
              complete: function () {
                $progress.hide();
              },
            });
          });
        }
      });
    });
  </script>
<%
	response.Write kltool_end(1)
end sub

sub index1()
	'使用艾恩无组件UpLoad接收post
	dim upload
	set upload = new AnUpLoad
	upload.Exe = "bmp|jpeg|gif|png|jpg|"
	upload.MaxSize = 200 * 1024 * 1024 '20M
	upload.Charset="utf-8"
	upload.Mode=0
	upload.GetData()
	if upload.ErrorID>0 then 
		response.Write upload.Description
	else
		savepath = "ximg"
		'循环多个文件
			for each f in upload.files(-1)
				set file = upload.files(f)
				if file.isfile then
					result = file.saveToFile(savepath,2,true)
					if result then
						'response.Write "文件'" & file.LocalName & "'上传成功，保存位置'"&Server.MapPath(".")&"/"&savepath&"/" & file.filename & "',文件大小" & file.size & "字节,文件类型" & file.contenttype & ",文件后缀" & file.extend & "<br/>"
						fileurl=fileurl&"|"&savepath&"/"&file.filename
					else
						response.Write file.Exception&file.Description
					end if
				else
					response.Write f & "<br />"
				end if
				set file = nothing
			next
			arrytemp=split(fileurl,"|")
			for i=1 to ubound(arrytemp)
				if arrytemp(i)<>"" then response.Write "path:"&arrytemp(i)&"<br/>headimg:"&kltool_path&arrytemp(i)
				conn.execute("update [user] set headimg='"&kltool_path&"headimg/"&arrytemp(i)&"' where siteid="&siteid&" and userid="&userid)
			next
	end if
	sleep(1)
end sub
%>
