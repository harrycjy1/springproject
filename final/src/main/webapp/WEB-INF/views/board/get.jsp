<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<div class="panel-body">

				<%-- <div class="form-group">
					<label>Bno</label> <input class="form-control" name="bno"
						value='<c:out value="${board.bno }"/>' readonly="readonly">
				</div> --%>

				<div class="form-group">
					<label>Title</label> <input class="form-control" name="title"
						value='<c:out value="${board.title }"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>Contents</label>
					<textarea class="form-control" rows="3" name="content" id="editor"
						readonly="readonly"><c:out value="${board.content }"></c:out></textarea>
					<script>

               	 		ClassicEditor
                		.create( document.querySelector('#editor'))
               	 		.then( newEditor => {
       					 editor = newEditor;
       					 editor.ui.view.editable.editableElement.style.height = '250px';
       					 editor.isReadOnly = true;
    					} )
                		.catch( error => {
                   		console.log( error );
                		} );


                </script>

				</div>

				<div class="form-group">
					<label>Writer</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer }"></c:out>'
						readonly="readonly">
				</div>

				<sec:authentication property="principal" var="pinfo" />

				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer }">
						<button data-oper='modify' class="btn btn-default">Modify</button>
					</c:if>
				</sec:authorize>

				<button data-oper='list' class="btn btn-default">List</button>


				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno"
						value='<c:out value="${board.bno }"></c:out>'> <input
						type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum }"></c:out>'> <input
						type="hidden" name="amount"
						value='<c:out value="${cri.amount }"></c:out>'> <input
						type="hidden" name="keyword"
						value='<c:out value="${cri.keyword }"></c:out>'> <input
						type="hidden" name="type"
						value='<c:out value="${cri.type }"></c:out>'>
				</form>

			</div>
		</div>
	</div>
</div>

<%-- attachFile --%>
<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

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

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">Files</div>

			<div class="panel-body">

				<div class="uploadResult">
					<ul>

					</ul>
				</div>
			</div>
		</div>
	</div>
</div>



<%-- reply --%>
<div class="row">
	<div class="col-lg-12">
		<%-- /.panel --%>
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New
						Reply</button>
				</sec:authorize>
			</div>


			<%-- /.panel-heading --%>
			<div class="panel-body">
				<ul class="chat">
					
				</ul>
				<%-- end ul --%>
			</div>
			<div class="panel-footer"></div>
			<%-- /.panel .chat-panel --%>
		</div>
	</div>
</div>

<%-- modal --%>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label> <input class="form-control" name="reply"
						value="New Reply!">
				</div>
				<div class="form-group">
					<label>Replyer</label> <input class="form-control" name="replyer"
						value="replyer" readonly>
				</div>
				<div class="form-group">
					<label>Reply Date</label> <input class="form-control"
						name="replyDate" value="">
				</div>
			</div>

			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
			</div>
		</div>

	</div>

</div>


<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>

    $(document).ready(function(){

      var bnoValue = '<c:out value="${board.bno}"></c:out>';
      var replyUL= $(".chat");

        showList(1);

        function showList(page){

          replyService.getList({bno:bnoValue, page : page||1}, function(replyCnt,list){


            if(page == -1){
              pageNum = Math.ceil(replyCnt/10.0);
              showList(pageNum);
              return;
            }

            var str ="";
            if(list ==null || list.length ==0){
              replyUL.html("");

              return;
            }
            for(var i =0, len=list.length || 0; i <len; i++){
              str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
              str += "  <div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
              str += "    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small><div>";
              str += "      <p>"+list[i].reply+"</p></div></li>";
            }

            replyUL.html(str);

            showReplyPage(replyCnt);
          }); //end function
        }//end showlist
        
      //댓글 페이징 번호 출력
        var pageNum = 1;
        var replyPageFooter = $(".panel-footer");

        function showReplyPage(replyCnt){

          var endNum = Math.ceil(pageNum / 10.0) * 10;
          var startNum = endNum -9;

          var prev = startNum != 1;
          var next = false;

          if(endNum * 10 >= replyCnt){
            endNum  = Math.ceil(replyCnt/10.0);
          }

          if(endNum * 10 <replyCnt){
            next = true;
          }

          var str = "<ul class='pagination pull-right'>";

          if(prev){
            str += "<li class='page-item'><a class='page-link' href ='"
            + (startNum -1)+"'>Previous</a></li>";
          }

          for(var i= startNum ; i<= endNum; i++){

            var active = pageNum ==i ? "active" : "";

            str += "<li class='page-item "+active+" '><a class='page-link' href ='"
            + i+"'>"+i+"</a></li>";
          }

          if(next){
            str += "<li class='page-item'><a class='page-link' href ='"
            + (endNum + 1)+"'>Next</a></li>";
          }

          str += "</ul></div>";

          console.log(str);

          replyPageFooter.html(str);

        }
        
        replyPageFooter.on("click","li a", function(e){
            e.preventDefault(); //a태그의 기본 동작을 제한한다.
            console.log("page click");

            var targetPageNum = $(this).attr("href");

            console.log("targetPageNum : "+ targetPageNum);

            pageNum = targetPageNum;

            showList(pageNum);

          });

        var modal = $(".modal");
        var modalInputReply = modal.find("input[name='reply']");
        var modalInputReplyer = modal.find("input[name='replyer']");
        var modalInputReplyDate = modal.find("input[name='replyDate']");

        var modalModBtn = $("#modalModBtn");
        var modalRemoveBtn = $("#modalRemoveBtn");
        var modalRegisterBtn = $("#modalRegisterBtn");

        //reply authentication
        var replyer = null;

        <sec:authorize access="isAuthenticated()">

        replyer = '<sec:authentication property ="principal.username"/>';

        </sec:authorize>

        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";



        $("#addReplyBtn").on("click", function(e){

          modal.find("input").val("");
          modal.find("input[name='replyer']").val(replyer);
          modalInputReplyDate.closest("div").hide();
          modal.find("button[id != 'modalCloseBtn']").hide();

          modalRegisterBtn.show();

          $(".modal").modal("show");

        });

        //Ajax spring security header
        $(document).ajaxSend(function(e, xhr, options){
        	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
        });
        modalRegisterBtn.on("click", function(e) {

          var reply = {
            reply : modalInputReply.val(),
            replyer : modalInputReplyer.val(),
            bno:bnoValue
          };
          replyService.add(reply, function(result){
            alert(result);

            modal.find("input").val("");
            modal.modal("hide");

            // showList(1);
            showList(-1);
          })
        });

        //modal show on when reply clicked
        $(".chat").on("click","li",function(e){
          var rno = $(this).data("rno");

          replyService.get(rno, function(reply){

            modalInputReply.val(reply.reply);
            modalInputReplyer.val(reply.replyer);
            modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
            modal.data("rno", reply.rno);

            modal.find("button[id !='modalCloseBtn']").hide();
            modalModBtn.show();
            modalRemoveBtn.show();

            $(".modal").modal("show");
          });
        });

        //modify reply on modal
        modalModBtn.on("click", function(e){

       	var originalReplyer = modalInputReplyer.val();

          var reply = {
        		  		rno:modal.data("rno"),
        		  		reply : modalInputReply.val(),
        		  		replyer : originalReplyer
        			};

          if(!replyer){
        	  alert("로그인 후 수정이 가능합니다.");
        	  modal.modal("hide");
        	  return;

          }

          console.log("Original Replyer : "+ originalReplyer);

          if(replyer != originalReplyer){

        	  alert("자신이 작성한 댓글만 수정이 가능합니다.");
        	  modal.modal("hide");
        	  return;
          }

          replyService.update(reply, function(result){

            alert(result);
            modal.modal("hide");
            showList(pageNum);
          });
        });

        modalRemoveBtn.on("click",function(e) {

          var rno = modal.data("rno");

          console.log("RNO : "+rno);
          console.log("REPLYER : "+replyer);

          if(!replyer){
            alert("로그인 후 삭제가 가능합니다.");
            modal.modal("hide");
            return;
          }

          var originalReplyer = modalInputReplyer.val();

          console.log("Original Replyer : "+ originalReplyer); //댓글의 원래 작성자

          if(replyer != originalReplyer){
            alert("자신이 작성한 댓글만 삭제가 가능합니다.");
            modal.modal("hide");
            return;

          }

          replyService.remove(rno, originalReplyer, function(result){

            alert(result);
            modal.modal("hide");
            showList(pageNum);
          });
        });

        $("#modalCloseBtn").on("click",function(e){
        	modal.modal("hide");
        });



      

      



    });


    </script>





<script type="text/javascript">
      $(document).ready(function(){

        (function(){

          var bno = '<c:out value="${board.bno}"></c:out>';

          $.getJSON("/board/getAttachList", {bno:bno}, function(arr){
            console.log(arr);

            var str = "";

            $(arr).each(function(i, attach){

              //image type
              if(attach.fileType){
                var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

                str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-fileName = '"+attach.fileName+"' data-type = '"+attach.fileType+"' ><div>";
                str += "<img src='/display?fileName="+fileCallPath+"'>";
                str += "</div>";
                str += "</li>";
              } else {

            	  str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-fileName = '"+attach.fileName+"' data-type = '"+attach.fileType+"' ><div>";
            	  str += "<span> "+attach.fileName +"</span><br/>";
            	  str += "<img src = '/resources/img/attach.png'>";
            	  str += "</div>";
            	  str += "</li>";
              }

            });
            $(".uploadResult ul").html(str);

          }); //end get JSON
        })(); //end function

        //CLICK IMAGE ON
        $(".uploadResult").on("click","li",function(e){
          console.log("view image");

          var liObj = $(this);
          console.log(liObj.data("type"));

          var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));



          if(liObj.data("type")){
            showImage(path.replace(new RegExp(/\\/g),"/"));
          } else {
        	  //download
            self.location = "/download?fileName="+path
          }
        });

        //click image turn off
        $(".bigPictureWrapper").on("click",function(e){
          $(".bigPicture").animate({width:'0%', height:'0%'},1000);
          setTimeout(function(){
            $('.bigPictureWrapper').hide();
          },1000);
        });


        function showImage(fileCallPath){

          $(".bigPictureWrapper").css("display","flex").show();

          $(".bigPicture")
          .html("<img src='/display?fileName="+fileCallPath+"' />")
          .animate({width:'100%',height:'100%'}, 1000);


        }





      });
    </script>




<script type="text/javascript">
    $(document).ready(function() {

    	var operForm = $("#operForm");

    	$("button[data-oper='modify']").on("click",function(e){
    		operForm.attr("action","/board/modify").submit();
    	}); //jquery 속성 선택자

    	$("button[data-oper='list']").on("click",function(e){
    		operForm.find("#bno").remove(); //form 지우고 list에 bno는 필요없으므로
    		operForm.attr("action","/board/list"); //list get 액션 보내고
    		operForm.submit(); //제출 - > list page로 이동
    	});
    });
    </script>


<%@include file="../includes/footer.jsp"%>
