<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

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
          <h1 class="h3 mb-2 text-gray-800">Board Modify Page</h1>

          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Board Modify</h6>
            </div>
            
            <div class="card-body">
            	<form id='operForm' action="/board/modify" method="post">
            		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            	
            		<input type="hidden" name="page" value="${cri.page}">
								<input type="hidden" name="perPageNum" value="${cri.perPageNum}">
								<input type="hidden" name="searchType" value="${cri.searchType}">
								<input type="hidden" name="keyword" value="${cri.keyword}">
								
	            	<div class="form-group">
			            <label>Bno</label>
			            <input class="form-control" name='bno' value='<c:out value="${board.bno}" />' readonly="readonly">
			          </div>
			          
			          <div class="form-group">
			            <label>Title</label>
			            <input class="form-control" name='title' value='<c:out value="${board.title}" />'>
			          </div>
			
			          <div class="form-group">
			            <label>Text area</label>
			            <textarea class="form-control" rows="3" name='content'>
<c:out value="${board.content}" />
			            </textarea>
			          </div>
			
			          <div class="form-group">
			            <label>Writer</label>
			            <input class="form-control" name='writer' value='<c:out value="${board.writer}" />'>
			          </div>
			          
			          <sec:authentication property="principal" var="pinfo"/>
			          
			          <sec:authorize access="isAuthenticated()">
			          	<c:if test="${pinfo.username eq board.writer}">
				          	<button type="button" data-oper='modify' class="btn btn-primary">Modify</button>
			          	</c:if>
			          </sec:authorize>
		          
		          	<button type="button" data-oper='list' class="btn btn-secondary">List</button>
							</form> 
            </div>
          </div>
          
          <div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">Files</h6>
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
	$(document).ready(function() {
		var formObj = $("#operForm"); 
		 
		$("button[data-oper='modify']").on("click", function(e) {  
			var str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				var jobj = $(obj);
			      
	      console.dir(jobj);
	      console.log("-------------------------");
	      console.log(jobj.data("filename"));
	      
	      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
			});
			
			console.log(str);
		    
			formObj.append(str);
			
			formObj.attr("action","/board/modify").submit();
		});
		 
	  $("button[data-oper='list']").on("click", function(e){
		 	formObj.attr("action", "/board/list");
			formObj.attr("method", "get");
		 
		 	var page = $("input[name='page']").clone();
		 	var perPageNum = $("input[name='perPageNum']").clone();
		 	var searchType = $("input[name='searchType']").clone();
		 	var keyword = $("input[name='keyword']").clone();
		 
		 	formObj.empty();
		 	formObj.append(page);
		 	formObj.append(perPageNum);
		 	formObj.append(searchType);
		 	formObj.append(keyword);
		 
		 	formObj.submit();
	 	});
	  
	});
</script>

<script>
	// 첨부파일
	$(document).ready(function() {
		var bno = "<c:out value='${board.bno}'/>";
		
		$.getJSON("/board/getAttachList", {bno: bno}, function(result) {
			console.log(result);
			
			var str = "";
			var uploadResult = $(".uploadResult ul");
			
			$(result).each(function(i, attach) {
				if (attach.fileType) {
					var imagePath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>"
							 + "<div><span>" + attach.fileName + "</span>"
				       + "<button type='button' class='btn btn-warning btn-circle' data-file='" + imagePath + "' data-type='image'>"
				       + "<i class='fa fa-times'></i></button><br>"
					     + "<img src='/displayFile?fileName=" + imagePath + "'>"
					     + "</div></li>";
				} else {
					var filePath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>"
						   + "<div><span>" + attach.fileName + "</span>"
						   + "<button type='button' class='btn btn-warning btn-circle' data-file='" + filePath + "' data-type='file'>"
						   + "<i class='fa fa-times'></i></button><br>"
						   + "<img src='/resources/img/attach.png'>"
						   + "</div></li>";
				}
			});
			
			uploadResult.html(str);
			
		});
		
		$(".uploadResult").on("click", "button", function(e) {
			if (confirm("Remove this file?")) {
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		
	});
</script>


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
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			
			var str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				var jobj = $(obj);
			      
	      console.dir(jobj);
	      console.log("-------------------------");
	      console.log(jobj.data("filename"));
	      
	      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
			});
			
			console.log(str);
		    
			formObj.append(str).submit();
			
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
				beforeSend: function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				dataType: "json",
				processData: false,
				contentType: false,
				success: function(result) {
					console.log(result);
					showUploadedFile(result);
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
					
					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>"
					     + "<div><span>" + obj.fileName + "</span>"
					     + "<button type='button' class='btn btn-warning btn-circle' data-file='" + imagePath + "' data-type='image'>"
					     + "<i class='fa fa-times'></i></button><br>"
					     + "<img src='/displayFile?fileName=" + imagePath + "'>"
					     + "</div></li>";
				} else {
					var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>"
						   + "<div><span>" + obj.fileName + "</span>"
				       + "<button type='button' class='btn btn-warning btn-circle' data-file='" + filePath + "' data-type='file'>"
						   + "<i class='fa fa-times'></i></button><br>"
						   + "<img src='/resources/img/attach.png'>"
						   + "</div></li>";
				}
			});
			
			uploadResult.append(str);
		}
		
	});
</script>


<%@ include file="../includes/footer.jsp"%>