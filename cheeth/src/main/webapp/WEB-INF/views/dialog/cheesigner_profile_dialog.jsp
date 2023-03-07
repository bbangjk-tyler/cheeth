<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

	                    <div class="profile_management_profile_edit_button_wrapper">
                    <a href="/api/mypage/profile_management_cheesigner" class="profile_management_profile_edit_button">
                        <p class="profile_management_profile_edit_button_typo"><spring:message code="prof.editP" text="프로필 수정하기" /></p>
                    </a>
                </div>
	    <div class="connection_location_divider"></div>
               <div class="profile_management_profile_container">
                    <div class="profile_management_profile_item basic_info">
                        <div class="profile_management_profile_info_container">
                 <c:choose>
                  <c:when test="${empty DATA.DATA_02.PROFILE_FILE_CD}">
                   <div class="profile_management_profile_pic_upload"></div>
                  </c:when>
                  <c:otherwise>
                  <div class="profile_management_profile_pic_upload">
                  <img id="PROFILE_FILE" class="profile_management_writing_profile_pic_upload" src="/upload/${DATA.DATA_02.PROFILE_FILE_DIRECTORY}" alt="${DATA.DATA_02.PROFILE_FILE_ORIGIN_NM}">
                  </div>
                  </c:otherwise>
                </c:choose>
                            <div class="profile_management_profile_info_typo_container">
                                <p class="profile_management_profile_info_name">${DATA.DATA_01.USER_NICK_NAME}</p>
                                <div class="profile_management_profile_info_sub_info_container">
                                    <p class="profile_management_profile_info_sub_info_title"><spring:message code="tesign.memb" text="회원구분" /></p>
                                    <p class="profile_management_profile_info_sub_info_context">${DATA.DATA_01.USER_TYPE_NM}</p>
                                    <p class="profile_management_profile_info_sub_info_divider">|</p>
                                    <p class="profile_management_profile_info_sub_info_title"><spring:message code="tesign.taxAvail" text="세금계산서 발행가능 유무" /></p>
                                     <p class="profile_management_profile_info_sub_info_context">
                                    <c:choose>
                                    <c:when test="${empty DATA.DATA_02.TAX_BILL_YN}">
                                    	<spring:message code="disabled" text="무" />
                                    </c:when>
                                    <c:when test="${DATA.DATA_02.TAX_BILL_YN eq 'Y'}">
                                    	<spring:message code="enabled" text="유" />
                                    </c:when>
                                    <c:when test="${DATA.DATA_02.TAX_BILL_YN eq 'N'}">
                                    	<spring:message code="disabled" text="무" />
                                    </c:when>
                                    </c:choose>
                                    	</p>
                                </div>
                            </div>
                        </div>
<!--                         <div class="profile_management_profile_button_container">
                            <a href="./project_request.html" class="profile_management_profile_button_blue">
                                <p class="profile_management_profile_button_typo_blue">견적요청하기</p>
                            </a>
                        </div> -->
                    </div>
                    <div class="profile_management_profile_item etc_info">
                        <div class="profile_management_profile_etc_info_success_rate">
                            <p class="profile_management_profile_etc_info_title"><spring:message code="tesign.successR" text="거래성공률" /></p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <img class="profile_management_profile_satisfaction_img" src="/public/assets/images/satisfaction_very_good.svg"/>
                                <p class="profile_management_profile_etc_info_context">${DATA.DATA_03.COMPLETE_RATIO}</p>
                                <p class="profile_management_profile_etc_info_context_unit ">%</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_satisfaction">
                            <p class="profile_management_profile_etc_info_title"><spring:message code="tesign.satisf" text="만족도" /></p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <img class="profile_management_profile_satisfaction_img" src="/public/assets/images/satisfaction_good.svg"/>
                                <p class="profile_management_profile_etc_info_context">${DATA.DATA_03.SCORE_AVG}</p>
                                <p class="profile_management_profile_etc_info_context_unit ">/10</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_total_project">
                            <p class="profile_management_profile_etc_info_title"><spring:message code="tesign.totalP" text="거래 총 프로젝트 수" /></p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <p class="profile_management_profile_etc_info_context">${DATA.DATA_03.COMPLETE_CNT}</p>
                                <p class="profile_management_profile_etc_info_context_unit ">건</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_total_price">
                            <p class="profile_management_profile_etc_info_title"><spring:message code="tesign.totalA" text="거래 총 금액" /></p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <p class="profile_management_profile_etc_info_context">${DATA.DATA_03.COMPLETE_AMOUNT}</p>
                                <p class="profile_management_profile_etc_info_context_unit "><spring:message code="won" text="원" /></p>
                            </div>
                        </div>
<!--                         <div class="profile_management_profile_etc_info_mean_response">
                            <p class="profile_management_profile_etc_info_title">평균응답시간</p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <p class="profile_management_profile_etc_info_context">1</p>
                                <p class="profile_management_profile_etc_info_context_unit ">시간&nbsp;&nbsp;~&nbsp;&nbsp;</p>
                                <p class="profile_management_profile_etc_info_context">2</p>
                                <p class="profile_management_profile_etc_info_context_unit ">시간</p>
                            </div>
                        </div> -->
                    </div>
                    <div class="dotted_divider_container">
                        <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
                        <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
                    </div>
                    <div class="profile_management_profile_item self_intro">
                        <p class="profile_management_profile_item_title"><spring:message code="tesign.introYrs" text="자기소개" /></p>
                        <p class="profile_management_profile_self_intro_context">${DATA.DATA_02.INTRO_CONTENT}</p>
                    </div>
                    <div class="main_container_divider"></div>
                    <div class="profile_management_profile_item career">
                        <p class="profile_management_profile_item_title"><spring:message code="tesign.career" text="경력" /></p>
                        <div class="profile_management_profile_career_container">
                            <div class="profile_management_profile_career <c:if test="${DATA.DATA_02.CAREER_CD eq 'C001'}">selected</c:if>">
                                <img class="profile_management_profile_career_img" src="/public/assets/images/career_year_under_three.svg"/>
                                <p class="profile_management_profile_career_typo"><spring:message code="tesign.3exper" text="경력 3년이내" /></p>
                            </div>
                            <div class="profile_management_profile_career <c:if test="${DATA.DATA_02.CAREER_CD eq 'C002'}">selected</c:if>">
                                <img class="profile_management_profile_career_img" src="/public/assets/images/career_year_three_to_five.svg"/>
                                <p class="profile_management_profile_career_typo"><spring:message code="tesign.35exper" text="3~5년" /></p>
                            </div>
                            <div class="profile_management_profile_career <c:if test="${DATA.DATA_02.CAREER_CD eq 'C003'}">selected</c:if>">
                                <img class="profile_management_profile_career_img" src="/public/assets/images/career_year_five_to_ten.svg"/>
                                <p class="profile_management_profile_career_typo"><spring:message code="tesign.510exper" text="5~10년" /></p>
                            </div>
                            <div class="profile_management_profile_career <c:if test="${DATA.DATA_02.CAREER_CD eq 'C004'}">selected</c:if>">
                                <img class="profile_management_profile_career_img" src="/public/assets/images/career_year_over_ten.svg"/>
                                <p class="profile_management_profile_career_typo"><spring:message code="tesign.10exper" text="10년 이상" /></p>
                            </div>
                        </div>
                    </div>
                    <div class="main_container_divider"></div>
                    <div class="profile_management_profile_item design_field">
                        <p class="profile_management_profile_item_title"><spring:message code="tesign.designF" text="디자인 활동 분야" /></p>
                        <div class="profile_management_profile_design_field_container">

	            <c:forEach var="item" items="${DATA.PROJECT_CD_LIST}" varStatus="status">
	                         <div class="profile_management_profile_design_field" id="PROJECT_CD_${status.count}" style="display:none">
                                <p class="profile_management_profile_design_field_typo">${item.CODE_NM}</p>
                            </div>
	            </c:forEach>
                        </div>
                    </div>
                    <div class="main_container_divider"></div>
                    <div class="profile_management_profile_item pic">

							<div class="profile-swiper" id="profileSwiper1">

								<div class="profile-swiper-head">
									<p class="profile_management_profile_item_title"><spring:message code="tesign.showingPhoto" text="뽐내기 사진" /></p>
									<div class="swiper-button-wrap">
										<div class="swiper-button"><div class="swiper-button-prev"></div></div>
										<div class="swiper-button"><div class="swiper-button-next"></div></div>
									</div>
								</div>

								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide">
				<c:choose>
                  <c:when test="${empty DATA.DATA_02.IMAGE_FILE_CD}">
                    <img id="IMAGE_FILE" class="profile_management_main_pic_upload" src="/public/assets/images/profile_image.svg" alt="no_image">
                  </c:when>
                  <c:otherwise>
                    <img id="IMAGE_FILE" class="profile_management_main_pic_upload" src="/upload/${DATA.DATA_02.IMAGE_FILE_DIRECTORY}" alt="${DATA.DATA_02.IMAGE_FILE_ORIGIN_NM}">
                  </c:otherwise>
                </c:choose>
										</div>
									</div>
								</div>

								<div class="profile_management_profile_pic_background_wrapper"></div>

							</div>

                    </div>
                    <div class="profile_management_profile_item customer_review" style="margin-bottom:150px;">
							<div class="profile-swiper" id="profileSwiper2">

								<div class="profile-swiper-head">
									<p class="profile_management_profile_item_title"><spring:message code="tesign.custRev" text="고객리뷰" /></p>
									<div class="swiper-button-wrap">
										<div class="swiper-button"><div class="swiper-button-prev"></div></div>
										<div class="swiper-button"><div class="swiper-button-next"></div></div>
									</div>
									<!-- <a href="../dialog/customer_review_view_all.html" class="profile_management_profile_item_view_all">전체보기</a> -->
								</div>
									<div class="swiper-container">
									<div class="swiper-wrapper">
									<c:choose>
									<c:when test="${empty LIST}">
										<div style="width: 100%;text-align: center;">
											<spring:message code="tesign.noReview" text="아직 리뷰가 없습니다." />
										</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${LIST}" varStatus="status">
											<div class="swiper-slide">
												 <div class="profile_management_customer_review">
													  <p class="profile_management_customer_review_title">${LIST.TITLE}</p>
													  <div class="profile_management_customer_review_star_rating">
															<div class="profile_management_customer_review_star_rating_star_container">
																 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
																 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
																 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
																 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
																 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/blank_star.svg"/>
															</div>
															<p class="profile_management_customer_review_star_rating_numb">8</p>
															<p class="profile_management_customer_review_star_rating_unit">/</p>
															<p class="profile_management_customer_review_star_rating_unit">1</p>
															<p class="profile_management_customer_review_star_rating_unit">0</p>
													  </div>
													  <div class="profile_management_customer_review_divider"></div>
													  <p class="profile_management_customer_review_context">
															${LIST.REVIEW_CONTENT}
													  </p>
													  <p class="profile_management_customer_review_date_wrote">${LIST.CREATE_DATE}</p>
												 </div>
											</div>
										</c:forEach>
									</c:otherwise>
									</c:choose>

									</div>
								</div><!-- // swiper-container -->
								
<!-- 								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide">
											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="/public/assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
									</div>
								</div>-->

							</div><!-- // profile-swiper -->

							<script>

							jQuery(function($){
								var project_swiper1 = new Swiper('#profileSwiper1 .swiper-container', {
									slidesPerView: 4,
									spaceBetween: 24,
									speed:600,
									navigation: {
										nextEl: '#profileSwiper1 .swiper-button-next',
										prevEl: '#profileSwiper1 .swiper-button-prev',
									},
								});
								var project_swiper2 = new Swiper('#profileSwiper2 .swiper-container', {
									slidesPerView: 4,
									spaceBetween: 24,
									speed:600,
									navigation: {
										nextEl: '#profileSwiper2 .swiper-button-next',
										prevEl: '#profileSwiper2 .swiper-button-prev',
									},
								});
							});
							</script>

                    </div>
                </div>