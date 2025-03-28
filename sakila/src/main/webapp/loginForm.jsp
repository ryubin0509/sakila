<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff")); 		

	if(staffId != null){
		response.sendRedirect("/sakila/index.jsp");
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet"  type="text/css"href="/sakila/style.css">
</head>
<body>
	<h1>Staff Login</h1>
	<div class ="login-cotainer">
	<form action="/sakila/loginAction.jsp">
	<table border="1">
		<tr>
			<th>StaffId</th>
			<td><input type="number" name="staffId"></td>
		</tr>
		<tr>
			<th>password</th>
			<td><input type="password" name="password"></td>
		</tr>		
	</table>
	<button type="sumbit">로그인하기</button>
	</form>
	</div>
</body>
</html>