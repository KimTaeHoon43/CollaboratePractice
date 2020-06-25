<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script>
	$(function(){
		$("#toMap").on("click",function(){
			location.href = "/map/toMap";
		})
	})
</script>
</head>
<body>
	<button id="toMap">맛집 검색 지도</button>
</body>
</html>
