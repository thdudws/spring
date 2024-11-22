<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
	<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
	   
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
                	
                	<!-- 자신이 쓴글만 수정 가능하게 -->
                	<sec:authentication property="principal" var="pinfo"/>
                		<sec:authorize access="isAuthenticated()">
                			<c:if test="${pinfo.username eq board.writer }">
                				<button data-oper="modify" class="btn btn-default">Modify</button>
                			</c:if>
                		</sec:authorize>
                	
                	
                	
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

<!-- 댓글 처리 시작 -->
<div class="row">
    <div class="col-lg-12">
    
    	<!-- panel -->
        <div class="panel panel-default">
            <div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-success btn-xs pull-right">
						New Reply
					</button>
				</sec:authorize>
			</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
				<ul class="chat">
					
				</ul>  
				<!-- /end ul -->             
            </div>
            <div class="panel-footer text-right">
			
			</div>
            <!-- /.panel .chat-panel -->
        </div>
    </div>
    <!--/ end row -->
</div> 
<!-- 댓글 처리 끝-->
      
<!-- 댓글 모달창 -->
 <div id="myModal" class="modal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">REPLY MODAL</h5>
		
      </div>
      <div class="modal-body">
        <div class="form-group">
        	<label>Reply</label>
        	<input class="form-control" name="reply" value="New Reply!">
        </div>
        
        <div class="form-group">
        	<label>Replyer</label>
        	<input class="form-control" name="replyer" value="New Replyer!">
        </div>
        
        <div class="form-group">
        	<label>Reply Date</label>
        	<input class="form-control" name="replyDate" value="">
        </div>
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" id="modalModBtn">Modify</button>
      	<button type="button" class="btn btn-danger" id="modalRemoveBtn">Remove</button>
      	<button type="button" class="btn btn-primary" id="modalRegisterBtn">Register</button>
        <button type="button" class="btn btn-default" id="modalCloseBtn" data-dismiss="modal">Close</button>
        
      </div>
    </div>
  </div>
</div>
<!-- 댓글 모달창 -->
      
<script src="/resources/js/reply.js"></script>

<style>
	.chat>li:hover {
    	cursor: pointer;
    	opacity: 0.8;
	}
</style>

<script>	//test
	$(document).ready(function(){
		console.log("------");
		console.log("JS TEST");
		
		let bnoValue = '<c:out value ="${board.bno}"/>';
		
		let replyUL = $(".chat");
		
		showList(1);
		
		function showList(page){
			replyService.getList({bno : bnoValue, page:page || 1},
				
					function(replyCnt, list){
				
					console.log("replyCnt" + replyCnt);
					console.log("list" + list);
					
				
					if(page == -1){
						pageNum = Math.ceil(replyCnt/10.0);
						showList(pageNum);
						console.log(pageNum);
						return;
					}
				
					let str = "";
					
					if(list == null || list.length == 0){
						return;
					}
					
					//반복문
					for(let i=0, len = list.length || 0; i<len; i++){
						str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
						str += "<div class='header'>";
						str += "<strong class='primary-font'>"+list[i].replyer+"</strong>";
						str += "<small class='pull-right text-muted'>"+replyService.dispalyTime(list[i].replyDate)+"</small>";
						str += "</div>";
						str += "<p>"+list[i].reply+"</p>";
						str += "</li>";
					}
					replyUL.html(str);
					
					showReplyPage(replyCnt); //페이징처리 호출
			})
		}//end showList
	
		//start modal
		let modal = $("#myModal");
		let modalInputReply = modal.find("input[name='reply']");
		let modalInputReplyer = modal.find("input[name='replyer']");
		let modalInputReplyDate = modal.find("input[name='replyDate']");
		
		let modalModBtn = $("#modalModBtn");
		let modalRemoveBtn = $("#modalRemoveBtn");
		let modalRegisterBtn = $("#modalRegisterBtn");

		let replyer = null;
		
		<sec:authorize access="isAuthenticated()">
			replyer = '<sec:authentication property="principal.username"/>';
		</sec:authorize>
		
		$("#addReplyBtn").on("click", function(e){
			
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			
			modal.modal("show");
		});//end modal
		
		//댓글 등록
		modalRegisterBtn.on('click', function(e){

			let reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
			};
			replyService.add(reply, function(result){
				alert(result);
			
			modal.find("input").val("");
			modal.modal("hide");
			
			//showList(1);	//새로운 댓글 가져오기/댓글 목록 갱신
			showList(-1);	
			
			});
		}); //댓글 등록 끝
		
		//댓글 클릭 이벤트 처리 --> 이벤트 위임(대상 변경)
		$(".chat").on("click", "li", function(e){
			let rno = $(this).data("rno");
			//console.log(rno);
			replyService.get(rno, function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.dispalyTime(reply.replyDate))
				.attr("readonly","readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				modal.modal("show");
			});
			
		});	//readonly
		
		//댓글 수정
		modalModBtn.on("click", function(e){
			let originalReplyer = modalInputReplyer.val();
			
			let reply = {
				rno : modal.data("rno"),
				reply : modalInputReply.val(),
				replyer: originalReplyer
			};
			
			//로그인 이전 부분
			if(!replyer){
				alert("로그인 후 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			//로그인 성공 후 진입 부근
			if(replyer != originalReplyer){
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum); //페이지 유지
			});
		});
		
		//댓글 삭제
		modalRemoveBtn.on("click", function(e){
			
			let rno = modal.data("rno");
			
			//로그인 이전 부분
			if(!replyer){
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			//로그인 성공 후 진입 부근
			let originalReplyer = modalInputReplyer.val(); //댓글 작성지
			
			if(replyer != originalReplyer){
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.remove(rno, originalReplyer, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum); //페이지 유지
			});
		});
		
		//페이징 처리
		let pageNum = 1;
		let replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt){
			let endNum = Math.ceil(pageNum / 10.0) * 10;
			let startNum = endNum - 9;
			
			let prev = startNum != 1; //이전버튼
			let next = false;	//다음버튼
			
			//real page(끝 페이지 재계산)
			if(endNum * 10 >= replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			//다음버튼 유무 조건
			if(endNum * 10 < replyCnt){
				next = true;
			}
			
			let str = "<ul class='pagination'>";
	         
	         if(prev){
	            str+= "<li class='page-item'>"
	            str+= "<a class='page-link' href='"+(startNum - 1)+"'>Previous</a></li>";
	         }
	         
	         for(let i=startNum; i<=endNum; i++){
	            let active = pageNum == i? "active":"";
	            
	            str+= "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>" + i + "</a></li>";
	         }
	         
	         if(next){
	            str+= "<li class='page-item'>"
	            str+= "<a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
	         }
	         
	         str += "</ul>";
	         
	         console.log(str);
	         
	         replyPageFooter.html(str);
			
		} //end showReplyPage
		
		//페이지 번호 클릭 넘어가기
		replyPageFooter.on("click", "li a", function(e){
			e.preventDefault();
			
			let targetPageNum = $(this).attr("href");
			
			pageNum = targetPageNum;
			
			showList(pageNum);
			
		}); //end replyPageFooter
		
		
	});	
</script>

<script>	
	//test
	$(document).ready(function(){
		/* console.log("------");
		console.log("JS TEST");
		
		let bnoValue = '<c:out value ="${board.bno}"/>'; */
		
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

