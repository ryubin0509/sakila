<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<% 
	int currentPage = 1; // 현재페이지
	if(request.getParameter("currentPage") != null){
	 currentPage = Integer.parseInt(request.getParameter("currentPage"));  
	}
	int filmId = 0; // 영화의 id
	if(request.getParameter("filmId")!=null){
		filmId = Integer.parseInt(request.getParameter("filmId"));
	} 
	int actorId = 0; // 배우의 id
	if(request.getParameter("actorId")!=null){
		actorId = Integer.parseInt(request.getParameter("actorId"));
	}  
	int lastPage = 0; // 마지막페이지
	int rowPerPage = 5; // 한 페이지 출력 갯수
	int total = 0;
	int firstIdx = (currentPage-1)*rowPerPage;
	int lastIdx =  rowPerPage;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	String where = ""; // 조건에 따라 where 절 달라짐 
	if(filmId != 0){
		where = "WHERE f.film_id ="+" "+filmId;
	} else  {
		where =	"WHERE a.actor_id = "+" "+actorId;
	}
	
	String totalSql = " SELECT COUNT(*)totalCount FROM actor a " 
					+ " INNER JOIN film_actor fl " 
					+ " ON a.actor_id = fl.actor_id " 
					+ " INNER JOIN  film f " 
					+ " ON fl.film_id = f.film_id "
					+  where;
	
	PreparedStatement totalStmt = conn.prepareStatement(totalSql);
	ResultSet totalRs = totalStmt.executeQuery();
	
	if(totalRs.next()){
		total = totalRs.getInt("totalCount");
	}
	
	System.out.println("전체 카운터의 수:"+ total);
	lastPage = (int)Math.ceil((double)total/rowPerPage);
	
	
	String resultSql = " SELECT a.actor_id actorId, CONCAT(a.first_name,' ',a.last_name)fullName, f.film_id filmId, f.title title FROM actor a "
					 + " INNER JOIN film_actor fl "
			         + " ON a.actor_id = fl.actor_id " 
					 + " INNER JOIN  film f " 
					 + " ON fl.film_id = f.film_id "
					 +   where +" "+ "LIMIT"+" "+firstIdx+","+lastIdx; 
	
	PreparedStatement resultStmt = conn.prepareStatement(resultSql);
	ResultSet resultRs = resultStmt.executeQuery();
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	
	while(resultRs.next()){
		HashMap<String,Object> map = new HashMap<String,Object> ();
		map.put("actorId", resultRs.getInt("actorId"));
		map.put("fullName", resultRs.getString("fullName"));
		map.put("filmId", resultRs.getInt("filmId"));
		map.put("title", resultRs.getString("title"));

		
		
		list.add(map);
	}
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<h1>배우 상세페이지 </h1>
<table border = "1">
<tr>	
	<th>배우ID</th>
	<th>배우이름</th>
	<th>영화ID</th>
	<th>영화출영작	</th>

</tr>
<% for(HashMap<String,Object> map : list){ %>  
<tr> 
	<td><%=map.get("actorId")%>	</td>
	<td><a href="/sakila/db0326/filmOne.jsp?actorId=<%=map.get("actorId") %>"><%=map.get("fullName")%>	</td>
	<td><%=map.get("filmId")%>	</td>
	<td><%=map.get("title")%>	</td>

</tr>
<% } %>

</table>
  <% if (currentPage > 1) { %>
    <a href="/sakila/db0326/actorOne.jsp?currentPage=<%= currentPage - 1 %>&filmId=<%=filmId%>&actorId=<%=actorId%>">이전</a>
<% } %>

[<%=currentPage%>]

<% if (currentPage < lastPage) { %>
    <a href="/sakila/db0326/actorOne.jsp?currentPage=<%= currentPage + 1 %>&filmId=<%=filmId%>&actorId=<%=actorId%>">다음</a>
<% } %>

<a href="/sakila/db0326/actorList.jsp">전체배우리스트</a>

</body>
</html>