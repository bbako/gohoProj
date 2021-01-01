<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript"	src="/resources/js/jquery/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="/resources/js/socket/sockjs.min.js"></script>
<script type="text/javascript" src="/resources/js/bootstrap/js/bootstrap.min.js"></script>


<link rel="stylesheet" media="(min-width: 651px) and (max-width: 5000px)" href="/resources/css/style_full_callmemV04arrange.css">
<link rel="stylesheet" media="(min-width: 0px) and (max-width: 650px)" href="/resources/css/style_small_callmemV04arrange.css">
<link rel="stylesheet" href="/resources/css/chatV04arrange.css">
<link rel="stylesheet" href="/resources/css/tableV04arrange.css">
<link rel="stylesheet" href="/resources/css/radiobtnV04arrange.css">

<link rel="stylesheet" href="/resources/js/bootstrap/css/bootstrap.min.css">

<title>BC Card</title>

<script type="text/javascript">
	
	var apClassCd1, apclassCd2, apclassCd3;

	$(document).ready(function() {
		// setInterval("sendPing()", 20000); 
		setInterval("startTime()", 1000); 
		// connectWebSocket();
		getWFMSInfo();
	
		$("#ap_memo").bind("change", function(){
			var apMemoText = $("#ap_memo").val(); 
			if(apMemoText.length > 500) {
				alert(" 500자 이하 ");
				$("#ap_memo").val("");
				$("#ap memo").focus();
			}
		});
	});
	
	function startTime() {
		var today = new Date(); 
		var year = today.getFullYear(); 
		var month = checkTime (today.getMonth() + 1); 
		var date = checkTime(today.getDate()); 
		var day = today.getDay(); 
		var hour = checkTime (today.getHours()); 
		var min = checkTime(today.getMinutes()); 
		var sec = checkTime (today.getSeconds()); 
		var week = new Array('일','월','화','수','목','금','토'); 
		var dayLabel = week[day]; 
		$("#c_time").html(
			"<span>" +
			year + "-" + month + "-" + date + "(" + dayLabel + ")" + hour + ":" + min + ":" + sec +
			"</span>"
			);
	};

	function div_Onoff (v, id) { 
		if(v == "4") {
			document.getElementById("con").style.visibility = "visible"; 
		} else {
			document.getElementById("con").style.visibility = "hidden";
		}
	}

	function getWFMSInfo() {
		
		console.log("getWFMSInfo");
		console.log("${user_id}");
		
		$.ajax({
			type : 'POST', 
			url : '/getWFMSInfo.do',
			data : {
				user_id : "${user_id}"
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log("error");
				console.log(textStatus);
			},
			success : function(data) {
				$("#uGroup").html(" | " + data.orgnm); 
				$("#uName").html(" | " + data.username); 
				$("#tempGroupNm").val(data.orgnm);
			}
		})
	};
	
	function checkTime(i) {
		if(i<10){
			i = "0" + i;
		}
		return i;
	}
	
	function getchat() { 
		exSocket.send(JSON.stringify({
			type : "user id", 
			r_csr_id : "${user_id}", 
			level : "1"
		}));
	}

	var exSocket = null;

	function sendPing() { 
		if (exSocket != null) { 
			exSocket.send(ISON.stringify({
				type : "ping",
				r_csr_id : "${user_id}"
			})); 
		}
	}
	
	var call_key = "";
	var isEnd = false;

	function connectWebSocket() { 
		if(exSocket == null) {
			
			exSocket = new WebSocket("${wssUrl}"); 
			
			exSocket.onopen = function(event) {
				getchat(); 
			};
			
			exSocket.onclose = function(event) {
				exSocket = null;
				connectWebSocket(); 
			}; 
			
			exSocket.onmessage = function(event) {
				var jsonData = JSON.parse(event.data);
				console.log(jsonData);

				if (jsonData.type == "call_start") {
					
					isEnd = false; 
					
					if(call_key != jsonData["r_real_call_key"]){
						$(".chatlog").empty();
					}
					
					call_key = jsonData["r_real_call_key"]; 
					$("#callNum").html(jsonData.r_cid);
					
					//start 
					$(".rule").hide(); 
					$(".bc_box-in-type").attr("style", "border-radius:10px 10px Opx Opx !important");
					$(".bc_container").animate({scrollTop:0}, 400);
					$("#ap_class_cd1").val(); 
					$("#ap class cd2").val();
					$("#ap_class_cd3").val();
					$("#ap_memo").val(''); 
					$("#srchArea").hide();
					$(".js-search").val('');
				} else if (jsonData.type == "call_end") { 
					if(isEnd == false) {
						isEnd = true; 
					$(".rule").show(); 
					$(".bc_box-in-type").attr("style", "border-radius:10px 10px 10px 10px !important");
					$(".bc_container").animate({scrollTop:$(".bc_container").height()}, 400); 
					// analyse(jsonData["r_real_call_key"]);
					}
				} else if (jsonData.type == "call_text") { 
					for(var i = 0; i < jsonData.data.length; ++i) {
						// var rtobj = getSelctor(jsonData.data[i]);

						if(!rtObj) {
							if (jsonData.data[i].r_mode_cd == '1') {
								$(".chatlog").append( 
														"<div id='" + jsonData.data[i].r_start_tm_order + "' class='chatlog_mine'>" + 
														"<span class='time'>" +
														jsonData.data[i].r_start_tm + "<br>" + jsonData.data[i].r_end_tm + 
														"</span>" + 
														"<p>" +
														jsonData.data[i].r_stt_text + 
														"</p>" + 
														"</div>"
													);
							} else { 
								$(".chatlog").append( 
														"<div id='" + jsonData.data[i].r_start_tm_order + "' class='chatlog_receive'>" + 
														"<h5>고객</h5>" +
														"<p>" +
														jsonData.data[i].r_stt_text +
														"</p>" + 
														"<span class='time'>" +
														jsonData.data[i].r_start_tm + "<br>" + jsonData.data[i].r_end_tm + 
														"</span>" + 
														"</div>"
													);
							}
						}
					}
					$("#chatlog").scrollTop($("#chatlog")[0].scrollHeight);
				}
			};
		}
	}

//	function getSelctor(obj) {
//		var time = obj.r_start_tm_order;
//	 	var flag = false;
//		$("#chatlog div").each(function() {
//			var preTime = $(this).attr('id');
//			if(Number(preTime) > Number(time)) { 
//				if(!flag) { 
//					if(obj.r_mode_cd == '1') {
//	 					$(this).before(
//										"<div id='" + obj.r_start_tm + "' class='chatlog_mine'>" + 
//										"<span class='time'>" +
//										obj.r_start_tm + "<br>" + obj.r_end_tm + 
//										"</span>" + 
//										"<p>" +
//										obj.r_stt_text + 
//										"</p>" + 
//										"</div>"
//						);
//					} else { 
//						$(this).before(
//										"<div id='" + obj.r_start_tm + "' class='chatlog receive'>" +
//										"<h5>고객 </h5>"+
//										"<p>"+ 
//										obj.r_stt_text + 
//										"</p>" + 
//										"<span class='time'>" +
//										obj.r_start_tm + "<br>" + obj.r_end_tm + 
//										"</span>" + 
//										"</div>"
//						);
//					}
//					flag = true;
//				}
//			}
//		});
//		return flag;
//	}

</script>
</head>

<body>
	<div class="wrapper" style="background-color: #F4976C">
		<div class="header">
			<h3 class="logozone">
				<img src="/resources/img/logo.png" alt="비씨카드상담">
			</h3>
		</div>
		<!-- The flexible grid (content) -->
		<div class="row" style="padding-left: 15px;">
			<div class="side">
				<div class="side_head">
					<img src="/resources/img/icon_callmem.png" alt="상담사 아이콘"
						align="left">

					<h3>
						<span class="" id="callNum">00000000</span> 
						<span class="" id="uName"></span>
						<span class="" id="uGroup"></span>
					</h3>

					<div class="head_time" id="c_time" style="float: right;"></div>

					<div class="head_line"></div>
				</div>

				<div class="chatlog">
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>안녕하십니까? 비씨카드 제휴업체 상담원 상담인입니다.</p>
					</div>

					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네 무슨 일이신데요..제가 지금 바빠서요. 짧게 말씀하세요</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>

					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까?</p>
					</div>

					<div class="chatlog_receive">
						<p>그런데 BC카드 회사 내부 규정인가요? 아니면 정보통신부나 그런 전반적인 규정이 바뀐것인가요?</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네 무슨 일이신데요..제가 지금 바빠서요. 짧게 말씀하세요</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까?</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>네</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까?</p>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네 무슨 일이신데요..제가 지금 바빠서요. 짧게 말씀하세요</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까?</p>
					</div>

				</div>
			</div>
			<div class="main">
				<div class="side_head">
					<h5>
						<span>상담유형분류</span>
					</h5>
					<div class="head_line"></div>
				</div>

				<div class="rule">
					<h5>상담유형 자동 추천</h5>
					<table class="table-responsive">
						<tbody>
							<tr>
								<th>
									<div class="radio icheck-midnightblue">
										<input type="radio" id='policy' name="optradio" value="1"
											onclick="div_OnOff(this.value,'con');"><label
											for='policy'><span>1순위</span></label>
									</div>
								</th>
								<td>
									<div class="radiotext">
										<label for='policy'>마케팅> 상품안내> 개인정보보호</label>
									</div>
								</td>
								<td>
									<div class="radiotext_recommend" style="text-align: right">
										<label for='policy'>(추천도 : 58.31%)</label>
									</div>
								</td>
							</tr>

							<tr>
								<th>
									<div class="radio icheck-midnightblue">
										<input type="radio" id='product' name="optradio" value="2"
											onclick="div_OnOff(this.value,'con');"><label
											for='product'><span>2순위</span></label>
									</div>
								</th>
								<td>
									<div class="radiotext">
										<label for='product'>마케팅> 상품안내> 개인정보보호 상품</label>
									</div>
								</td>
								<td>
									<div class="radiotext_recommend" style="text-align: right">
										<label for='product'>(추천도 : 2.15%)</label>
									</div>
								</td>
							</tr>

							<tr>
								<th>
									<div class="radio icheck-midnightblue">
										<input type="radio" id='service' name="optradio" value="3"
											onclick="div_OnOff(this.value,'con');"><label
											for='service'><span>3순위</span></label>
									</div>
								</th>
								<td>
									<div class="radiotext">
										<label for='service'>마케팅> 상품안내> 개인정보보호 상품</label>
									</div>
								</td>
								<td>
									<div class="radiotext_recommend" style="text-align: right">
										<label for='service'>(추천도 : 8.47%)</label>
									</div>
								</td>
							</tr>

							<tr style="vertical-align: top">
								<th>
									<div class="radio icheck-midnightblue">
										<input type="radio" id='search' name="optradio" value="4"
											onclick="div_OnOff(this.value,'con');"><label
											for='search'><span>분류유형 검색어</span></label>
									</div>
								</th>
								<td colspan="2" style="vertical-align: top">
									<div class="radio_etc" id="con" style="visibility: hidden;">
										<label for='search'>
											<table>
												<tbody>
													<tr>
														<td>
															<div class="radio icheck-midnightblue">
																<input type="radio" name="etc" id="etc_corp"> <label
																	for="etc_corp"><span>제휴업체</span></label>
															</div>
														</td>
													</tr>

													<tr>
														<td>
															<div class="radio icheck-midnightblue">
																<input type="radio" name="etc" id="etc_product">
																<label for="etc_product"><span>제휴상품</span></label>
															</div>
														</td>
													</tr>
													<tr>
														<td>
															<div class="radio icheck-midnightblue">
																<input type="radio" name="etc" id="etc_point"> <label
																	for="etc_point"><span>제휴포인트</span></label>
															</div>
														</td>
													</tr>

												</tbody>

											</table>
										</label>
									</div>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="line"></div>
					<div>
						<h5>상담내용</h5>
						<input type="text" class="summary">
					</div>
				</div>
				<!-- rule닫기-->
			</div>
			<!-- main닫기-->

		</div>
		<!--row닫기 -->
	</div>
	<!--wrapper닫기 -->

	<input id="tempGroupNm" type="hidden" value="" />
	<input id="ap_class_cd1" type="hidden" value="" />
	<input id="ap_class cd2" type="hidden" value="" />
	<input id="ap_class cd3" type="hidden" value="" />
</body>
</html>



