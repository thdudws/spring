<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
	body {
		margin : 0px;
	}

	.uploadResult {
	   width: 100%;
	   background-color: gray;
	}
	
	.uploadResult ul {
	   display: flex;
	   flex-flow: row;
	   justify-content: center;
	   align-items: center;
	   padding : 0px;
	}
	
	.uploadResult ul li {
	   list-style: none;
	   padding: 10px;
	}
	
	.uploadResult ul li img {
	   width: 100px;
	   height : auto;
	}
	
	.uploadResult ul li span {
    	color: white;
	}
</style>

<style>
	.bigPictureWrapper {
	  position: absolute;
	  display: none;
	  justify-content: center;
	  align-items: center;
	  top:0%;
	  width:100%;
	  height:100%;
	  background-color: gray; 
	  z-index: 100;
	  background : rgba(255,255,255,0.5);
	}
	
	.bigPicture {
	  position: relative;
	  display:flex;
	  justify-content: center;
	  align-items: center;
	}
	
	.bigPicture img {
		width:600px;
	}
	
	.bigPicture img:hover {
		cursor: pointer;
	}
</style>

</head>
<body>

	<h1>UploadAjax</h1>

	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple="multiple">
	</div>
	
	<button id="uploadBtn">Upload</button>
	
	<div class="uploadResult">
		<ul>
		</ul>
	</div>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
	<script type="text/javascript">
	
	function showImage(fileCallPath) {
		//alert(fileCallPath);
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%', height:'100%'},1000);
		
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPicture").animate({width:'0%', height:'0%'},1000);
			setTimeout(()=>{
				$(this).hide();
			}, 1000);
		});
		
	}; //end showImage
	
		$(document).ready(function(){
			
			let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			let maxSize = 5242880; //5MB
			
			function checkExtension(fileName, fileSize) {
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				
				if(regex.test(fileName)){
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				return true;
			}	//end checkExtension
			
			let cloneObj = $(".uploadDiv").clone();
			
			$("#uploadBtn").on("click", function(e){
				
				let formData = new FormData();
				
				let inputFile = $("input[name='uploadFile']");
				let files = inputFile[0].files;
				
				console.log(files);
				
				for(let i=0; i<files.length; i++){
					if(!checkExtension(files[i].name, files[i].size)){
						return false;
					}	
					formData.append("uploadFile", files[i]);
				}
				
				
				//제이쿼리 ajax로 파일 전송
				$.ajax({
					url: '/uploadAjaxAction',
					processData : false,
					contentType : false,
					data : formData,
					type : 'POST',
					dataType: 'json',
					success : function(result){
						
						console.log(result);
						
						showuploadFile(result);
						
						$(".uploadDiv").html(cloneObj.html());
					}
				}); //$.ajax
				
			}); //end uploadBtn
			
			let uploadResult = $(".uploadResult ul");
			function showuploadFile(uploadResultArr){
				
				let str = "";
				
				$(uploadResultArr).each(function(i, obj){
					
					if(!obj.image){
						
						let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						
						str += "<li><a href='/download?fileName="+fileCallPath+"'>"
								+"<img src='/resources/img/attach.png'>"
						+obj.fileName + "</a></li>";

					}else {
						//이미지 파일인 경우
						//str += "<li>" + obj.fileName + "</li>";
						
						//파일 이름의 공백이나 한글이름 처리 
						let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
						
						let originPath = obj.uploadPath + "\\" +obj.uuid + "_" + obj.fileName;
						
						console.log("originPath B : " + originPath);
						
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						
						console.log("originPath A : " + originPath);
						
						str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src= '/display?fileName="+fileCallPath+"'></a></li>";
					}
				});
				
				uploadResult.append(str);
			}	//end showuploadFile
			
			
		});
	</script>
	

</body>
</html>