<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
Integer staffId =  (Integer)(session.getAttribute("loginStaff"));

if(staffId == null){
	 response.sendRedirect("/sakila/loginForm.jsp");
}

%>
<%
	int currentPage = 1; // 현재페이지
	if(request.getParameter("currentPage") != null){
	 currentPage = Integer.parseInt(request.getParameter("currentPage"));  
	}
	int lastPage = 0; // 마지막페이지
	int rowPerPage = 10; // 한 페이지 출력 갯수
	int total = 0;
	int firstIdx = (currentPage-1)*rowPerPage;
	int lastIdx = rowPerPage;
	String totalSql  = " SELECT COUNT(*) totalCount FROM actor ";
	String resultSql = " SELECT actor_id actorId, CONCAT(first_name,' ',last_name) fullName from actor LIMIT"+" "+ firstIdx + "," + lastIdx;
	
	PreparedStatement totalStmt = null; 
	ResultSet totalRs = null; 
	
	PreparedStatement resultStmt = null; 
	ResultSet resultRs = null; 
		
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	totalStmt = conn.prepareStatement(totalSql);
	totalRs = totalStmt.executeQuery();
	
	
	if(totalRs.next()){
	   total = totalRs.getInt("totalCount");
	}
	
	lastPage = (int)Math.ceil((double) total/ rowPerPage);
	
	System.out.println("전체행의수:"+ total);
	
	resultStmt = conn.prepareStatement(resultSql);
	resultRs = resultStmt.executeQuery();

	
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	
	while(resultRs.next()){
		HashMap<String,Object> map = new HashMap<String,Object> ();
		map.put("actorId", resultRs.getInt("actorId"));
		map.put("fullName", resultRs.getString("fullName"));
		
		list.add(map);
	}
	
%>





<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"  type="text/css"href="/sakila/style.css">
<title>영화목록리스트</title>
</head>
<body>
	<div>
		<%=staffId%>님 반갑습니다.
		<a href="<%= request.getContextPath() %>/logout.jsp">로그아웃</a>
		<hr>
			
	</div>
<h2>배우목록리스트</h2>
<table border="1">
<tr>
	<th>actorId</th>
	<th>배우이름</th>
</tr>
<% for(HashMap<String,Object> map : list){ %>
<tr>
	<td><%=map.get("actorId")%></td>
	<td><a href="/sakila/db0326/actorOne.jsp?actorId=<%=map.get("actorId")%>"><%=map.get("fullName")%></a></td>
</tr>
<%} %>

</table>
<br>
  <% if (currentPage > 1) { %>
    <a href="/sakila/db0326/actorList.jsp?currentPage=<%= currentPage - 1 %>">이전</a>
<% } %>

[<%=currentPage%>]

<% if (currentPage < lastPage) { %>
    <a href="/sakila/db0326/actorList.jsp?currentPage=<%= currentPage + 1 %>">다음</a>
<% } %>



</body>
</html>