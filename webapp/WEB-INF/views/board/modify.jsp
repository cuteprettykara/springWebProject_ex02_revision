<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>


          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Board Modify Page</h1>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Board Modify</h6>
            </div>
            
            <div class="card-body">
            	<form id='operForm' action="/board/modify" method="post">
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
			          
			          <button type="button" data-oper='modify' class="btn btn-primary">Save</button>
			          <button type="button" data-oper='list' class="btn btn-secondary">List</button>
							</form> 
            </div>
          </div>
    

<script>
	$(document).ready(function() {
		var formObj = $("#operForm"); 
		 
		$("button[data-oper='modify']").on("click", function(e){  
			formObj.attr("action","/board/modify").submit();
		 });
		 
		 $("button[data-oper='list']").on("click", function(e){
		  self.location = "/board/list";
		 });
	});
</script>


<%@ include file="../includes/footer.jsp"%>