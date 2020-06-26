<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>지도 생성하기</title>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e156322dd35cfd9dc276f1365621ae9a&libraries=services"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.13.1/css/all.css" integrity="sha384-xxzQGERXS00kBmZW/6qxqJPyxW3UR0BPsL4c8ILaIWXva5kFi7TxkIIaMiKtqV1Q" crossorigin="anonymous">
<style>
	body{overflow-y:hidden;margin:0px;}
	#header{
		position:relative;
		height:10vh;
	}
	.container-fluid{
		width: 100vw;
        height: 100vh;
        padding:0px;
	}
	#sideBar{
	    float: left;
	    position: relative;
	    z-index: 25;
	    width: 300px;
	    height: 90vh;
	    background-color: #fcfcfc;
	}
	#map{
		z-index: 10;
		position:fixed;
		left:0px;
		float:right;
		width: 100%; 
		height: 100vh;
	}
	.search_area{background-color:#ff9900;height: 80px;padding-top:15px;padding-bottom:15px;}
	.searchbar{
		align:center;
		width: 90%;
	    height: 50px;
	    background-color: white;
	    border-radius: 5px;
	    padding: 10px;
    }
    .choose_info{overflow-x: hidden;overflow-y:auto;}
    .search_input{
	    color: black;
	    border: 0;
	    outline: 0;
	    background: none;
	    width: 200px;
	    line-height: 25px;
    }
    .search_icon{
	    height: 30px;
	    width: 40px;
	    float: right;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    color:#ffd900;
	    text-decoration:none;
	    border:0px;
	    background-color:white;
    }
    .search_icon:hover{
    	color:#ff9900;
    }
    .store_info{
		align:center;
	    height: 200px;
	    border-top:1px solid #ededed;
	    padding: 20px;
    }
    .partylist{
    	align:center;
	    border-top:1px solid #ededed;
	    padding: 20px;
	    margin-top:10px;
    }
    .partylist .party{
    	padding:5px;
    	background-color:white;
    	height:50px;
    	margin-top:0px;
	    position:relative;
	    font-size:10pt;
    }
    nav{margin-top:10px;}
    .page-item{margin-left:2px;margin-right:2px;}
    .page-link{
    	line-height:1 !important;
    	border-radius:20px !important;
    	border:0px;
    	color:#ff9900;
    }
    .page-item:hover .page-link{color:black;}
    .partylist .title{
    	float:left;
    	width:150px;
    }
    .partylist .join{
    	position:absolute;
    	right:5px;
    	background-color:#ff9900;
    	border:0px;
    	font-size:10pt;
    }
    #recruit{
    	background-color:#ff9900;
    	border:0px;
    	font-size:10pt;
    	width:100%;
    }
    .reviewlist .btn-sm{
    	background-color:#ff9900;
    	border:0px;}
    .reviewlist{
    	align:center;
	    height: 200px;
	    border-top:1px solid #ededed;
	    padding: 20px;
	    margin-bottom:20px;
    }
    .party:nth-child(2){margin-top:10px;}
    .review:nth-child(2){margin-top:10px;}
    .reviewlist .review{
    	background-color:white;
    	padding:10px;
    	font-size:8pt;	
	    border-bottom:1px solid #ededed;
    }
    .reviewlist .bottom{text-align:right;}
    .bg_bar {
    height: 11px;
    background-color: #e2e2e2;
    display: inline-block;
    width: 1px;
        margin: 6px 7px 0 8px;
	}
	.raty i{color:#ffd900;}
    .rating {float:left;}
    .rating:not(:checked) > input {
        position:absolute;
        clip:rect(0,0,0,0);
    }
    .rating:not(:checked) > label {
        float:right;
        width:1em;
        /* padding:0 .1em; */
        overflow:hidden;
        white-space:nowrap;
        cursor:pointer;
        font-size:120%;
        /* line-height:1.2; */
        color:#ddd;
    }
    .rating:not(:checked) > label:before {
        content: '★ ';
    }
    .rating > input:checked ~ label {
        color: #ffd900;

    }
    .rating:not(:checked) > label:hover,
    .rating:not(:checked) > label:hover ~ label {
        color: #ffd900;
    }
    .rating > input:checked + label:hover,
    .rating > input:checked + label:hover ~ label,
    .rating > input:checked ~ label:hover,
    .rating > input:checked ~ label:hover ~ label,
    .rating > label:hover ~ input:checked ~ label {
        color: #ffd900;
    }
    .rating > label:active {
        position:relative;
    }
    .input_content{
    	font-size:10pt;
    	height:100px;
    	overflow-y:auto;overflow-x:hidden;
    	background-color:white;
    }
    .review_comment{
		align:center;
	    height: 200px;
	    padding: 10px;
	    position:relative;
	}
    .review_comment .writer{font-size:10pt;}
    .review_comment i{position:absolute;right:10px;top:10px;color:#e2e2e2;}
    .review_comment i:hover{color:black;}
    .review_comment input[type=submit]{position:absolute;right:10px;bottom:30px;float:left;}
    .map_add{width:50px;height:50px;background-color:white;border-radius:50px;z-index:25;position:fixed;bottom:10px;right:10px;color:#ff9900;line-height:50px;}
    .food{width:50px;height:50px;background-color:white;border-radius:50px;z-index:25;position:fixed;bottom:70px;right:10px;color:#ff9900;line-height:50px;}
    .cafe{width:50px;height:50px;background-color:white;border-radius:50px;z-index:25;position:fixed;bottom:130px;right:10px;color:#ff9900;line-height:50px;}
    .map_wrap {position:relative;width:100%;height:350px;}
    span.title {font-weight:bold;display:block;}
    .hAddr {position:absolute;left:10px;top:10px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:5px;}
    #centerAddr {display:block;margin-top:2px;font-weight: normal;}
    .bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
    
</style>
<script>
	$(function(){
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };
		// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption); 
		
		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

		// 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
		/* kakao.maps.event.addListener(map, 'zoom_changed', function() {        
		    
		    // 지도의 현재 레벨을 얻어옵니다
		    var level = map.getLevel();
		    
		    var message = '지도를 확대해주세요.';
		    var resultDiv = document.getElementById('result');  
		    resultDiv.innerHTML = message;
		    
		}); */
		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
		infowindow = new kakao.maps.InfoWindow({zindex:30}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);

		// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
		    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
		        if (status === kakao.maps.services.Status.OK) {
		            var detailAddr = !!result[0].road_address ? '<div class="selectedRoad">도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
		            detailAddr += '<div class="selectedAddress">지번 주소 : ' + result[0].address.address_name + '</div>';
		            
		            var content = '<div class="bAddr">' +
		                            '<span class="title">주소정보</span>' + 
		                            detailAddr + 
		                        '</div>';

		            // 마커를 클릭한 위치에 표시합니다 
		            marker.setPosition(mouseEvent.latLng);
		            marker.setMap(map);

		            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
		            infowindow.setContent(content);
		            infowindow.open(map, marker);
		            $(".lat").html(mouseEvent.latLng.getLat());
		            $(".lng").html(mouseEvent.latLng.getLng());
		        }   
		    });
		});
		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
		    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		    $("#centerLat").text(map.getCenter().getLat());
		    $("#centerLng").text(map.getCenter().getLng());
		});

		function searchAddrFromCoords(coords, callback) {
		    // 좌표로 행정동 주소 정보를 요청합니다
		    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
		}

		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
		    if (status === kakao.maps.services.Status.OK) {
		        var infoDiv = document.getElementById('centerAddr');

		        for(var i = 0; i < result.length; i++) {
		            // 행정동의 region_type 값은 'H' 이므로
		            if (result[i].region_type === 'H') {
		                infoDiv.innerHTML = result[i].address_name;
		                break;
		            }
		        }
		    }    
		}
		$(".map_add").on("click",function(){
			var selectedRoad = $(".selectedRoad").text().split(" : ")[1];
			var selectedAddress = $(".selectedAddress").text().split(" : ")[1];
			$(".modal-body .road_address").html(selectedRoad);
			$(".modal-body .address").html(selectedAddress);
		})
		$(".food").on("click",function(){
        	$.ajax({
        		url:"/map/food",
        		type:"get",
        		data:{
        			lat:$("#centerLat").text(),
        			lng:$("#centerLng").text()},
        		dataType:"JSON"
        	}).done(function(resp){
        		console.log(resp.document);
        	}).fail(function(error1,error2){
        		console.log(error1);
        		console.log(error2);
        	})
		})
	})
</script>
</head>
<body>
	<!-- 지도를 표시할 div 입니다 -->
	<div style="display:none;" id="centerLat"></div>
	<div style="display:none;" id="centerLng"></div>
	<div class="container-fluid">
		<div id="header">헤더입니다.</div>
		<div id="sideBar">
			<div class="search_area">
				<div class="searchbar mx-auto">
		          <input type="text" class="search_input" name="keyword" placeholder="맛집 키워드 검색">
		          <button type="button" class="search_icon"><i class="fas fa-search"></i></button>
		        </div>
			</div>
	        <div class="choose_info">
	        	<div class="store_info mx-auto">
	        	맛집 정보 출력<br>
	        	가게명<br>
	        	가게주소<br>
	        	etc
	        </div>
	        <div class="partylist">
	        	<b>진행중인 모임</b>
	        	<div class="party">
	        		<div class="title">제목</div>
	        		<button type="button" class="btn btn-primary join">참가</button>
	        	</div>
	        	<div class="party">
	        		<div class="title">제목</div>
	        		<button type="button" class="btn btn-primary join">참가</button>
	        	</div>
	        	<div class="party">
	        		<div class="title">제목</div>
	        		<button type="button" class="btn btn-primary join">참가</button>
	        	</div>
	        	<nav aria-label="Page navigation example">
				  <ul class="pagination pagination-sm justify-content-center">
				    <li class="page-item">
				      <a class="page-link" href="#" aria-label="Previous">
				        <i class="fas fa-chevron-left"></i>
				      </a>
				    </li>
				    <li class="page-item"><a class="page-link" href="#">1</a></li>
				    <li class="page-item"><a class="page-link" href="#">2</a></li>
				    <li class="page-item"><a class="page-link" href="#">3</a></li>
				    <li class="page-item"><a class="page-link" href="#">4</a></li>
				    <li class="page-item"><a class="page-link" href="#">5</a></li>
				    <li class="page-item">
				      <a class="page-link" href="#" aria-label="Next">
				        <i class="fas fa-chevron-right"></i>
				      </a>
				    </li>
				  </ul>
				</nav>
				<button type="button" class="btn btn-primary" id="recruit">내가 직접 모집하기</button>
	        </div>
	        <div class="reviewlist">
		        	<b>리뷰</b>
		        	<div class="review_comment">
		        		<div class="writer"><b>아무개</b>님</div>
		        		<i class="fas fa-images"></i>
		        		<div contenteditable="true" class="input_content"></div>
		        		<div class="rating">
				            <input type="radio" id="star5" name="rating" value="5" /><label for="star5" title="매우 만족스러움">5 stars</label>
				            <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="조금 만족스러움">4 stars</label>
				            <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="보통이에요">3 stars</label>
				            <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="조금 별로">2 stars</label>
				            <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="매우 별로">1 star</label>
				        </div>	
		        		<input type=submit class="btn-sm btn-primary" value="작성">
		        	</div>
		        	<div class="review">
		        		<i class="fas fa-user fa-2x"></i>
		        		<div class="raty">
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="far fa-star"></i>
						</div>
		        		<div class="content">맛있어요~</div>
		        		<div class="bottom">
		        			홍길동<span class="bg_bar"></span>10:56 AM<span class="bg_bar"></span>신고
		        		</div>
		        	</div>
		        	<div class="review">
		        		<i class="fas fa-user fa-2x"></i>
		        		<div class="raty">
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="far fa-star"></i>
						</div>
		        		<div class="content">맛있어요~</div>
		        		<div class="bottom">
		        			홍길동<span class="bg_bar"></span>10:56 AM<span class="bg_bar"></span>신고
		        		</div>
		        	</div>
		        	<div class="review">
		        		<i class="fas fa-user fa-2x"></i>
		        		<div class="raty">
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="fas fa-star"></i>
							<i class="far fa-star"></i>
						</div>
		        		<div class="content">맛있어요~</div>
		        		<div class="bottom">
		        			홍길동<span class="bg_bar"></span>10:56 AM<span class="bg_bar"></span>신고
		        		</div>
		        	</div>
		        </div>
			</div>
		</div>
		<div id="map"></div>
		<div class="food text-center"><i class="fas fa-hamburger"></i></div>
		<div class="cafe text-center"><i class="fas fa-coffee"></i></div>
		<div class="map_add text-center" data-toggle="modal" data-target="#exampleModal"><i class="fas fa-plus"></i></div>
		<!-- Modal -->
		<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel">일반 맛집 추가하기</h5>
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <div class="modal-body">
		        	<table class="table">
						  <thead>
						    <tr>
						      <th scope="col">#</th>
						      <th scope="col">선택한 맛집 정보</th>
						    </tr>
						  </thead>
						  <tbody>
						    <tr>
						      <th scope="row">도로명 주소</th>
						      <td class="road_address"></td>
						    </tr>
						    <tr>
						      <th scope="row">지번 주소</th>
						      <td class="address"></td>
						    </tr>
						    <tr>
						      <th scope="row">위도</th>
						      <td class="lat"></td>
						    </tr>
						    <tr>
						      <th scope="row">경도</th>
						      <td class="lng"></td>
						    </tr>
						    <tr>
						      <th scope="row">가게명</th>
						      <td class=""><input type="text" class="form-control form-control-sm" placeholder="가게명을 입력해주세요."></td>
						    </tr>
						    <tr>
						      <th scope="row">카테고리</th>
						      <td class="">
						      	<select class="form-control form-control-sm">
						      		<option value="음식점">음식점</option>
						      		<option value="카페">카페</option>
								</select>
							  </td>
						    </tr>
						  </tbody>
					</table>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		        <button type="button" class="btn btn-primary">등록</button>
		      </div>
		    </div>
		  </div>
		</div>
		</div>
</body>
</html>

