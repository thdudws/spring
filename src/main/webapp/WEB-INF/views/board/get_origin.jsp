<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    <%@include file="../includes/header.jsp" %>
    

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
             	 Board Read Page
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
               
                	<div class="form-group">
                		<label>Bno</label><input class="form-control" name="bno"
                		value="${board.bno}" readonly="readonly"/>
                	</div>
                	
                	<div class="form-group">
                		<label>Title</label><input class="form-control" name="title"
                		value="${board.title}" readonly="readonly"/>
                	</div>
                	
                	<div class="form-group">
                		<label>Text area</label>
                		<textarea rows="3" name="content" class="form-control" readonly="readonly">${board.content}</textarea>
                	</div>
                	
                	<div class="form-group">
                		<label>Write</label>
                		<input class="form-control" name="write" value="${board.writer}" readonly="readonly"/>
                	</div>
                	<button data-oper="modify" class="btn btn-default">Modify</button>
                	<button data-oper="list" class="btn btn-info">List</button>
             
               <form id="operForm" action="/board/modify" method="get">
               		<input type="hidden" id="bno" name="bno" value="${board.bno}" />
               		<input type="hidden" name="pageNum" value="${cri.pageNum}" />
               		<input type="hidden" name="amount" value="${cri.amount}" />
               		
               		<input type="hidden" name="type" value="${cri.type}" />
               		<input type="hidden" name="keyword" value="${cri.keyword}" />
               </form>
               
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div> <!-- end row -->
      
<script src="/resources/js/reply.js"></script>

<script>	//test
	$(document).ready(function(){
		console.log("------");
		console.log("JS TEST");
		
		let bnoValue = '<c:out value ="${board.bno}"/>';
		
		/* replyService.add(
			{reply : "JS TEST", replyer : "tester", bno : bnoValue},
			
			function(result){
				alert("RESULT : " + result);
			}
		) */ 
		
		/* replyService.getList({bno:bnoValue, page:1},function(list){
			for(let i = 0, len = list.length || 0; i<len; i++){
				console.log(list[i]);
			}
		}); */
		
		/* replyService.remove(47, function(count){
			console.log(count);
			
			if(count === "success"){
				alert("REMOVED");
			}
		}, function(err){
			alert('ERROR...');
		}); */
		
		/* replyService.update({
			rno : 36,
			reply : "Modified Reply..."
		}, function(result){
			alert("수정 완료..");
		}); */
		
		/* replyService.get(41, function(data){
			console.log(data);
		}); */
		
	});
</script>
      
<script>
	$(document).ready(function(){
	   
	   
	   let operForm = $("#operForm");
	   
	   $("button[data-oper='modify']").on("click", function(e) {
			
			operForm.attr("action", "/board/modify").submit();
		});
	   
	   		$("button[data-oper='list']").on("click", function(e) {
	   		
	   			operForm.find("#bno").remove();
				operForm.attr("action", "/board/list").submit();
	   });
	});
</script>
      
          <%@include file="../includes/footer.jsp" %>

