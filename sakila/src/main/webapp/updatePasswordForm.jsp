<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet"  type="text/css"href="/sakila/style.css">
</head>
<body>
<form action="/sakila/updatePasswordAction.jsp?">
<table border="1">

<tr>
	<th>비밀번호 변경</th>
	<td><input type="password" name = password2></td>
</tr>

</table>
<button type="submit">비밀번호변경하기</button>

</form>
</body>
</html>