<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>


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
		          
		          <button type="button" data-oper='modify' class="btn btn-primary">Modify</button>
		          <button type="button" data-oper='remove' class="btn btn-danger">Remove</button>
		          <button type="button" data-oper='list' class="btn btn-secondary">List</button>
            </div>
          </div>
          
          <form id='operForm' action="/board/modify" method="get">
					  <input type='hidden' name='bno' id="bno" value='<c:out value="${board.bno}"/>'>
					  <input type="hidden" name="page" value="${cri.page}">
						<input type="hidden" name="perPageNum" value="${cri.perPageNum}">
						<input type="hidden" name="searchType" value="${cri.searchType}">
						<input type="hidden" name="keyword" value="${cri.keyword}">
					</form>


<div class="card shadow mb-4">
	
	<div class="card-header py-3">
  	<i class="fa fa-comments fa-fw"></i> Reply
    <button id='addReplyBtn' data-oper='addReply' class='btn btn-primary btn-xs float-right'>New Reply</button>
  </div>
  
  <div class="card-body">
		<ul class="chat"></ul>
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
				var list = result.list;
				if (list == null || list.length == 0) {
					replyUL.html("");
					showList(--page);
					return;
				}
				
				var str = "";
				for (var i = 0; i < list.length; i++) {
					str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	      	str +="  <div><div class='header'><strong class='primary-font'>["
	    	   		+list[i].rno+"] "+list[i].replyer+"</strong>"; 
	       	str +="    <small class='float-right text-muted'>"
	           	+replyService.displayTime(list[i].regdate)+"</small></div>";
	       	str +="    <p>"+list[i].replytext+"</p></div><hr></li>";
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


<%@ include file="../includes/footer.jsp"%>