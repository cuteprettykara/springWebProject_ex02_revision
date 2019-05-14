<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>

<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li div {
		color: white;
	}	
	
	.uploadResult ul li img {
		width: 100px;
	}
</style>
	
	
          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Board Register</h1>

          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Board Register</h6>
            </div>
            <div class="card-body">
			        <form role="form" action="/board/register" method="post">
			          <div class="form-group">
			            <label>Title</label>
			            <input class="form-control" name='title'>
			          </div>
			
			          <div class="form-group">
			            <label>Text area</label>
			            <textarea class="form-control" rows="3" name='content'></textarea>
			          </div>
			
			          <div class="form-group">
			            <label>Writer</label>
			            <input class="form-control" name='writer'>
			          </div>
			          
			          <button type="submit" class="btn btn-primary">Submit</button>
			          <button type="reset" class="btn btn-secondary">Reset</button>
			        </form>
            </div>
          </div>
          
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">File Attach</h6>
            </div>
            <div class="card-body">
			          <div class="uploadDiv">
									<input type="file" name="uploadFile" multiple>
								</div>
									
								<div class="uploadResult">
									<ul>
									
									</ul>
								</div>
            </div>
          </div>


<script>
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5MB
	
	function checkExtension(fileName, fileSize) {
	
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
	
		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}

	$(document).ready(function() {
		var formObj = $("form[role='form']");
		
		
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			console.log("submit clicked");
		});
		
		$("input[type='file']").change(function(e) {
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			console.log(files);
			
			for (var i = 0; i < files.length; i++) {
				if (!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				type: "post",
				url: "/uploadAjax",
				data: formData,
				dataType: "json",
				processData: false,
				contentType: false,
				success: function(result) {
					console.log(result);
					showUploadedFile(result);
				}
			});
			
			$(".uploadResult").on("click", "button", function(e) {
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				var targetLi = $(this).closest("li");
				
				$.ajax({
					type: "post",
					url: "/deleteFile",
					data: {fileName: targetFile, type:type},
					dataType: "text",
					success: function(result) {
						alert(result);
						targetLi.remove();
					}
				});
				
			});
			
			function showUploadedFile(uploadResultArr) {
				if (!uploadResultArr || uploadResultArr.length == 0) return;
				
				var uploadResult = $(".uploadResult ul");
				
				var str = "";
				
				$(uploadResultArr).each(function(i, obj) {
					if (obj.image) {
						var imagePath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
						
						var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
						console.log("before replace: " + originPath);
						
						// 생성된 문자열은 '\' 기호 때문에 일반 문자열과는 다르게 처리되므로, '/'로 변환한 뒤에, showImage()에 파라미터로 전달합니다.
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						console.log("after replace: " + originPath);
						
						str += "<li><div>"
						     + "<span>" + obj.fileName + "</span>"
						     + "<button type='button' class='btn btn-warning btn-circle' data-file='" + imagePath + "' data-type='image'>"
						     + "<i class='fa fa-times'></i></button><br>"
						     + "<img src='/displayFile?fileName=" + imagePath + "'>"
						     + "</div></li>";
					} else {
						var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						str += "<li><div>"
							   + "<span>" + obj.fileName + "</span>"
					       + "<button type='button' class='btn btn-warning btn-circle' data-file='" + filePath + "' data-type='file'>"
							   + "<i class='fa fa-times'></i></button><br>"
							   + "<img src='/resources/img/attach.png'></a>"
							   + "</div></li>";
					}
				});
				
				uploadResult.append(str);
			}
			
		});
	});
</script>

<%@ include file="../includes/footer.jsp"%>