<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


    <%@include file="../includes/header.jsp" %>

    <div class="row">
    	<div class="col-lg-12">
    		<h1 class="page-header">Board Modify Page</h1>
    	</div>
    </div>

    <div class="row">
    	<div class="col-lg-12">
    		<div class="panel panel-default">
    			<div class="panel-heading">Board Read Page</div>
    			<div class="panel-body">

    			<form role="form" action="/board/modify" method="post">
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
    				<input type="hidden" name='pageNum' value='<c:out value="${cri.pageNum }"></c:out>'>
    				<input type="hidden" name='amount' value='<c:out value="${cri.amount }"></c:out>'>
    				<input type="hidden" name="keyword" value='<c:out value="${cri.keyword }"></c:out>'>
    					<input type="hidden" name="type" value='<c:out value="${cri.type }"></c:out>'>
    					<input type="hidden" name="bno" value='<c:out value="${board.bno }"/>'>

    					

    					<div class="form-group">
    						<label>Title</label> <input class="form-control" name="title"
    						value='<c:out value="${board.title }"/>'>
    					</div>

    					<div class="form-group">
    						<label>Contents</label> <textarea class="form-control" rows="3" name="content" id="editor">
    						<c:out value="${board.content }"></c:out></textarea>
    						
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
    						value='<c:out value="${board.writer }"></c:out>' readonly="readonly">
    					</div>

    					<div class="form-group">
    						<label>RegDate</label>
    						<input class="form-control" name="regDate"
    						value='<fmt:formatDate pattern ="yyyy/MM/dd" value="${board.regdate }" />' readonly="readonly">
    					</div>

    					<div class="form-group">
    						<label>Update Date</label>
    						<input class="form-control" name="updatedDate"
    						value='<fmt:formatDate pattern ="yyyy/MM/dd" value="${board.updatedDate }" />' readonly="readonly">
    					</div>

				<sec:authentication property="principal" var="pinfo"/>
				
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer }">		
    					<button type="submit" data-oper='modify' class="btn btn-default btn-submit">Modify</button>
    					<button type="submit" data-oper='remove' class="btn btn-danger btn-submit">Remove</button>
    				</c:if>	
    			</sec:authorize>
    					<button type="submit" data-oper='list' class="btn btn-info btn-submit">List</button>

    			</form>

    			</div>
    		</div>
    	</div>
    </div>

  <style>
    .uploadResult {
      width:100%;
      background-color: gray;
    }
    .uploadResult ul{
      display:flex;
      flex-flow : row;
      justify-content : center;
      align-items: center;
    }
    .uploadResult ul li {
      list-style:none;
      padding: 10px;
      align-content:center;
      text-align:center;
    }

    .uploadResult ul li img{
      width:100px;
    }
    .uploadResult ul li span {
    	color : white;
    }

    .bigPictureWrapper {
          position: absolute;
          display : none;
          justify-content: center;
          align-items: center;
          top: 0%;
          width: 100%;
          height: 100%;
          background-color: gray;
          z-index: 100;
          background: rgba(255,255,255,0.5);
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

    <div class="row">
      <div class="col-lg-12">
        <div class="panel panel-default">

          <div class="panel-heading">Files</div>

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



    <script type="text/javascript">

    $(document).ready(function(){



    	var formObj = $("form");

    	$('.btn-submit').on("click", function(e){

    		e.preventDefault();

    		var operation = $(this).data("oper");

    		console.log(operation);

    		if(operation === 'remove'){
    			formObj.attr("action","/board/remove");
    		} else if(operation ==='list'){
    			//move to list
    			formObj.attr("action","/board/list").attr("method","get");
    			var pageNumTag = $("input[name='pageNum']").clone();
    			var amountTag = $("input[name='amount']").clone();
    			var keywordTag = $("input[name='keyword']").clone();
    			var typeTag = $("input[name='type']").clone();

    			formObj.empty();
    			formObj.append(pageNumTag);
    			formObj.append(amountTag);
    			formObj.append(keywordTag);
    			formObj.append(typeTag);

    		} else if(operation ==='modify'){
          console.log('submit clicked');

          var str = "";

          $(".uploadResult ul li").each(function(i, obj){

            var jobj = $(obj);

            console.dir(jobj);

            str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
            str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
            str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
            str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";

          });
          formObj.append(str).submit();
        }

    		formObj.submit();
    	});//end function


      //attach file showing
      (function(){

        var bno = '<c:out value="${board.bno}"></c:out>';

        $.getJSON("/board/getAttachList",{bno:bno}, function(arr){

          console.log(arr);

          var str = "";

           $(arr).each(function(i, attach){

             //image type
             if(attach.fileType){
               var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

               str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-fileName = '"+attach.fileName+"' data-type = '"+attach.fileType+"' ><div>";
               str += "<span>"+attach.fileName+"</span>";
               str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='image' ";
               str += "class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br />";
               str += "<img src='/display?fileName="+fileCallPath+"'>";
               str += "</div>";
               str += "</li>";
             } else {

               str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-fileName = '"+attach.fileName+"' data-type = '"+attach.fileType+"' ><div>";
               str += "<span> "+attach.fileName +"</span>";
               str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file' ";
               str += "class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br />";
               str += "<img src = '/resources/img/attach.png'>";
               str += "</div>";
               str += "</li>";
             }

           }); //end for
           $(".uploadResult ul").html(str);


        });//end getJSON


      })(); //end function


      $(".uploadResult").on("click","button", function(e){

        console.log("delete file");

        if(confirm("Remove this file?")){
          var targetLi = $(this).closest("li");
          targetLi.remove();
        }
      }); //end function






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
            data: formData,
            type:'POST',
            beforeSend : function(xhr){
            	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
            },
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




    });
    </script>
    <%@include file = "../includes/footer.jsp"%>
