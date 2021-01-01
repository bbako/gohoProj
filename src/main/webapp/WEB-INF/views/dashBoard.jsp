<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/resources/css/layoutstyleV02.css">

<script type="text/javascript"	src="/resources/js/jquery/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
	
	function getRealdata(){
		
		$.ajax({
			type : 'POST', 
			url : '/getRealdata.do',
			dataType:'Json',
			data : {
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log("error");
			},
			success : function(data) {
				
				console.log("getRealdata");
				console.log(data);
				
				$("#real_stt_day").html(numberWithComma(data[0].success) );
				$("#real_stt_month").html(numberWithComma(parseInt(data[1].success)+parseInt(data[0].success))); 
			}
		});
	}
	
	
	function getSemiRealdata(){
		
		$.ajax({
			type : 'POST', 
			url : '/getSemiRealdata.do',
			dataType:'Json',
			data : {
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log("error");
			},
			success : function(data) {
				
				console.log("getSemiRealdata");
				console.log(data);
	
				$("#s_real_rec_day").html(numberWithComma(data[0].n_ctrl_success) );
				$("#s_real_rec_month").html(numberWithComma(data[1].n_ctrl_success)); 
				$("#s_real_rec_day_5min").html(" (" +numberWithComma(data[2].n_ctrl_success) + ")");
				$("#s_real_stt_day").html(numberWithComma(data[0].n_stt_success)); 
				$("*s_real_stt_month").html(numberWithComma(data[1].n_stt_success));
				$("#s_real_stt_day_5min").html(" (" + numberWithComma(data[2].n_stt_success) + ")");
				$("#s_real_ta_day").html(numberWithComma(data[0].n_ta_success));
				$("#s_real_ta_month").html(numberWithComma(data[1].n_ta_success));
				$("#s_real_ta_day_5min").html(" (" + numberWithComma(data[2].n_ta_success) + ")");
				$("#s_real_etc_day").html(numberWithComma(data[0].etc_cnt));
				$("#s_real_etc_month").html(numberWithComma (data[1].etc_cnt));
				$("#s_real_etc_day_5min").html(" (" + numberWithComma( data[2].etc_cnt) + ")");
				
				$("#real_ta_day").html(numberWithComma(data[0].r_ta_success)); 
				$("#real_ta_month").html(numberWithComma(data[1].r_ta_success));
			}
		});
	}
	
	function getRealSttUserCnt(){
		
		$.ajax({
			type : 'POST', 
			url : '/getRealSttUserCnt.do',
			dataType:'Json',
			data : {
			},
			error : function(XMLHttpRequest, textStatus, errorThrown){
				console.log("error");
			},
			success : function(data){
				
				console.log("getRealSttUserCnt");
				console.log(data);
	
				$("#g_call_status").html(data[0].calling_user);
				$("#f_call_status").html(data[1].calling_user);
				$("#g_stt_user").html("/ "+ data[0].stt_user);
				$("#f_stt_user").html("/ "+ data[1].stt_user);
			}
		});
	}
	
	function startTime() {
		var today = new Date(); 
		var year = today.getFullYear(); 
		var month = checkTime(today.getMonth() + 1); 
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
	
	function checkTime(i) {
		if(i<10){
			i = "0" + i;
		}
		return i;
	}
	
	function numberWithComma(num){
		return parseInt(num). toLocaleString();
	}
	
	$(document).ready(function() {
		
		getRealdata();
		getSemiRealdata();
		getRealSttUserCnt();
		
		setInterval(function() {
			startTime();
		},1000);
		
		setInterval(function() {
			getSemiRealdata();
			getRealdata();
		},30000);
		
		setInterval(function() {
			getRealSttUserCnt();
		},10000);
		
	})


</script>

</head>

<body>
	<div class="wrap_container">
		<div class="header">
			<div class="logo">
				<img src="/resources/img/logo_W_BCcard.png" width="120px" alt="">
			</div>
			<div class="systemtitle">
				<h1>
					<img src="/resources/img/sttTransactions.png" width="300px" alt="">
				</h1>
			</div>
			<div class="time" id="c_time"></div>
		</div>
		<div class="wrap">
			<div class="realStt">
				<div class="subtitle">
					<h2>
						<img src="/resources/img/rotate_RealSTT.png" width="30px" alt="">
					</h2>
				</div>
				<div class="boxContainer">
					<div class="boxlayout">
						<div class="box">
							<div class="new1">
								<h4 class="head">
									<div class="ele01">STT</div>
									<div class="ele02"></div>
									<div class="ele03">
										<img src="/resources/img/icon_stt.png" width="50px" alt="">
									</div>
								</h4>
								<table>
									<tr>
										<td class="boxdata_day" id="real_stt_day">0</td>
										<td class="boxdata_index" id="">건/일</td>
									</tr>
									<tr>
										<td class="boxdata_month" id="real_stt_month">0</td>
										<td class="boxdata_index" style="color: #DFFD22">건/월</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="box">
							<div class="new1">
								<h4 class="head">
									<div class="ele01">TA</div>
									<div class="ele02" style=""></div>
									<div class="ele03">
										<img src="/resources/img/icon_ta.png" width="50px" alt="">
									</div>
								</h4>
								<table>
									<tr>
										<td class="boxdata_day" id="real_ta_day">0</td>
										<td class="boxdata_index">건/일</td>
									</tr>
									<tr>
										<td class="boxdata_month" id="real_ta_month">0</td>
										<td class="boxdata_index" style="color: #DFFD22">건/월</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="box">
							<div class="new1">

								<h4 class="head" style="visibility: hidden">
									<div class="ele01"></div>
									<div class="ele02"></div>
									<div class="ele03"></div>
								</h4>

								<table class="region">
									<tr>
										<td class="ele01"><img src="/resources/img/icon_region.png" alt="">퓨처</td>
										<td class="boxdata_day" style="width: 100%; text-align: right;">
										<span id="f_call_status">0</span>
										<span id="f_stt_user">0</span>
										</td>
									</tr>
									<tr>
										<td class="ele01"><img src="/resources/img/icon_region.png" alt="">가산</td>
										<td class="boxdata_day" style="width: 100%; text-align: right;">
										<span id="g_call_status">0</span>
										<span id="g_stt_user">0</span>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="semiStt">
				<div class="subtitle">
					<h2>
						<img src="/resources/img/rotate_SemiRealSTT.png" width="30px" alt="">
					</h2>
				</div>
				<div class="boxContainer">
					<div class="boxlayout">
						<div class="box">
							<div class="new">
								<h4 class="head">
									<div class="ele01">REC</div>
									<div class="ele02" style=""></div>
									<div class="ele03">
										<img src="/resources/img/icon_recre3.gif" width="40px" alt=""
											style="padding-right: 40px">
									</div>
								</h4>
								<table>
									<tr>
										<td class="boxdata_day" id="s_real_rec_day">0</td>
										<td class="boxdata_index">건/일</td>
									</tr>
									<tr>
										<td class="boxdata_month" id="s_real_rec_month">0</td>
										<td class="boxdata_index">건/월</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="box">
							<div class="new">
								<h4 class="head">
									<div class="ele01">STT</div>
									<div class="ele02" style=""></div>
									<div class="ele03">
										<img src="/resources/img/icon_stt.png" width="40px" alt=""
											style="float: right; padding-right: 40px">
									</div>
								</h4>
								<table>
									<tr>
										<td class="boxdata_day" id="s_real_stt_day">0</td>
										<td class="boxdata_index">건/일</td>
									</tr>
									<tr>
										<td class="boxdata_month" id="s_real_stt_month">0</td>
										<td class="boxdata_index">건/월</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="box">
							<div class="new">
								<h4 class="head">
									<div class="ele01">TA</div>
									<div class="ele02" style=""></div>
									<div class="ele03">
										<img src="/resources/img/icon_ta.png" width="40px" alt=""
											style="float: right; padding-right: 40px">
									</div>
								</h4>
								<table>
									<tr>
										<td class="boxdata_day" id="s_real_ta_day">0</td>
										<td class="boxdata_index">건/일</td>
									</tr>
									<tr>
										<td class="boxdata_month" id="s_real_ta_month">0</td>
										<td class="boxdata_index">건/월</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="box" style="width: 280px">
							<div class="new">
								<h4 class="head">
									<div class="ele01">ETC</div>
									<div class="ele02"></div>
								</h4>
								<table>
									<tr>
										<td class="boxdata_day" id="s_real_etc_day">0</td>
										<td class="boxdata_index" style="padding-right: 0px">건/일</td>
									</tr>
									<tr>
										<td class="boxdata_month" id="s_real_etc_dmonth">0</td>
										<td class="boxdata_index" style="padding-right: 0px">건/월</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
