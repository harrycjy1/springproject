<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<%@include file="../includes/header.jsp"%>

<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}

.uploadResult ul li img {
	width: 100px;
}

.uploadResult ul li span {
	color: white;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255, 255, 255, 0.5);
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}
</style>
<form role="form" action="/board/register" method="post">
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Register</div>
			<div class="panel-body">

					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token }" />
					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title">
					</div>

					<div class="form-group">
						<label>Text area</label>
						<textarea name="content" id="editor"></textarea>
						<script>

                ClassicEditor
                .create( document.querySelector( '#editor' ), {

                    toolbar: [ 'Heading','Link','bold', 'italic', 'bulletedList', 'numberedList', 'blockQuote','undo','redo' ]
                } )
                .then( newEditor => {
  					 editor = newEditor;
  					editor.ui.view.editable.editableElement.style.height = '250px'; // textarea 크기 설정
					} )
                .catch( error => {
                    console.log( error );
                } );


                </script>
					</div>

					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer"
							value='<sec:authentication property="principal.username"></sec:authentication>'
							readonly="readonly">
					</div>

			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">File Attach</div>
			<div class="panel-body">

				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>

				<div class="uploadResult">
					<ul>

					</ul>
				</div>

			</div>
		</div>
	</div>

</div>
  <div class="row">
    <div class="col-lg-12">
      <div class="panel panel-default">
        <div class="panel-body" align="middle">
        <button type="submit" class="btn btn-primary">Submit</button>
        </div>
      </div>
    </div>
  </div>
</form>

<script type="text/javascript">
	$(document).ready(function(e){



        var formObj = $("form[role='form']");

        $("button[type='submit']").on('click',function(e){
          e.preventDefault;

          console.log("submit clicked");

          var str = "";

          $(".uploadResult ul li").each(function(i,obj){

            var jobj = $(obj);

            console.dir(jobj);



            str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
            str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
            str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
            str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
          });

          formObj.append(str).submit();

        });



        //extension check
        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
          var maxSize = 5242880; //5MB

          function checkExtension(fileName, fileSize){
            if(fileSize >= maxSize){
              alert("파일 사이즈 초과");
              return false;
            }

            if(regex.test(fileName)){
              alert("해당종류의 파일은 업로드 할 수 없습니다.")
              return false;
            }
            return true;
          }



		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";

          $("input[type='file']").change(function(e){

            var formData = new FormData();

            var inputFile = $("input[name='uploadFile']");
			
            var files = inputFile[0].files;

            for(var i=0; i<files.length; i++){

              if(!checkExtension(files[i].name, files[i].size)){
                return false;
              }
              formData.append("uploadFile", files[i]);
            }

            $.ajax({
              url: '/uploadAjaxAction',
              processData : false,
              contentType: false,
              beforeSend : function(xhr) {
            	  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
              },
              data: formData,
              type:'POST',
              dataType:'json',
              success: function(result){
                console.log(result);
                showUploadResult(result);
              }
            });//Ajax

          });//change function


          function showUploadResult(uploadResultArr){

            if(!uploadResultArr || uploadResultArr.length ==0){return;}

            var uploadUL = $(".uploadResult ul");
            var str = "";

            $(uploadResultArr).each(function(i, obj){

                if(obj.image){
                  var fileCallPath = encodeURIComponent(obj.uploadPath +"/s_"+obj.uuid+"_"+obj.fileName);
                    str += "<li data-path='"+obj.uploadPath+"'";
                    str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
                    str += " ><div>"
                    str += "<span> "+obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type ='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/display?fileName="+fileCallPath+"'>";
                    str += "</div>";
                    str += "</li>";

				} else {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

					str += "<li data-path='"+obj.uploadPath+"'";
                    str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
                    str += " ><div>"
					str += "<span> " + obj.fileName + "</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type ='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
                }

            });

            uploadUL.append(str);
          } // showupload function

          //delete
          $(".uploadResult").on("click","button",function(e){

        	  console.log("delete file");
        	
        	var targetFile = $(this).data("file");
            var type = $(this).data("type");

            var targetLi = $(this).closest("li");
            
            console.log(targetFile+"::::"+ type);

            var check = confirm("sure?");

            console.log(check);

            if(check==true){
              $.ajax({
                url : '/deleteFile',
                data : {fileName : targetFile, type : type},
                beforeSend : function(xhr) {
              	  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                },
                dataType : 'text',
                type : 'POST',
                success : function(result){
                  targetLi.remove();
                  
                }

              }); //$.Ajax
            }


          }); //delete function

      });
	  </script>


<%@include file="../includes/footer.jsp"%>
