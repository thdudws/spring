<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
	<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>	
	  
    <%@include file="../includes/header.jsp" %>
   
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
               Board Register
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <form action="/board/register" method="post" role="from">
                	<div class="form-group">
                		<label>Title</label><input class="form-control" name="title" />
                	</div>
                	<div class="form-group">
                		<label>Text area</label>
                		<textarea class="form-control" rows="3" name="content"></textarea>
                	</div>
                	<div class="form-group">
                		<label>Writer</label><input class="form-control" name="writer"
                		value='<sec:authentication property="principal.username"/>' readonly="readonly"/>
                	</div>
                	<button type="submit" class="btn btn-default">Submit</button>
                	<button type="reset" class="btn btn-default">Reset Button</button>
                </form>
               
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div> <!-- end row -->

    <%@include file="../includes/footer.jsp" %>

