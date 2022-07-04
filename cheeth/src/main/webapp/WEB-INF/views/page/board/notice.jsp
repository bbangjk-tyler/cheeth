<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
  	var locations = document.location.href;
  	locations += ""; 
  	if (locations.includes('http://www.')) {
          document.location.href = document.location.href.replace('http://www.', 'https://');
     }else if(locations.includes('http:')){
    	 document.location.href = document.location.href.replace('http:', 'https:');
     }else if(locations.includes('https://www.')){
    	 document.location.href = document.location.href.replace('https://www.', 'https://');
     }
</script>
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
		
		fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 10);
		
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
	
	function fnSearch() {
		var page = arguments[0];
		var url = '/' + API + '/board/list';
		url += '?PAGE=' + page ;
		url += '&BOARD_TYPE=' + encodeURI('${BOARD_TYPE}');
		url += '&SEARCH_TXT=' + encodeURI($('#SEARCH_TXT').val());
		location.href = url;
	}
	
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
		formData.append('fileDiv', JSON.stringify('${BOARD_TYPE}'));
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
				  location.href = '/' + API + '/board/list?BOARD_TYPE=${BOARD_TYPE}';
			  }
	    }, complete: function() {
	    
	    }, error: function() {
	      
	    }
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

<div class="notice_header">
	<p class="notice_header_typo">
		공지사항
	</p>
  <div class="tribute_request_connection_location_container">
	  <a href="/" class="tribute_request_connection_location_typo">
	    <img class="tribute_request_connection_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"/>
	  </a>
	  <img class="tribute_request_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	  <div class="tribute_request_connection_location">
	    <p class="tribute_request_connection_location_typo_bold">공지사항</p>
	  </div>
  </div>
</div>
<div class="notice_body">
	<div class="side_menu">
		<div class="side_menu_title">
			<p class="side_menu_title_typo">
				전체보기
		  </p>
		</div>
		<a href="/${api}/board/list?BOARD_TYPE=NOTICE" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo_blue">공지사항</p>    
    </a>
    <a href="/${api}/board/list?BOARD_TYPE=FAQ" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">FAQ</p>    
    </a>
    <a href="/${api}/board/list?BOARD_TYPE=QNA" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">1:1게시판</p>    
    </a>
	</div>
	<div class="notice_main_container">
	  <div class="notice_top_divider"></div>
	  <div class="notice_list_container">
	    <div class="notice_list_data_type_container">
	      <div class="notice_list_data_type_order">
	        <p class="notice_list_data_type_order_typo">NO</p>
	      </div>
	      <div class="notice_list_data_type_title">
	        <p class="notice_list_data_type_title_typo">제목</p>
	      </div>
	      <div class="notice_list_data_type_date">
	        <p class="notice_list_data_type_typo">등록일</p>
	      </div>
	    </div>
	    <c:forEach items="${LIST}" var="item">
		  	<div class="list_divider"></div>
		  	<div class="notice_list">
		    	<div class="notice_list_order">
		        <p class="notice_list_typo">${item.RN}</p>
		      </div>
		      <a href="/${api}/board/view?BOARD_TYPE=${item.BOARD_TYPE}&BOARD_SEQ=${item.BOARD_SEQ}" class="notice_list_title">
		        <p class="notice_list_typo">${item.BOARD_TITLE}</p>
		      </a>
		      <div class="notice_list_date">
		        <div class="notice_list_typo">${item.CREATE_DATE}</div>
		      </div>
		    </div>
		  </c:forEach>
		  <c:if test="${empty LIST}">
		  	<div class="list_divider"></div>
		  	<div class="notice_list">
		    	<div class="notice_list_order">
		        <p class="notice_list_typo"></p>
		      </div>
		      <div class="notice_list_title" style="padding-left: 285px;">
			      <p class="notice_list_typo">등록된 게시글이 없습니다.</p>
		      </div>
		      <div class="notice_list_date">
		        <div class="notice_list_typo"></div>
		      </div>
		    </div>
		  </c:if>
	    <div class="list_divider"></div>
	    
	    <a href="#writingModal" class="qna_writing_button" data-bs-toggle="modal">
        <img class="qna_writing_button_icon" src="/public/assets/images/writing_button.svg">
        <p class="qna_writing_button_typo">
          글쓰기
        </p>
      </a>
	  </div>
	  
	  <div class="modal fade" id="writingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered">
		    <div class="modal-content" style="width: fit-content;">
				  <div class="qna_writing_container">
			      <div class="qna_writing_header">
			          <p class="qna_writing_header_typo">글쓰기</p>
			          <a href="javascript:void(0)" data-bs-dismiss="modal" aria-label="Close" onclick="closeWritingModal();">
			            <img class="qna_writing_dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
			          </a>
			      </div>
			      <div class="header_divider"></div>
			      <div class="qna_writing_body">
			      <form id="saveForm" name="saveForm" method="post">
			      	<input type="hidden" name="BOARD_TYPE" id="BOARD_TYPE" value="${BOARD_TYPE}" />
			      	<input type="hidden" name="BOARD_LEVEL" id="BOARD_LEVEL" value="0" />
			      	<input type="hidden" name="BOARD_GROUP_ORDR" id="BOARD_GROUP_ORDR" value="0" />
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
		
		<div class="qna_sub_container">
			<div class="pagination"></div>
      <div class="search">
        <div class="search_field_wrapper">
          <button class="search_field">
            <p class="search_field_typo">전체</p>
            <img class="search_field_arrow" src="/public/assets/images/search_field_arrow.svg"/>
          </button>
          <div class="dropbox_search_field_select_button_item_wrapper hidden">
            <div class="dropbox_search_field_select_button_item_container">
              <div class="dropbox_search_field_select_button_item">
                <p class="dropbox_search_field_select_button_item_typo">닉네임 찾기</p>
              </div>
            </div>
          </div>
        </div>
        <input class="search_bar" id="SEARCH_TXT" name="SEARCH_TXT" maxlength="20" value="${SEARCH_TXT}" />
        <button class="search_button" style="cursor: pointer;" onclick="fnSearch('${PAGE}');">
          <img class="Search_button_icon" src="/public/assets/images/search_button_icon.svg"/>
          <p class="search_button_typo">검색</p>
        </button>
      </div>
    </div>
		
	</div>
</div>