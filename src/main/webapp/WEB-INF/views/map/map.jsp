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
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a1fdcf1508451b00789df5e78a982931"></script>
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
	    color: white;
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
</style>
<script>
	$(function(){
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };
		// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption); 
	})
</script>
</head>
<body>
	<!-- 지도를 표시할 div 입니다 -->
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
		</div>
</body>
</html>

