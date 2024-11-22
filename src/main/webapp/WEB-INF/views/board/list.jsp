<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    <%@include file="../includes/header.jsp" %>
    
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                       Board List Page
                       <button id="regBtn" type="button" class="btn-xs btn-info pull-right">Register New Button</button>
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <table width="100%" class="table table-striped table-bordered table-hover" >
                            <thead>
                                <tr>
                                    <th>#번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>수정일</th>
                                </tr>
                            </thead>
                            <c:forEach items="${list }" var="board">
                            	<tr>
                            		<td>${board.bno }</td>
                            		<td>
                            			<a class="move" href="${board.bno}">${board.title}
                            				<b>[${board.replyCnt}]</b>
                            			</a>
                            		</td>
                            		<td>${board.writer}</td>
                            		<td><fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd"/> </td>
                            		<td><fmt:formatDate value="${board.updatedate}" pattern="yyyy-MM-dd"/> </td>
                            	</tr>
                            </c:forEach>
                        </table>
                        
                        <!-- 검색 조건 -->
                        <div class="row">
                        	<div class="col-lg-12">
                        	
                        	<form id="searchForm" action="/board/list" method="get">
                        		<select name="type" style="height: 25px">
                        			<option value="" ${pageMaker.cri.type==null? 'selected' : ''}>--</option>
                        			<option value="T" ${pageMaker.cri.type eq 'T' ? 'selected' : ''}>제목</option>
                        			<option value="C" ${pageMaker.cri.type eq 'C' ? 'selected' : ''}>내용</option>
                        			<option value="W" ${pageMaker.cri.type eq 'W' ? 'selected' : ''}>작성자</option>
                        			<option value="TC" ${pageMaker.cri.type eq 'TC' ? 'selected' : ''}>제목 or 내용</option>
                        			<option value="TW" ${pageMaker.cri.type eq 'TW' ? 'selected' : ''}>제목 or 작성자</option>
                        			<option value="TCW" ${pageMaker.cri.type eq 'TCW' ? 'selected' : ''}>제목 or 내용 or 작성자</option>
                        		</select>
                        		<input type="text" name="keyword" value="${pageMaker.cri.keyword}" />
                        		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                        		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                        		<button class="btn btn-default">Search</button>
                        	</form>
                        	
                        	</div>
                        </div>
                        
                        <!-- 페이지 버튼 눌러 동작 -->
                        <form id="actionForm" action="/board/list" method="get">
                        	<input type="hidden"  name="pageNum" value="${pageMaker.cri.pageNum}">
                        	<input type="hidden"  name="amount" value="${pageMaker.cri.amount}">
                        	
                        	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}" />
                        	<input type="hidden" name="type" value="${pageMaker.cri.type}" />
                        </form>
                        
                        <!-- 페이징 처리 시작 -->
                        <nav aria-label="..." class="pull-right">
						  <ul class="pagination">
						  
						  	<c:if test="${pageMaker.prev}">
							    <li class="page-item paginate_button">
							      <a class="page-link" href="${pageMaker.startPage-1}">Previous</a>
							    </li>
						    </c:if>
						    
						    <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
						    	<li class="page-item paginate_button ${pageMaker.cri.pageNum == num ? "active" : ""} ">
						    	<a href="${num}">${num}</a>
						    	</li>
						    </c:forEach> 
						     
						    <c:if test="${pageMaker.next}">
							    <li class="page-item next paginate_button">
							      <a class="page-link" href="${pageMaker.endPage+1}">Next</a></li>
						    </c:if>
						  </ul>
						</nav>
                        <!-- 페이징 처리 끝 -->
                       
                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
            <!-- /.col-lg-12 -->
        </div> <!-- end row -->
        
        <div id="myModal" class="modal" tabindex="-1">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title">Modal title</h5>
		        <!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
		      </div>
		      <div class="modal-body">
		        <p>처리가 완료되었습니다.</p>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		        <button type="button" class="btn btn-primary">Save changes</button>
		      </div>
		    </div>
		  </div>
		</div>
        
      <script type="text/javascript">
        	$(document).ready(function(){
        		let result = '<c:out value="${result}"/>';
        		
        		checkModal(result);
        		
        		history.replaceState({},null,null);
        		
        		function checkModal(result){
        			
        			if(result === '' || history.state ){
        				return;
        			}
        			
        			if(parseInt(result) > 0){
        				$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
            				
        			}
        			$("#myModal").modal("show");
        		}
        		
        		/* ${"#regBtn"}.on("click", function(){
        			self.location = "/board/register";
        		}); */
        		
        		document.getElementById("regBtn").addEventListener("click", function(){
        			window.location.href = "/board/register";
        		});
        		
        		let actionForm = $("#actionForm");
        		
        		$(".paginate_button a").on("click", function(e){
        			e.preventDefault();
        			
        			console.log("click");
        			
        			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
        			actionForm.submit();
        		});
        		
        		$(".move").on("click", function(e){
        			e.preventDefault();
        			
        			actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href")+"'>");
        			actionForm.attr("action", "/board/get").submit();
        		});
        		
        		let searchForm = $("#searchForm");
        		$("#searchForm button").on("click", function(e){
        			
        			if(!searchForm.find("option:selected").val()){
        				alert("검색 종류를 선택하세요");
        				return false;
        			}
        			
        			if(!searchForm.find("input[name='keyword']").val()){
        				alert("키워드를 입력하세요");
        				return false;
        			}
        			
        			searchForm.find("input[name='pageNum']").val("1"); //검색은 항상 1 페이지부터
        			e.preventDefault();
        			
        			searchForm.submit();
        		});
        		
        	});
        </script>
        
        
        <%@include file="../includes/footer.jsp" %>

