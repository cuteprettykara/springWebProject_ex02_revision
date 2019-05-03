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
    

<script>
	$(document).ready(function() {
		var formObj = $("#operForm"); 
		
		$('button').on("click", function(e) {
			
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