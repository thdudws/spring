<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h1>Logout Page</h1>

	<div class="col-md-4 col-md-offset-4">
		<div class="login-panel panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Logout Page</h3>
			</div>
			<div class="panel-body">
				<form role="form" action="/customLogout" method="post">
					<%-- <input type="hidden" name="${_crsf.parameterName}" value="${_csrf.token}"> --%>
					<fieldset>
						<a href="index.html" class="btn btn-lg btn-success btn-block">Logout</a>
					</fieldset>
				</form>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		$(".btn-success").on("click", function(e){
			e.preventDefault();
			$("form").submit();
		});
	</script>
		
	<c:if test="${param.logout != null }">
		<script type="text/javascript">
			$(document).ready(function(){
				alert("로그아웃 하셨습니다.");
			});
		</script>
	</c:if>

</body>
</html>