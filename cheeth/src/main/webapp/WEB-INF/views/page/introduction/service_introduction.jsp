<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- <c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if> --%>
		<div class="sub_header sub_header_service">
			<div class="sub_header_service_inner">
				<p class="sub_header_typo">서비스 소개</p>
				<div class="sub_location_container">
					<a href="/" class="sub_location_typo"><img class="sub_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"></a>
					<img class="sub_location_arrow" src="/public/assets/images/connection_location_arrow.svg">
					<div><p class="sub_location_typo_bold">서비스 소개</p></div>
				</div>
			</div>
		</div>
	<div class="sub_service_wrap">

		<div class="sub_service_head">Welcome to <b>DENTNER!</b></div>

		<div class="sub_service_text">
			덴트너(Dentner)는 “의뢰인 회원”과 “치자이너(CAD 디자이너) 회원” 간의<br>
			국내·외 디지털 치과보철물 스캔(Scan data)파일과 CAD(Computer Aided Design) 파일의<br>
			<b>거래를 중개 하는 온라인 플랫폼</b>입니다.
		</div>

		<ul class="sub_service_list">
			<li>
				<em>01</em>
				<strong>‘무료중개소’ 입니다.</strong>
				<span>국내 치과의사, 치과기공사라면<br>누구나 이용하실 수 있습니다.</span>
			</li>
			<li>
				<em>02</em>
				<strong>다양한 중개 서비스</strong>
				<span>Scan-CAD file 중개<br>지역별 전문 가공센터 소개<br>장비 최저가 구매 입찰 서비스 등</span>
			</li>
			<li>
				<em>03</em>
				<strong>시간과 장소에<br>구애 받지 않습니다.</strong>
				<span>국내는 물론 해외의 고객을<br>만날 수 있는 기회!</span>
			</li>
		</ul>

		<div class="sub_service_process_title">Process Flow</div>
		<div class="sub_service_process_head">
			<div class="inner_text"><p>의뢰인 회원</p></div>
			<div class="inner_image"></div>
			<div class="inner_text"><p>치자이너 회원<br><span>(CAD 디자이너)</span></p></div>
		</div>
		<div class="sub_service_process_list">

			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico1.png" alt=""></div>
				<div class="inner_title">전자치과기공물 의뢰서 작성</div>
				<div class="inner_text">의뢰서 작성 후 “공개견적” 또는<br>원하는 치자이너 “선택 견적”을 요청</div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico2.png" alt=""></div>
				<div class="inner_title">견적서 받기</div>
				<div class="inner_text">견적요청글을 확인한 후 견적서 보내기</div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico3.png" alt=""></div>
				<div class="inner_title">견적서 확인 후 치자이너 매칭</div>
				<div class="inner_text">실시간 업데이트 되는 무료견적을 받아보고<br>원하는 치자이너와 매칭</div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico4.png" alt=""></div>
				<div class="inner_title">전자계약 및 작업 진행</div>
				<div class="inner_text">완성파일을 플랫폼에 업로드 하면<br>결제요청 메시지 발송</div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico5.png" alt=""></div>
				<div class="inner_title">전자치과기공물 의뢰서 작성</div>
				<div class="inner_text">완성된 캐드파일로 원하는 작업 진행</div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico6.png" alt=""></div>
				<div class="inner_title">후기작성</div>
				<div class="inner_text">좋은 거래 이후 서로의<br>후기를 작성하여 주세요!</div>
			</div><!-- // sub_service_process_item -->
		</div>

		<div class="sub_service_button">
			 <a href="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_의뢰인편.pdf')" class="sub_service_button_blue"><span>의뢰인 이용가이드 보기</span></a>
			 <a href="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_치자이너편.pdf')" class="sub_service_button_white"><span>치자이너 이용가이드 보기</span></a>
		</div>

		<div class="sub_service_process_tip">※ 견적서 요청시 [보철 종류 x 개수] 기준으로 견적 요청이 이루어지며, 그 외 정보는 비공개 입니다. 추후 계약 체결자만 정보 열람이 가능합니다.</div>

	</div><!-- // sub_service_wrap -->