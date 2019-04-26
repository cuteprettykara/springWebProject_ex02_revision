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
		          <button type="button" data-oper='list' class="btn btn-secondary">List</button>
            </div>
          </div>
          
          <form id='operForm' action="/board/modify" method="get">
					  <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
					</form> 
    

<script>
	$(document).ready(function() {
		var operForm = $("#operForm"); 
		 
		$("button[data-oper='modify']").on("click", function(e){  
	    operForm.attr("action","/board/modify").submit();
	  });
	  
	  $("button[data-oper='list']").on("click", function(e){
	    operForm.find("#bno").remove();
	    operForm.attr("action","/board/list")
	    operForm.submit();
		});
	});
</script>


<%@ include file="../includes/footer.jsp"%>