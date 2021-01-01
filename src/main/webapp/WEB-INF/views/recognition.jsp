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
<script type="text/javascript" src="/resources/js/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/resources/js/jplayer/jquery.jplayer.min.js"></script>

<link rel="stylesheet" href="/resources/js/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="/resources/js/jplayer/css/jplayer.blue.monday.min.css" type="text/css" />

<style type="text/css">
html, body {
	height: 100%;
}
</style>


<script type="text/javascript">
	$(document).ready(function() {

		$("#jquery_jplayer_1").jPlayer({
			supplied: "mp3",
			wmode: "window",
			useStateClassSkin: true,
			autoBlur: false,
			smoothPlayBar: true,
			keyEnabled: true,
			remainingDuration: true,
			toggleDuration: true
		});
		
		$('#searchBtn').click(function(){
			console.log("click searchBtn");
			getRecognitionList();
		});
		
		$("#answerText").keyup(function(event){
			var pattern = /[a-zA-Z0-9]|[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi
			
			v = $(this).val();
			
			if(pattern.test(v)){
				$(this).val(v.replace(pattern, ''));
			}
			
		});
		
		$('#tempSave').click(function(){
			
			console.log("tempSave");
			
			$.ajax({
				type : 'POST', 
				url : '/saveAnswerTextTemp.do',
				dataType: "text",
				data : {
					r_file_nm : v_r_file_nm,
					answerText : $("#answerText").val()
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					console.log(textStatus);
				},
				success : function(data) {
					console.log(data);
				}
			})
		});
		
		$('#evaluate').click(function(){
			
			console.log("evaluate");
			
			if(v_r_status == "3"){
				var chk = confirm("이전의 평가가 삭제됩니다.");
				if(chk == true){
					$.ajax({
						type : 'POST', 
						url : '/recognitionEvaluate.do',
						data : {
							r_file_nm : v_r_file_nm,
							answerText :$("#answerText").val(),
							sttText : $("#sttText").val()
						},
						error : function(XMLHttpRequest, textStatus, errorThrown) {
							console.log(textStatus);
						},
						success : function(data) {
							
							$("#r_rate").html(data.result_rate2 + "%");
							$("#r_h").html(data.result_h);
							$("#r_d").html(data.result_d);
							$("#r_s").html(data.result_s);
							$("#r_i").html(data.result_i);
							$("#r_n").html(data.result_n);
							
							getRecognitionList();
						}
					})
				}
			}
		});
		
	});
	
	var v_r_file_nm = "";
	var v_r_status = "";
	
	function getRecognitionList(){
		
		$.ajax({
			type : 'POST', 
			url : '/getRecognitionList.do',
			data : {
				searchKeyWord : $("#searchKeyWord").val()
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log(textStatus);
			},
			success : function(data) {
				
				$("#recog_list tbody").empty();
				
				data.forEach(function(one){
					
					console.log(one);
					console.log(one.r_file_nm);
										
					$("#recog_list tbody").append(
							'<tr>' 
								+'<td onclick = javascript:recogClick('+ one.r_file_nm +','+ one.status +')>'+ one.r_user_nm +'</td>'
								+'<td onclick = javascript:recogClick('+ one.r_file_nm +','+ one.status +')>'+ one.r_user_id+'</td>'
								+'<td onclick = javascript:recogClick('+ one.r_file_nm +','+ one.status +')>'+ one.r_group_id+'</td>'
								+'<td onclick = javascript:recogClick('+ one.r_file_nm +','+ one.status +')>'+ one.r_stt_date+'</td>'
								+'<td onclick = javascript:changeStatus('+ one.r_file_nm +','+ one.status +')>'+ one.status +'</td>'
								+'<td onclick = javascript:recogClick('+ one.r_file_nm +','+ one.status +')>'+ one.result_rate+'</td>'
								+'<td onclick = javascript:recogClick('+ one.r_file_nm +','+ one.status +')>'+ one.result_date+'</td>'
							+'</tr>'
					)
				
				});
			}
		})
	}
	
	function recogClick(r_file_nm, status){
		
		console.log("recog_click");
		
		v_r_file_nm = r_file_nm;
		v_r_status = status;
		
		console.log(r_file_nm);
		
		$("#jquery_jplayer_1").jPlayer("setMedia", {
			mp3 : 'getMp3.do?r_file_nm=' + r_file_nm
		});
		
		$.ajax({
			type : 'POST', 
			url : '/getRecognitionStt.do',
			dataType:'Json',
			data : {
				r_file_nm : r_file_nm
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log(textStatus);
			},
			success : function(data) {
				
				console.log("getRecognitionStt success");
				console.log(data);
				
				$("#sttText").val(data.stt_text);
				
				if(!data.answer_text){
					$("#answerText").val(data.stt_text);
				}else{
					$("#answerText").val(data.answer_text);
				}
				
				$("#r_rate").html(data.result_rate2 + "%");
				$("#r_h").html(data.result_h);
				$("#r_d").html(data.result_d);
				$("#r_s").html(data.result_s);
				$("#r_i").html(data.result_i);
				$("#r_n").html(data.result_n);
				
			}
		});
	}
	
	function changeStatus(r_file_nm , status){
		
		console.log("changeStatus");
		console.log(r_file_nm);
		console.log(status);
		
		$.ajax({
			type : 'POST', 
			url : '/changeStatus.do',
			dataType:'Json',
			data : {
				r_file_nm : r_file_nm,
				status : status
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log(textStatus);
			},
			success : function(data) {
				getRecognitionList();
				
			}
		});
	}
	
	
	
	
</script>
</head>

<body>
	<div class="container">
	
		<div class="row">
			<h3>인식률 평가</h3>
		</div>
	
		<div class="input-group mb-3">
			<input type="text" class="form-control" placeholder="Search...." aria-label="Search...." aria-describedby="button-addon2" id="searchKeyWord">
			<div class="input-group-append">
				<button class="btn btn-outline-secondary" type="button" id="searchBtn">Search</button>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<table class="table table-striped" id="recog_list">
					<thead>
						<tr>
							<th scope="col">상담원</th>
							<th scope="col">상담원ID</th>
							<th scope="col">부서</th>
							<th scope="col">상담일시</th>
							<th scope="col">상태</th>
							<th scope="col">인식률 결과</th>
							<th scope="col">평가 일시</th>
						</tr>
					</thead>
					<tbody> </tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<div id="jquery_jplayer_1" class="jp-jplayer"></div>
				<div id="jp_container_1" class="jp-audio" role="application"
					aria-label="media player">
					<div class="jp-type-single">
						<div class="jp-gui jp-interface">
							<div class="jp-controls">
								<button class="jp-play" role="button" tabindex="0">play</button>
								<button class="jp-stop" role="button" tabindex="0">stop</button>
							</div>
							<div class="jp-progress">
								<div class="jp-seek-bar">
									<div class="jp-play-bar"></div>
								</div>
							</div>
							<div class="jp-volume-controls">
								<button class="jp-mute" role="button" tabindex="0">mute</button>
								<button class="jp-volume-max" role="button" tabindex="0">max
									volume</button>
								<div class="jp-volume-bar">
									<div class="jp-volume-bar-value"></div>
								</div>
							</div>
							<div class="jp-time-holder">
								<div class="jp-current-time" role="timer" aria-label="time">&nbsp;</div>
								<div class="jp-duration" role="timer" aria-label="duration">&nbsp;</div>
								<div class="jp-toggles">
									<button class="jp-repeat" role="button" tabindex="0">repeat</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<div class="form-group green-border-focus">
					<label for="exampleFormControlTextarea5">STT 처리</label>
					<textarea class="form-control" rows="20" id="sttText" disabled="disabled"></textarea>
				</div>
			</div>
			<div class="col">
				<div class="form-group green-border-focus">
					<label for="exampleFormControlTextarea5">답안지</label>
					<textarea class="form-control" rows="20" id="answerText"></textarea>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<button class="btn-md btn-info" style="float: right" id="evaluate">평가</button>
				<button class="btn-md btn-info" style="float: right" id="tempSave">임시저장</button>
			</div>
		</div>
		<div class="row">
			<div class="col" >
				<table class="table table-striped">
					<thead>
						<tr>
							<th scope="col">인식률</th>
							<th scope="col">H (히트)</th>
							<th scope="col">D (삭제)</th>
							<th scope="col">S (치환)</th>
							<th scope="col">I (삽입)</th>
							<th scope="col">N (전체)</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td id="r_rate"></td>
							<td id="r_h"></td>
							<td id="r_d"></td>
							<td id="r_s"></td>
							<td id="r_i"></td>
							<td id="r_n"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>

</html>