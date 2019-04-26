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
              <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
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
											<td><c:out value="${board.title}" /></td>
											<td><c:out value="${board.writer}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.regdate}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.updateDate}" /></td>
										</tr>
									</c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

<script>
	$(document).ready(function() {
		var result = '<c:out value="${result}" />';
		console.log('*************');
		console.log(result);
	})
</script>

<%@ include file="../includes/footer.jsp"%>