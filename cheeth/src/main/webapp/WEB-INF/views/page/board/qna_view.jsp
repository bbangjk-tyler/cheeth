<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script type="text/javascript">
	
	const MAX_UPLOAD_CNT = 10;
	const defaultImgSrc = '/public/assets/images/profile_image.svg';

	var writingModal;
	
	var uploadImgArr = new Array();
	var realUploadImgArr = new Array();
	
	$(function() {
		
		const level = '${BOARD.BOARD_LEVEL}';
		const replyCnt = '${fn:length(REPLY_LIST)}';
		$('input[id=BOARD_LEVEL]').val(+level + 1);
  	$('input[id=BOARD_GROUP_ORDR]').val(+replyCnt > 0 ? +replyCnt + 1 : 0);
		
		writingModal = new bootstrap.Modal(document.getElementById('writingModal'));
		
		var writingModalEl = document.getElementById('writingModal');
		writingModalEl.addEventListener('hidden.bs.modal', function(e) {

		});
		
		var picAttachModalEl = document.getElementById('picAttachModal');
		picAttachModalEl.addEventListener('hidden.bs.modal', function() {
			closePicAttachModal();
		});
		
		picAttachModalEl.addEventListener('show.bs.modal', function() {
			uploadImgArr = [...realUploadImgArr];
		});
		
		picAttachModalEl.addEventListener('shown.bs.modal', function() {
			if(isNotEmpty(uploadImgArr)) {
				uploadImgArr.map((m, i) => {
					const target = $('.qna_pic_attatchment_sub_pic_upload').eq(i);
					target.addClass('active');
					target.css('background-image', 'url(' + m.IMG_SRC + ')')
					target.append('<img class="qna_pic_attatchment_remove_button" src="/public/assets/images/dialog_close_button.svg" onclick="removeImage(this);"/>');
				});
			}
		});
		
		$('.qna_pic_attatchment_sub_pic_upload').on('click', function() {
			if($(this).hasClass('active')) {
				const elIndex = $('.qna_pic_attatchment_sub_pic_upload').index($(this));
				$('#mainPicImage').attr('src', uploadImgArr[elIndex]['IMG_SRC']);
			}
		});
	});
	
	function fnSave() {
		
		if(isEmpty($('#BOARD_TITLE').val().trim())) {
			alert('제목을 입력해주세요.');
			return;
		}

		if(isEmpty($('#BOARD_CONTENT').val().trim())) {
			alert('내용을 입력해주세요.');
			return;
		}
	 	
	 	var formData = new FormData(document.getElementById('saveForm'));
	 	for(var key of formData.keys()) {
	 		formData.set(key, JSON.stringify(formData.get(key)));
	 	}
	 	
	 	const content = $('#BOARD_CONTENT').val().replace(/(\n|\r|\n)/g, '<br>');
	 	formData.set('BOARD_CONTENT', JSON.stringify(content));
		realUploadImgArr.map(m => { formData.append('files', m.FILE); });
		formData.append('fileDiv', JSON.stringify('${BOARD.BOARD_TYPE}'));
		formData.append('path', JSON.stringify(commonCreateRandomKey()));
		
	 	$.ajax({
	    url: '/' + API + '/board/save',
	    type: 'POST',
	    data: formData,
	    cache: false,
	    async: false,
	    contentType: false,
		  processData: false,
	    success: function(data) {
			  if(data.result == 'Y') {
				  alert('저장되었습니다.');
				  writingModal.hide();
				  closeWritingModal();
				  location.href = '/' + API + '/board/list?BOARD_TYPE=${BOARD.BOARD_TYPE}';
			  }
	    },
	    complete: function() {}, 
	    error: function() {}
	  });
	}
	
	function previewImage() {
		if(uploadImgArr.length >= MAX_UPLOAD_CNT) {
			alert('최대 ' + MAX_UPLOAD_CNT + '장까지 업로드 가능합니다.');
			return;
		}
		
		const file = event.target.files[0];
		if(isNotEmpty(file)) {
			const type = file.type;
			const mimeTypeList = [ 'image/png', 'image/jpeg', 'image/gif', 'image/bmp' ];
			if(mimeTypeList.includes(type)) {
				const reader = new FileReader();
				reader.readAsDataURL(file);
				reader.onload = (event) => {
					const imageSrc = event.target.result;
					$('#mainPicImage').attr('src', imageSrc);
					
					uploadImgArr.push({ 'FILE' : file, 'IMG_SRC' : imageSrc });
					const target = $('.qna_pic_attatchment_sub_pic_upload').eq(uploadImgArr.length-1);
					target.addClass('active');
					target.css('background-image', 'url(' + imageSrc + ')')
					target.append('<img class="qna_pic_attatchment_remove_button" src="/public/assets/images/dialog_close_button.svg" onclick="removeImage(this);"/>');
				};
			}
		}
	}
	
	function removeImage(elm) {
		const imageDiv = $(elm).parent();
		
		uploadImgArr = uploadImgArr.filter((v, i) => {
			if(i == imageDiv.index()) return false;
			else return true;
		});
		
		$('.qna_pic_attatchment_sub_pic_upload').each(function(index, item) {
			if(uploadImgArr[index]) {
				$(item).css('background-image', 'url(' + uploadImgArr[index]['IMG_SRC'] + ')');
			} else {
				$(item).removeClass('active');
				$(item).css('background-image', '');
				$(item).find('.qna_pic_attatchment_remove_button').remove();
			}
		});
		event.stopPropagation();
	}
	
	function fnUpload() {
		
		realUploadImgArr = [...uploadImgArr];
		
		if(isEmpty(realUploadImgArr)) {
			inactiveImageSlider();
		} else {
			activeImageSlider();
		}
	}
	
	function cleanImageSlider() {
		$('.carousel-indicators').find('button').remove();
		$('.carousel-inner').find('.carousel-item').remove();
	}
	
	function activeImageSlider() {
		cleanImageSlider();
		$('#imageSlider').removeClass('hidden');
		
		realUploadImgArr.map((m, i) => {
			var innerHTML = '';
			innerHTML += '<button type="button" data-bs-target="#imageSlider" data-bs-slide-to="' + i + '"';
			innerHTML += (i == 0 ? ' class="active" ' : '') + 'aria-current="true" aria-label="Slide ' + (i+1) + '"></button>';
			$('#imageSlider > .carousel-indicators').append(innerHTML);
			
			innerHTML = '';
			innerHTML += '<div class="carousel-item w-100 h-100' + (i == 0 ? ' active' : '') + '">';
			innerHTML += '	<img src="'+ m.IMG_SRC +'" class="d-block w-100 h-100" alt="' + m.FILE.name + '">';
			innerHTML += '</div>';
			$('#imageSlider > .carousel-inner').append(innerHTML);
		});
	}
	
	function inactiveImageSlider() {
		cleanImageSlider();
		$('#imageSlider').addClass('hidden');
	}
	
	function closeWritingModal() {
		realUploadImgArr = [];
		$('#imageSlider').addClass('hidden');
		$('.carousel-indicators').find('button').remove();
		$('.carousel-inner').find('.carousel-item').remove();
		
		$('#BOARD_TITLE').val('');
		$('#BOARD_CONTENT').val('');
	}
	
	function closePicAttachModal() {
		uploadImgArr = [];
		$('#mainPicImage').attr('src', defaultImgSrc);
		$('.qna_pic_attatchment_sub_pic_upload').removeClass('active');
		$('.qna_pic_attatchment_sub_pic_upload').css('background-image', '');
		$('.qna_pic_attatchment_sub_pic_upload').find('.qna_pic_attatchment_remove_button').remove();
	}

</script>

<div class="qna_header">
    <p class="qna_header_typo">
        1:1 게시판
    </p>
    <div class="tribute_request_connection_location_container">
        <a href="/" class="tribute_request_connection_location_typo">
            <img class="tribute_request_connection_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"/>
        </a>
        <img class="tribute_request_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
        <div class="tribute_request_connection_location">
            <p class="tribute_request_connection_location_typo_bold">1:1 게시판</p>
        </div>
    </div>
</div>
<div class="qna_body">
    <div class="side_menu">
        <div class="side_menu_title">
            <p class="side_menu_title_typo">
                전체보기
            </p>
        </div>
        <a href="/${api}/board/list?BOARD_TYPE=NOTICE" class="side_menu_list">
            <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
            <p class="side_menu_list_typo">공지사항</p>    
        </a>
        <a href="/${api}/board/list?BOARD_TYPE=FAQ" class="side_menu_list">
            <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
            <p class="side_menu_list_typo">FAQ</p>    
        </a>
        <a href="/${api}/board/list?BOARD_TYPE=QNA" class="side_menu_list">
            <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
            <p class="side_menu_list_typo_blue">1:1게시판</p>
        </a>
    </div>
    <div class="qna_view_main_container">
      <div class="qna_top_divider"></div>
      <div class="qna_title">
          <p class="qna_title_typo">${BOARD.BOARD_TITLE}</p>
          <div class="qna_sub_title">
              <p class="qna_sub_title_typo">작성일 : ${BOARD.CREATE_DATE}</p>
              <p class="qna_sub_title_typo">조회수 : ${BOARD.HITS_COUNT}</p>
          </div>
      </div>
      <div class="main_container_divider without_margin"></div>
      <div class="qna_context" style="height: auto; min-height: 308px;">
	      <p id="content_wrapper" class="qna_context_typo">
	      	<c:forEach items="${IMG_FILE_LIST}" var="image">
	      		<img alt="${image.FILE_ORIGIN_NM}" src="/upload/${image.FILE_DIRECTORY}" style="max-width: 100%; margin-bottom: 20px;">
	      	</c:forEach>
	      	${BOARD.BOARD_CONTENT}
	      </p>
      </div>
      <div class="main_container_divider"></div>
      <div class="qna_view_button_container">
        <a href="#writingModal" class="qna_view_button_blue" data-bs-toggle="modal">
          <p class="qna_view_button_blue_typo">답글 쓰기</p>
        </a>
        <a href="/${api}/board/list?BOARD_TYPE=${BOARD.BOARD_TYPE}" class="qna_view_button_white">
          <p class="qna_view_button_white_typo">목록</p>
        </a>
      </div>
        
      <div class="modal fade" id="writingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered">
			    <div class="modal-content" style="width: fit-content;">
					  <div class="qna_writing_container">
				      <div class="qna_writing_header">
				          <p class="qna_writing_header_typo">답글 쓰기</p>
				          <a href="javascript:void(0)" data-bs-dismiss="modal" aria-label="Close" onclick="closeWritingModal();">
				            <img class="qna_writing_dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
				          </a>
				      </div>
				      <div class="header_divider"></div>
				      <div class="qna_writing_body">
				      <form id="saveForm" name="saveForm" method="post">
				      	<input type="hidden" name="UP_BOARD_SEQ" id="UP_BOARD_SEQ" value="${BOARD.BOARD_SEQ}" />
				  			<input type="hidden" name="BOARD_GROUP_ID" id="BOARD_GROUP_ID" value="${BOARD.BOARD_GROUP_ID}" />
				  			<input type="hidden" name="BOARD_LEVEL" id="BOARD_LEVEL"/>
				  			<input type="hidden" name="BOARD_GROUP_ORDR" id="BOARD_GROUP_ORDR"/>
				      	<input type="hidden" name="BOARD_TYPE" id="BOARD_TYPE" value="${BOARD.BOARD_TYPE}" />
				      	
				        <input class="qna_writing_title_input" type="text" name="BOARD_TITLE" id="BOARD_TITLE" placeholder="제목입력" />
				        
					      <div id="imageSlider" class="carousel slide qna_writing_image_slider_wrapper hidden" data-bs-wrap="false" data-bs-interval="false">
					       	<div class="carousel-indicators">
								  </div>
								  <div class="carousel-inner h-100">
								  </div>
								  <button class="carousel-control-prev" type="button" data-bs-target="#imageSlider" data-bs-slide="prev">
								    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
								    <span class="visually-hidden">Previous</span>
								  </button>
								  <button class="carousel-control-next" type="button" data-bs-target="#imageSlider" data-bs-slide="next">
								    <span class="carousel-control-next-icon" aria-hidden="true"></span>
								    <span class="visually-hidden">Next</span>
								  </button>
								</div>
				        
				        <textarea class="qna_writing_context_input" name="BOARD_CONTENT" id="BOARD_CONTENT" placeholder="내용을 입력하세요"></textarea>
				        <div class="qna_writing_button_wrapper">
				          <a href="#picAttachModal" class="qna_writing_button_white" data-bs-toggle="modal">
				            <p class="qna_writing_button_white_typo">사진첨부</p>
				          </a>
				          <div class="qna_writing_button_container">
				            <a href="javascript:void(0)" class="qna_writing_button_blue" onclick="fnSave();">
				              <p class="qna_writing_button_blue_typo">글쓰기</p>
				            </a>
				          </div>
				        </div>
				      </form>
				      </div>
				    </div>
			    </div>
			  </div>
			</div>
		
			<div class="modal fade" id="picAttachModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel2" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content" style="width: fit-content;">
						<div class="qna_pic_attachment_container">
			          <div class="qna_pic_attachment_header">
			              <p class="qna_pic_attachment_header_typo">사진 첨부</p>
			              <a href="#writingModal" data-bs-toggle="modal">
			              	<img class="qna_pic_attatchment_close_button" src="/public/assets/images/dialog_close_button.svg"/>
			              </a>
			          </div>
			          <div class="qna_pic_attachment_body">
			              <p class="qna_pic_attachment_title">사진 업로드</p>
			              <p class="qna_pic_attachment_sub_title">최대 10장까지 업로드 가능합니다.</p>
			              <div class="qna_pic_attatchment_pic_upload_container">
			                <div class="qna_pic_attatchment_main_pic_upload_wrapper">
			                  <img class="qna_pic_attatchment_main_pic_upload" id="mainPicImage" src="/public/assets/images/profile_image.svg" style="width: 100%; height: 100%;"/>
			                </div>
			                <div style="display: flex;">
			                	<button class="qna_pic_attachment_pic_upload_button">
			                  	<p class="qna_pic_attachment_pic_upload_button_typo">이미지 업로드</p>
			                  </button>
			                <input type="file" name="IMG_FILE" id="IMG_FILE" onchange="previewImage();" />
			              </div>
			              </div>
			              <div class="qna_pic_attatchment_sub_pic_upload_wrapper">
			                  <!-- hidden과 invisible로 조절 -->
			                  <div class="qna_pic_attatchment_sub_pic_upload_container">
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                  </div>
			                  <div class="qna_pic_attatchment_sub_pic_upload_container">
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                    <div class="qna_pic_attatchment_sub_pic_upload"></div>
			                  </div>
			              </div>
			              <div class="main_container_divider"></div>
			              <div class="qna_pic_attatchment_button_container">
			                  <a href="#writingModal" class="qna_pic_attatchment_button_white" data-bs-toggle="modal">
			                  	<p class="qna_pic_attatchment_button_white_typo">취소</p>
			                  </a>
			                  <a href="#writingModal" class="qna_pic_attatchment_button_blue" data-bs-toggle="modal" onclick="fnUpload();">
			                  	<p class="qna_pic_attatchment_button_blue_typo">업로드</p>
			                  </a>
			              </div>
			          </div>
			      	</div>
					</div>
				</div>
			</div>
        
      <div class="qna_reply_container ${empty REPLY_LIST ? 'hidden' : ''}">
          <!-- 답글 유무에 따라 hidden으로 조절 -->
          <p class="qna_reply_typo">이 글의 답글</p>
          <c:forEach items="${REPLY_LIST}" var="item">
          <div class="qna_reply">
            <div class="qna_reply_left_container">
          		<a href="/${api}/board/view?BOARD_TYPE=${item.BOARD_TYPE}&BOARD_SEQ=${item.BOARD_SEQ}" class="qna_list_title" style="padding-left: 0;">
                <div class="qna_list_reply">
                  <p class="qna_list_reply_typo">Re</p>
                </div>
                  <p class="qna_reply_title">${item.BOARD_TITLE}</p>
            	</a>
            </div>
            <p class="qna_reply_date_wrote">${item.CREATE_DATE}</p>
          </div>
          <div class="qna_reply_divider"></div>
          </c:forEach>
      </div>
    </div>
</div>