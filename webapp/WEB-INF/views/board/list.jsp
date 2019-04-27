<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Tables</h1>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <span class="m-0 font-weight-bold text-primary">Board List Page</span>
							<button id='regBtn' type="button" class="btn btn-primary btn-sm float-right">Register New Board</button>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>#번호</th>
                      <th>제목</th>
                      <th>작성자</th>
                      <th>작성일</th>
                      <th>수정일</th>
                    </tr>
                  </thead>

                  <tbody>
									<c:forEach items="${list}" var="board">
										<tr>
											<td><c:out value="${board.bno}" /></td>
											<td><a href='/board/read?bno=<c:out value="${board.bno}"/>'><c:out value="${board.title}" /></a></td>
											<td><c:out value="${board.writer}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.regdate}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.updateDate}" /></td>
										</tr>
									</c:forEach>
                  </tbody>
                </table>
                
                
                <c:choose>
                	<c:when test="${pageMaker.prev}">
                		<c:set var="prev_class" value="page-item" />
										<c:set var="prev_aria_disabled" value="" />
                	</c:when>
                	<c:otherwise>
                		<c:set var="prev_class" value="page-item disabled" />
										<c:set var="prev_aria_disabled" value="tabindex=-1 aria-disabled=true" />
                	</c:otherwise>
                </c:choose>
                
                <c:choose>
                	<c:when test="${pageMaker.next}">
                		<c:set var="next_class" value="page-item" />
										<c:set var="next_aria_disabled" value="" />
                	</c:when>
                	<c:otherwise>
                		<c:set var="next_class" value="page-item disabled" />
										<c:set var="next_aria_disabled" value="tabindex=-1 aria-disabled=true" />
                	</c:otherwise>
                </c:choose>
                
                <div>
                	<ul class="pagination justify-content-center">
										<li class="${prev_class}">
											<a class="page-link" href="#" ${prev_aria_disabled}>Previous</a>
										</li>
		
                		<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
											<li class="page-item">
												<a class="page-link" href="#">${idx}</a>
											</li>
										</c:forEach>
										
										<li class="${next_class}">
											<a class="page-link" href="#" ${next_aria_disabled}>Next</a>
										</li>
                	</ul>
                </div>
                
                
              </div>
            </div>
          </div>



<!-- myModal Modal-->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="myModalLabel">Modal Title</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">처리가 완료되었습니다.</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>



<script>
	function checkModal(result) {
		// 모달창을 띄울 필요가 없다는 표시가(history.state) 존재한다면 리턴한다.
		if (result == '' || history.state) return;
		
		var bno = parseInt(result);
		var $myModal = $("#myModal");
		
		if (bno > 0) {
			$myModal.find(".modal-body").html("게시글 " + bno + "번이 등록되었습니다.");
		}
		
		$myModal.modal("show");
	}


	$(document).ready(function() {
		
	  $('#dataTable').DataTable({
		  "dom": "lrt",
		  "order": []
	  });
	  
//		console.log('${criteria.perPageNum}');
		$("select[name='dataTable_length']").val('${criteria.perPageNum}');
	
		var result = '<c:out value="${result}" />';
		
		checkModal(result);
		
		// 다음부터는 모달창을 띄울 필요가 없다는 표시를 해둔다.
		history.replaceState({}, null, null);
		
		$("#regBtn").on("click", function() {
			self.location = "/board/register";
		});
	})
	
</script>

<%@ include file="../includes/footer.jsp"%>