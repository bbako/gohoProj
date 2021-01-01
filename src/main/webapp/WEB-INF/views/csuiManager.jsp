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

<script type="text/javascript" src="/resources/js/jquery/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="/resources/js/socket/sockjs.min.js"></script>
<script type="text/javascript" src="/resources/js/bootstrap/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="/resources/js/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="/resources/css/chat.css">

<style type="text/css">
.p_top {
	padding-top: 20px;
	padding-bottom: 20px;
	margin-top: 20px;
	margin-bottom: 20px;
	margin-left: 5px;
	margin-right: 5px;
}

.t_margin {
	padding-top: 20px;
	padding-bottom: 20px;
	margin: 30px;
}

html, body {
	height: 100%;
}
</style>

<script> 

	var windows_Popup = new Array();
	var whereId = 0; 
	var tempArray = new Array();
	var orgIdArray = new Array();
	
	$(document).ready(function() {
		
		setInterval(function(){
			startTime(); 
		},500); 
		// sendPing();
		getUserCnt();

		var u_list = JSON.parse('${u_list}');
		makeLeftList(u_list);

		$("#s_name").keyup(function(e) {
			
			if(e.keyCode == 13) {
				
				var u_list_filter2 = u_list.filter(function(user){
					return user.username.indexOf($("#s_name").val())>=0;
				});
				
				$("#accordionEx7").html("");
				
				makeLeftList(u_list_filter2);
				
				$(".collapse").addClass('show');

			}
		});

		$("#ap_memo").bind("change", function() {
			var apMemoText = $("#ap_memo").val(); 
			if(apMemoText.length > 500) {
				alert(" 상담내용은 500자 이하 입력 가능합니다."); 
				$("#ap_memo").val("");
				$("#ap_memo").focus();
			}
		});
		
		$('input[type="checkbox"]').click(function(){
			
			var userid = $(this)[0].id.split("_")[1];
			
			if($(this).prop("checked") == true){
				
				showPopup(userid);
				
			}else if($(this).prop("checked") == false){
				
				closePopup(userid);
			}
		});
		
	});
		
	var leftListFlag = 0;

	function leftlistDropDown() {
		if(leftListFlag == 0 ) {
			$('#leftListDropDown').removeClass('accordionoff'); 
			$('#leftlistDropDown').addClass('accordionon');
			$('.navbar').removeClass('hidden');
			leftListFlag = 1; 
		}else{
			$('#leftListDropDown').removeClass('accordionon'); 
			$('#leftListDropDown').addClass('accordionoff');
			$('.navbar').addClass('hidden'); 
			leftListFlag = 0;
		}
	};
	
	function makeLeftList(u_list) {
		var u_team = ""; 
		for(var i = 0; i < u_list.length ; i++) {
			var user = u_list[i];
			
			if(u_team != user.orgid){
				orgIdArray.push(user.orgid); 
				u_team = user.orgid; 
				
				$("#accordionEx7").append( 
					'<div class="card" id="group_'+ user.orgid +'">'+
						'<div class="card-header rgba-stylish-strong z-depth-1 mb-1" role="tab" id="heading1">'+
							'<a data-toggle="collapse" data-parent="#accordionEx7" href="#collapse_'+user.orgid+'" aria-expanded="false" aria-controls="collapse_'+user.orgid+'">'+
								'<h6 class="mb-0 white-text text-uppercase font-thin">'+
									user.orgnm+'<i class="fas fa-angle-down rotate-icon"></i>'+
								'</h6>'+
							'</a>'+
						'</div>'+
						'<div id="collapse_'+user.orgid+'" class="collapse" role="tabpanel" aria-labelledby="heading1" data-parent="#accordionEx7">'+
							'<div class="card-body mb-1 rgba-grey-light white-text">'+
								'<input class="u_check" type="checkbox" id="member_'+user.userid+'">'+
								'<img id="call_'+ user.userid +'" src="/resources/img/icon_callmem.png" style="width:20px;">'+
								'<span style="font-size:0.9em" onclick="userClick(\''+user.userid+'\')">'+user.username+'</span >'+
							'</div>'+
						'</div>'+
					'</div>'
				)
			}else{
				$("#collapse_"+user.orgid).append( 
						'<div class="card-body mb-1 rgba-grey-light white-text">'+
							'<input class="u_check" type="checkbox" id="member_'+user.userid+'">'+
							'<img id="call_'+ user.userid +'" src="/resources/img/icon_callmem.png" style="width:20px;">'+
							'<span style="font-size:0.9em" onclick="userClick(\''+user.userid+'\')">'+user.username+'</span >'+
						'</div>'
				)
			}
		}
	};


	function showPopup(user) {
		tempArray.push(user);
		var url = "/csuiUser.do?user_id=" + user;
		var title = user;
		var status = "width=500, height=1000, left="+ 100*tempArray.length + ", top=0, scrollbars =1 , resizeable=1, location=no, directories=no, titlebar=no, status=no";
		windows_Popup[whereId] = window.open(url, title, status); 
		whereId = whereId +1;
	};
		
	function closePopup(value) {
		var i = tempArray.indexOf(value);
		if(i >=0){
			windows_Popup[i].window.close(); 
			tempArray[i] = '00000000';
		}
	};

	function startTime() {

		var today = new Date(); 
		var year = today.getFullYear(); 
		var month = checkTime(today.getMonth() + 1);
		var date = checkTime(today.getDate()); 
		var day = today.getDay(); 
		var hour = checkTime(today.getHours()); 
		var min = checkTime(today.getMinutes()); 
		var sec = checkTime(today.getSeconds()); 
		var week = new Array('일','월','화','수','목','금','토'); 
		var dayLabel = week[day];
		
		$("#c_time").html( 
						'<span style="color:black; font-size: 15px">' + year + '-'
						+ month + '-' + date + '(' + dayLabel + ') ' + hour
						+ ':' + min + ':' + sec + '</span>'); 
	};

	function checkTime(i) {
		if (i < 10) {
			i = "0" + i;
		}
		return i;
	};

	function userClick(userid) {
		
		getWFMSInfo(userid);
		
		// $(".chatlog").empty();
		// connectWebSocket(userid);
	}
	
	
	function getWFMSInfo(userid) { 
		$.ajax({
			type : 'POST', 
			url : '/getWFMSInfo.do', 
			dataType : 'Json', 
			data : {
				user_id : userid
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log("error");
			},
			success : function(data) {
				
				$("#uGroup").html(" | " + data.orgnm); 
				$("#uName").html(" | " + data.username); 
				$("#tempGroupNm").val(data.orgnm);
			}
		})
	};

	function getUserCnt() { 
		$.ajax({
			type: 'POST', 
			url : '/getUserCnt.do', 
			dataType : 'Json',
			data : {
				user_id : '${user_id}', 
				user_duty_cd : '${user_duty_cd}', 
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log("error"); 
			},
			success : function(data) {
				$("#stt_user").html(data[0].STT_USER); 
				$("#total_user").html(data[0].TOTAL_USER);
			}
		});
	};
	

	function getchat(userid) { 
			exSocket.send (JSON.stringify({
				type : "user_id", 
				r_csr_id : userid, 
				level : "1"
			}));
	};

	function getcallstatus4Manager(orgid) { 
			exSocket4Manager.send(JSON.stringify({
				type : "user_id", 
				group_id : orgid, 
				level : "2"
			}));
	};

	var exSocket = null; 
	var exSocket4Manager = null;
	
	function sendPing() {
		console.log("ping!!!! :" + exSocket + ", " + exSocket4Manager);

		if (exSocket != null) { 
			exSocket.send(JSON.stringify({
				type : "ping" 
			}));
		}
			
		if (exSocket4Manager != null) { 
			exSocket4Manager.send(JSON.stringify({
				type : "ping4Manager" 
			})); 
		}else{
			// connectWebSocket4Manager(orgIdArray);
		}

		var t = setTimeout(sendPing, 20000);
	};

	function connectWebSocket(userid) {
		if (exSocket == null) {
			exSocket = new WebSocket("${wssUrl}") 
			exSocket.onopen = function(event) {
				getchat(userid);
			}
			exsocket.onclose = function(event) {
				exSocket = null;
			}
			exSocket.onmessage = function(event) {
				var jsonData = JSON.parse(event.data);
				console.log(jsonData);

				if (jsonData.type == "call_start") {
					$(".chatlog").empty(); 
					$("#callNum").html(jsonData.r_cid);
					$("#ap_class_cd1").val('');
					$("#ap_class_cd2").val('');
					$("#ap_class_cd3").val('');
					$("#ap_memo").val("");
					$("#top_1").text('');
					$("#top_2").text('');
					$("#top_3").text('');
					$("#score_1").text('');
					$("#score_2").text('');
					$("#score_3").text('');
				} else if (jsonData.type == "call_end") {
					 //TA 요청 부분
				} else if (jsonData.type == "call_text") {
					for (var i = 0; i < jsonData.data.lengths ; ++i) {
						var rtobj = getSelctor(jsonData.data[i]); 
						if (rtobi) { } else {
							if (jsonData.data[i].r_mode_cd == '1') {
								$(".chatlog").append(
									"<div id='" + jsonData.data[i].r_start_tm_order + "'class='chatlog_mine'><h5>4</h5><span class='time'>"
									+ jsonData.data[i].r_start_tm 
									+ "<br>" 
									+ jsonData.data[i].r_end_tm 
									+ "</span><p>" 
									+ jsonData.data[i].r_stt_text
									+ "</p></div>") 
							} else { 
								$(".chatlog") .append(
									"<div id='" + jsonData.data[i].r_start_tm_order + ".class='chatlog_receive'><h5>고객</h5>"
									+ "<p>"
									+ jsonData.data[i].r_stt_text 
									+ "</p>" 
									+"<span class='time'>"
									+ jsonData.data[i].r_start_tm 
									+ "<br>"
									+ jsonData.data[i].r_end_tm 
									+ "</span>" 
									+"</div>");
							}
						}
					}
				} else {
					$(".result").val(jsonData.data);
				}
				$("#chatlog").scrollTop($("#chatlog")[0].scrollHeight);
			};
		}else{
			getchat(userid);
		}
	}

	function getselctor(obj) {
		
		var time = obj.r_start_tm_order; 
		var flag = false;

		$("#chatlog div").each(
			function() {
				var preTime = $(this).attr('id');

				if (!flag) { 
					if (obj.r_mode_cd == '1') { 
						$(this).before(
							"<div id='" + obj.r_start_tm + "' class='chatlog_mine'><h5>나</h5><span class='time'>"
							+ obj.r_start_tm 
							+ "<br>"
							+ obj.r_end_tm  
							+ "</span><p>" 
							+ obj.r_stt_text
							+ "</p><</div>"); 
					} else { 
						$(this).before(
							"<div id='" + obj.r_start_tm + "'class='chatlog_receive'><h5>고객</h5>" 
							+ "<p>"
							+ obj.r_stt_text 
							+ "</p>" 
							+"<span class='time'>"
							+ obj.r_start_tm
							+ "<br>"
							+ obj.r_end_tm 
							+ "</span>" 
							+"</div>");
					}
					flag = true;
				}
			});
			return flag;
		};
	
	function connectWebSocket4Manager(orgIdArray) {
		if (exSocket4Manager == null) {
			exSocket4Manager = new WebSocket("${wssUrl}") 
			exSocket4Manager.onopen = function(event) {
				getCallstatus4Manager(orgIdArray);
			}
			exsocket.onclose = function(event) {
				exSocket4Manager = null;
			}
			exSocket.onmessage = function(event) {
				var jsonData = JSON.parse(event.data);
				console.log(jsonData);
				$("#call_"+jsonData.r_csr_id).attr("src", "/resources/img/icon_callmemNot.png");
			};
		}
	}
</script>
</head>

<body style="background-color:#F4976C">
	<div class="container-fluid h-100" style="max-width: 100% ;">
		<div class="row h-100" >
			<div class="col p_top" style="background-color:white;border-radius: 25px; ">
				<div>
					<h3 class="Logozone" style="margin-left: 5px; margin-top: 5px;">
						<img style="width: 200px" src="/resources/img/logo_B.png"
							alt="비씨카드상담">
					</h3>
						<!--<button id="leftlistDropDown" class="accordionoff" onclick="leftlistDropDown();"></button>-->
					<p style="top: 1%; text-align: center; padding-top: 10px; position: relative;">
						<span> 실시간 상담사</span> 
						<span style="padding: 0px; font-size: 18px; font-weight: bold; color: #F49760" id="stt_user">0 </span> 
						<span style="padding: 0px;">명 / 총 </span> 
						<span style="padding: 0px; font-size: 18px; font-weight: bold; color: #F49760" id="total_user">0 </span> 
						<span style="padding: 0px;">명</span>
					</p>
					<div class="input-group input-group-sm mb-3">
						<div class="input-group-prepend">
							<span class="input-group-text" id="inputGroup-sizing-sm">검색</span>
						</div>
						<input type="text" class="form-control" aria-label="Small" aria-describedby="inputGroup-sizing-sm" id="s_name">
					</div>
				</div>

				<div class="row accordion-gradient-bcg d-flex justify-content-center">

					<!-- Grid column -->
					<div class="col-md-12 col-xl-12 py-5">

						<!--Accordion wrapper-->
						<div class="accordion md-accordion accordion-2" id="accordionEx7" role="tablist" aria-multiselectable="true">
						</div>
						<!--/.Accordion wrapper-->

					</div>
					<!-- Grid column -->

				</div>
			</div>
			<div class="col-5 p_top" style="background-color:white;border-radius: 25px; " >
				<div class="row">
					<div class="col-8">
						<h5>
							<img src="/resources/img/icon_callmem.png" alt="상담사 아이콘"
								align="left" style="width: 25px"> <span id="callNum"></span>
							&nbsp; <span id="uName" style="padding: 0px"></span> <span
								id="uGroup" style="padding: 0px"></span>
						</h5>
					</div>
					<div class="col-4" id="c_time"></div>
				</div>
				<div class="chatlog">
					<div class="chatlog_mine">
						<h5>나</h5>
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>안녕하십니까? 비씨카드 제휴업체 상담원 상담인입니다.</p>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_mine">
						<h5>나</h5>
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까?</p>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네 근무시간 중이라 짧게 부탁드립니다</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>그런데 BC카드 회사 내부 규정인가요? 아니면 정보통신부나 그런 전반적인 규정이 바뀐것인가요?</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>그런데 BC카드 회사 내부 규정인가요? 아니면 정보통신부나 그런 전반적인 규정이 바뀐것인가요?개인정보보호정책이 변경됨에 따라 안내해드리려고개인정보보호정책이 변경됨에 따라 안내해드리려고개인정보보호정책이 변경됨에 따라 안내해드리려고개인정보보호정책이 변경됨에 따라 안내해드리려고</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_mine">
						<h5>나</h5>
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까개인정보보호정책이 변경됨에 따라 안내해드리려고 연락드렸습니다. 잠시 통화가능하십니까?</p>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					<div class="chatlog_receive">
						<h5>고객</h5>
						<p>네</p>
						<span class="time">11:20:35<br>11:21:17
						</span>
					</div>
					
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>잠시 통화가능하십니까?</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>네네...</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>아~</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>잠시 통화가능하십니까?</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>네네</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>아</p>
					</div>
					<div class="chatlog_mine">
						<span class="time">11:20:35<br>11:21:17
						</span>
						<p>잠시 통화가능하십니까?</p>
					</div>
				</div>

			</div>
			<div class="col-5 p_top" style="background-color:white;border-radius: 25px; ">
			
				<div class="side_head">
					<h5>
						<span>상담유형분류</span>
					</h5>
				</div>
				<div class="rule t_margin">
					<table class="table table-sm">
						<tbody>
							<tr>
								<th scope="row">1순위</th>
								<td>카드>카드 발급</td>
								<td>(추천도 : 98%)</td>
							</tr>
							<tr>
								<th scope="row">2순위</th>
								<td>기타>카드 분실</td>
								<td>(추천도 : 1%)</td>
							</tr>
							<tr>
								<th scope="row">3순위</th>
								<td>종합>카드 승인</td>
								<td>(추천도 : 1%)</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="side_head">
					<h5>
						<span>상담내용</span>
					</h5>
				</div>
				<div class="rule t_margin">
					<div class="form-group">
						<textarea class="form-control" id="exampleFormControlTextarea1" rows="10" disabled="disabled"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>

	<input type="hidden" id="tempGroupNm" value="" />
	<input type="hidden" id="ap_class_cd1" value="" />
	<input type="hidden" id="ap_class_cd2" value="" />
	<input type="hidden" id="ap_class_cd3" value="" />

</body>
</html>