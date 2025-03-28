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
	if (request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage")); 
	}
	
	int lastPage = 0;
	int rowPerPage = 10;
	int total = 0;
	int firstIdx = (currentPage-1)*rowPerPage;
	int lastIdx =  rowPerPage;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	String totalSql = " SELECT COUNT(*) totalCount "
					+ " FROM " 
			   		+ " (SELECT i.inventory_id, f.title "
			   		+ " FROM inventory i INNER JOIN film f "
			   		+ " ON i.film_id = f.film_id) t1 "
			   		+ " LEFT OUTER JOIN " 
			   		+ " (SELECT inventory_id, rental_date, " 
			        + " CASE WHEN return_date IS NULL THEN '대여불가' "
			        + "  ELSE '대여가능' END isRental "      
			   		+ " FROM rental "  
			   		+ " WHERE (inventory_id, rental_date) " 
			        + " IN (SELECT inventory_id, MAX(rental_date) "
			        + " FROM rental " 
			        + " GROUP BY inventory_id) "
			   		+ " ORDER BY inventory_id ASC) t2 "
			   		+ " ON t1.inventory_id = t2.inventory_id"; 
	
	PreparedStatement totalStmt = conn.prepareStatement(totalSql);
	ResultSet totalRs = totalStmt.executeQuery();
	
	if(totalRs.next()){
		total = totalRs.getInt("totalCount");
	}
	
	System.out.println("전체 카운터의 수:"+ total); 
	lastPage = (int)Math.ceil((double)total/rowPerPage);
	
	String resultSql = " SELECT t1.inventory_id, t1.title, t2.isRental "
					 + " FROM " 
			   		 + " (SELECT i.inventory_id, f.title "
			   		 + " FROM inventory i INNER JOIN film f "
			   		 + " ON i.film_id = f.film_id) t1 "
			   		 + " LEFT OUTER JOIN " 
			   		 + " (SELECT inventory_id, rental_date, " 
			         + " CASE WHEN return_date IS NULL THEN '대여불가' "
			         + " ELSE '대여가능' END isRental "     
			   		 + " FROM rental " 
			   		 + " WHERE (inventory_id, rental_date) " 
			         + " IN (SELECT inventory_id, MAX(rental_date) "
			         + " FROM rental "
			         + " GROUP BY inventory_id) "
			   		 + " ORDER BY inventory_id ASC) t2 "
			   		 + " ON t1.inventory_id = t2.inventory_id " 
					 + " LIMIT"+" "+firstIdx+","+lastIdx;
	
	PreparedStatement resultStmt = conn.prepareStatement(resultSql);
	ResultSet resultRs = resultStmt.executeQuery();
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>> ();
	
	while(resultRs.next()){
	
	HashMap<String,Object> map = new HashMap<String,Object> (); 
	
	map.put("inventoryid", resultRs.getInt("inventory_id"));
	map.put("title", resultRs.getString("title"));
	map.put("isRental", resultRs.getString("isRental"));
		
	list.add(map);	
		
		
	}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"  type="text/css"href="/sakila/style.css">
<title>InventoryList</title>
<h1>인벤토리 리스트 </h1>
</head>
<body>
	<div>
		<%=staffId%>님 반갑습니다.
		<a href="<%= request.getContextPath() %>/logout.jsp">로그아웃</a>
		<hr>
			
	</div>
	
<table border="1">
<tr>
	<th>보관번호</th>
	<th>제목</th>
	<th>대여가능여부</th>
	<th>대여링크</th>
</tr>

<%for(HashMap<String,Object> map : list){  %>
<tr> 
	<td><%=map.get("inventoryid")%>	</td>
	<td><%=map.get("title")%>		</td>
	<td><%=map.get("isRental")%>	</td>
	<td>
	<% 
		if("대여가능".equals(map.get("isRental"))){
	%>
		<a href="/sakila/db0327/rentalPage.jsp?inventoryId=<%= map.get("inventoryid") %>">대여하기</a>
	<% 
	}
	%>
	</td>
<% 	
} 
%>
	



<%
int firstPage = (currentPage/10)*10+1;
if (currentPage % 10 == 0) {
    firstPage -= 10;  // 현재 페이지가 10으로 나누어 떨어지면 첫 페이지를 한 페이지 앞당겨야 합니다.
}
int endPage = firstPage+9;
if(endPage > lastPage ){ 
	endPage = lastPage;
}
%>
</table>
<br>

<%
	 if (firstPage > 10){ 
%>
	 <a href="/sakila/db0327/inventoryList.jsp?currentPage=<%=firstPage-1%>">이전페이지 </a>
<%
	 }
%>
  <% if (currentPage > 1) { %>
    <a href="/sakila/db0327/inventoryList.jsp?currentPage=<%= currentPage - 1 %>">이전</a>
<% } %>

<%
	for(int i= firstPage; i<= endPage; i++){
		if(i== currentPage){
%>
			<% out.print("<span>" + i + "</span>"); %> 		
<% 
		} else {
%>	
	<a href="/sakila/db0327/inventoryList.jsp?currentPage=<%=i%>"><%=i%></a>

<%
	}
}
%>

<% if (currentPage < lastPage) { %>
    <a href="/sakila/db0327/inventoryList.jsp?currentPage=<%= currentPage + 1 %>">다음</a>

<% } %>

<% 
	 if (endPage < lastPage){ 
%>
	 <a href="/sakila/db0327/inventoryList.jsp?currentPage=<%=endPage+1%>">다음페이지</a>
<% 
	 }
%> 

</body>

</html>