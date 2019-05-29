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
	
	.bigPictureWrapper {
		display:none;
		position: absolute;
/* 		border: 1px solid red; */
		top: 0%;
		width: 100%;
		height: 100%;
		/* background-color: gray; */
		z-index: 100;
		background: rgba(255,255,255, 0.5);
		justify-content: center;
	}
	
	.bigPicture {
		/* border: 1px solid blue; */
		positon: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicutre img {
		width: 600px;
	}
</style>

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Board Read Page</h1>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Board Read</h6>
            </div>
            <div class="card-body">
            	<div class="form-group">
		            <label>Bno</label>
		            <input class="form-control" name='bno' value='<c:out value="${board.bno}" />' readonly="readonly">
		          </div>
		          
		          <div class="form-group">
		            <label>Title</label>
		            <input class="form-control" name='title' value='<c:out value="${board.title}" />' readonly="readonly">
		          </div>
		
		          <div class="form-group">
		            <label>Text area</label>
		            <textarea class="form-control" rows="3" name='content' readonly="readonly">
<c:out value="${board.content}" />
		            </textarea>
		          </div>
		
		          <div class="form-group">
		            <label>Writer</label>
		            <input class="form-control" name='writer' value='<c:out value="${board.writer}" />' readonly="readonly">
		          </div>
		          
		          <sec:authentication property="principal" var="pinfo"/>
		          
		          <sec:authorize access="isAuthenticated()">
		          	<c:if test="${pinfo.username eq board.writer}">
				          <button type="button" data-oper='modify' class="btn btn-primary">Modify</button>
				          <button type="button" data-oper='remove' class="btn btn-danger">Remove</button>
		          	</c:if>
		          </sec:authorize>
		          
		          <button type="button" data-oper='list' class="btn btn-secondary">List</button>
            </div>
          </div>
          
          <form id='operForm' action="/board/modify" method="get">
          	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          	
					  <input type='hidden' name='bno' id="bno" value='<c:out value="${board.bno}"/>'>
					  <input type="hidden" name="page" value="${cri.page}">
						<input type="hidden" name="perPageNum" value="${cri.perPageNum}">
						<input type="hidden" name="searchType" value="${cri.searchType}">
						<input type="hidden" name="keyword" value="${cri.keyword}">
					</form>

<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>

<div class="card shadow mb-4">
	<div class="card-header py-3">
		<h6 class="m-0 font-weight-bold text-primary">Files</h6>
	</div>
	<div class="card-body">
		<div class="uploadResult">
			<ul>

			</ul>
		</div>
	</div>
</div>


<div class="card shadow mb-4">
	
	<div class="card-header py-3">
  	<i class="fa fa-comments fa-fw"></i> Reply
  	<small>[ <span id="replycntSmall"><c:out value="${board.replyCnt}" /></span> ]</small>
 		<sec:authorize access="isAuthenticated()">
   		<button id='addReplyBtn' data-oper='addReply' class='btn btn-primary btn-xs float-right'>New Reply</button>
   	</sec:authorize>
  </div>
  
  <div class="card-body">
		<ul class="chat list-group list-group-flush"></ul>
	</div>
	
	<div class="card-footer text-muted">
	</div>

</div>


<!-- Reply Modal-->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      
      <div class="modal-header">
        <h5 class="modal-title" id="myModalLabel">Reply Modal</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      
      <div class="modal-body">
				<div class="form-group">
					<label>Reply</label> 
					<input class="form-control" name='reply'	value='New Reply!!!!'>
				</div>
				<div class="form-group">
					<label>Replyer</label> 
					<input class="form-control" name='replyer'	value='replyer'>
				</div>
				<div class="form-group">
					<label>Reply Date</label> 
					<input class="form-control"	name='replyDate' value='2018-01-01 13:13'>
				</div>
			</div>
      
      <div class="modal-footer">
        <button id="modalModBtn" class="btn btn-warning" type="button">Modify</button>
        <button id="modalRemoveBtn" class="btn btn-danger" type="button">Remove</button>
        <button id="modalRegisterBtn" class="btn btn-primary" type="button">Register</button>
        <button id="modalCloseBtn" class="btn btn-secondary" type="button">Close</button>
      </div>
      
    </div>
  </div>
</div>
  
    
<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">
	// 댓글(Reply) 등록/수정/삭제 처리
	$(document).ready(function() {
		
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
		showList(1);
		
		var myModal = $("#myModal");
		
		var modalInputReply = myModal.find("input[name='reply']");
		var modalInputReplyer = myModal.find("input[name='replyer']");
		var modalInputReplyDate = myModal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		
		var replyPageFooter = $(".card-footer");
		var currentPage = 1;
		
		$("#addReplyBtn").on("click", function(e) {
			myModal.find("input").val("");
			
			modalInputReplyer.removeAttr("readonly");
			modalInputReplyDate.closest("div").hide();
			
			modalModBtn.hide();
			modalRemoveBtn.hide();
			modalRegisterBtn.show();
			
			myModal.modal("show");
		});
		
		$("#modalCloseBtn").on("click", function(e){
			myModal.modal('hide');
    });
		
		modalRegisterBtn.on("click", function(e) {
			var reply = {
					bno: bnoValue,
					replytext: modalInputReply.val(),
					replyer: modalInputReplyer.val()
			};
			
			replyService.add(reply, function(result) {
				alert(result);
				
				myModal.find("input").val("");
				myModal.modal("hide");
				
				showList(1);
			});
		});
		
		$(".chat").on("click", "li", function(e) {
			var rno = $(this).data("rno");
			
			replyService.get(rno, function(result) {
				modalInputReply.val(result.replytext);
				modalInputReplyer.val(result.replyer).attr("readOnly", "readonly");
				modalInputReplyDate.val(replyService.displayTime(result.regdate))
					.attr("readOnly", "readonly");
		
				myModal.data("rno", result.rno);
				
				modalInputReplyDate.closest("div").show();
				modalModBtn.show();
				modalRemoveBtn.show();				
				modalRegisterBtn.hide();
				
				myModal.modal("show");
			});
		});
		
		modalModBtn.on("click", function(e) {
			var reply = {
				rno: myModal.data("rno"),
				replytext: modalInputReply.val()
			};
			
			replyService.update(reply, function(result) {
				alert(result);
				
				myModal.modal("hide");
				
				showList(currentPage);
			});
		});
		
		modalRemoveBtn.on("click", function(e) {
			replyService.remove(myModal.data("rno"), function(result) {
				alert(result);
				
				myModal.modal("hide");
				
				showList(currentPage);
			});
		});
		
		replyPageFooter.on("click","li a", function(e){
	    e.preventDefault();
	    showList($(this).attr("href"));
		}); 
		
		function showList(page) {
			if (page <= 0) return;
			
			currentPage = page;
			
			replyService.getList({bno:bnoValue, page:page || 1}, function(result) {
				// 댓글 갯수 넣기
				$("#replycntSmall").text(result.pageMaker.totalCount);
				
				var list = result.list;
				if (list == null || list.length == 0) {
					replyUL.html("");
					showList(--page);
					return;
				}
				
				var str = "";
				for (var i = 0; i < list.length; i++) {
					str +="<li class='list-group-item' data-rno='"+list[i].rno+"'>";
	      	str +="  <div><div class='header'><strong class='primary-font'>["
	    	   		+list[i].rno+"] "+list[i].replyer+"</strong>"; 
	       	str +="    <small class='float-right text-muted'>"
	           	+replyService.displayTime(list[i].regdate)+"</small></div>";
	       	str +="    <p>"+list[i].replytext+"</p></div></li>";
				}
				
				replyUL.html(str);
				
				printPaging(result.pageMaker, replyPageFooter);
			});
		}
		
		function printPaging(pageMaker, target) {
			var str = "<ul class='pagination justify-content-center'>";
			
			if (pageMaker.prev) {
				str += "<li class='page-item'><a class='page-link' href='" + (pageMaker.startPage-1) + "'>&laquo;</a></li>";
			}
			
			for (var i = pageMaker.startPage ; i <= pageMaker.endPage; i++) {
				var strClass = pageMaker.cri.page === i ? "class='page-item active'" : "class='page-item'";
				str += "<li " + strClass  + "><a class='page-link' href='" + i + "'>" + i + "</a></li>"
			}
			
			if (pageMaker.next) {
				str += "<li class='page-item'><a class='page-link' href='" + (pageMaker.endPage+1) + "'>&raquo;</a></li>";
			}
			
			target.html(str);
		}
	});

</script>

<script>
	// 게시판(Board) 등록/수정/삭제 처리
	$(document).ready(function() {
		var formObj = $("#operForm"); 
		
		$('.card-body button').on("click", function(e) {
			
			var operation = $(this).data("oper");
			
			console.log(operation);
			
			switch (operation) {
				case "modify":
					formObj.attr("action","/board/modify").submit();
					break;
					
				case "remove":
					var replyCnt =  $("#replycntSmall").html();
					
					if(replyCnt > 0 ){
						alert("댓글이 달린 게시물을 삭제할 수 없습니다.");
						return;
					}
					
					formObj.attr("method", "post");
					formObj.attr("action","/board/remove").submit();
					break;
					
				case "list":
					formObj.find("#bno").remove();
					formObj.attr("method", "get");
					formObj.attr("action", "/board/list").submit();
					break;
					
				default:
					alert("해당하는 명령이 없습니다.");
					break;
			}
			
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
					     + "<div>"
					     + "<img src='/displayFile?fileName=" + imagePath + "'>"
					     + "</div></li>";
				} else {
					var filePath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>"
						   + "<div><span>" + attach.fileName + "</span><br>"
						   + "<img src='/resources/img/attach.png'>"
						   + "</div></li>";
				}
			});
			
			uploadResult.append(str);
			
		});
		
		$(".uploadResult").on("click", "li", function(e) {
			var liObj = $(this);
			
			var originPath = liObj.data("path") + "\\" + liObj.data("uuid") + "_" + liObj.data("filename");
			console.log("before replace: " + originPath);
			
			// 생성된 문자열은 '\' 기호 때문에 일반 문자열과는 다르게 처리되므로, '/'로 변환한 뒤에, showImage()에 파라미터로 전달합니다.
			// 파일 경로의 경우 함수로 전달될 때 문제가 생깁니다.
			originPath = originPath.replace(new RegExp(/\\/g), "/");
			console.log("after replace: " + originPath);
			
			if (liObj.data("type")) {
				showImage(originPath);
			} else {
				self.location = "/downloadFile?fileName=" + originPath;
			}
		});
		
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
			
			setTimeout(() => {
				$(this).hide();
			}, 1000);
			
			// ES6의 화살표 함수는 Chrome에서는 정상 작동하지만, IE11에서는 제대로 동작하지 않으므로 다음의 내용으로 테스트한다.
			/* setTimeout(function() {
				$(".bigPictureWrapper").hide();
			}, 1000); */
		});
		
		function showImage(path) {
			console.log(path);
			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPicture")
				.html("<img src='/displayFile?fileName=" + encodeURI(path) + "'>")
				.animate({width: '100%', height: '100%'}, 1000);
		}
		
	});
</script>

<%@ include file="../includes/footer.jsp"%>