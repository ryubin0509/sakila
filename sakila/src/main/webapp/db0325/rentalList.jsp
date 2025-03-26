<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
int currentPage = 1;
if (request.getParameter("currentPage") != null) {
    currentPage = Integer.parseInt(request.getParameter("currentPage"));
}
int rowPerPage = 10;
int firstIdx = (currentPage - 1) * rowPerPage;

int storeId = 0;
if (request.getParameter("storeId") != null) {
    storeId = Integer.parseInt(request.getParameter("storeId"));
}

String searchWord = request.getParameter("searchWord");
if (searchWord == null || searchWord.trim().equals("")) {
    searchWord = null;
}

int total = 0;
int lastPage = 0;

Class.forName("com.mysql.cj.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

// 쿼리 조건식
String where = "";
if (storeId != 0 && searchWord != null) {
    where = " WHERE s.staff_id = " + storeId + " AND f.title LIKE '%" + searchWord + "%'";
} else if (storeId != 0) {
    where = " WHERE s.staff_id = " + storeId;
} else if (searchWord != null) {
    where = " WHERE f.title LIKE '%" + searchWord + "%'";
}

// 전체 조건식
String countSql = "SELECT COUNT(*) AS total FROM staff s "
        + "INNER JOIN rental r ON s.staff_id = r.staff_id "
        + "INNER JOIN inventory i ON r.inventory_id = i.inventory_id "
        + "INNER JOIN customer c ON r.customer_id = c.customer_id "
        + "INNER JOIN film f ON i.film_id = f.film_id " + where;

Statement countStmt = conn.createStatement();
ResultSet countRs = countStmt.executeQuery(countSql);
if (countRs.next()) {
    total = countRs.getInt("total");
}
lastPage = (int) Math.ceil((double) total / rowPerPage);

// 데이터 조회
String listSql = "SELECT r.rental_id, f.title, i.inventory_id, "
        + "CONCAT(c.first_name, ' ', c.last_name) AS fullName, "
        + "r.rental_date, r.return_date "
        + "FROM staff s "
        + "INNER JOIN rental r ON s.staff_id = r.staff_id "
        + "INNER JOIN inventory i ON r.inventory_id = i.inventory_id "
        + "INNER JOIN customer c ON r.customer_id = c.customer_id "
        + "INNER JOIN film f ON i.film_id = f.film_id "
        + where + " LIMIT " + firstIdx + ", " + rowPerPage;

Statement listStmt = conn.createStatement();
ResultSet rs = listStmt.executeQuery(listSql);

ArrayList<HashMap<String, Object>> list = new ArrayList<>();
while (rs.next()) {
    HashMap<String, Object> row = new HashMap<>();
    row.put("rentalId", rs.getInt("r.rental_id"));
    row.put("title", rs.getString("title"));
    row.put("inventoryId", rs.getInt("inventory_id"));
    row.put("fullName", rs.getString("fullName"));
    row.put("rentalDate", rs.getString("rental_date"));
    row.put("returnDate", rs.getString("return_date"));
    list.add(row);
}


%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>대여 목록</title>
</head>
<body>
<h1>Rental List</h1>

<form  action="/sakila/db0325/rentalList.jsp">
    Store:
    <select name="storeId">
        <option value="0" <%= storeId == 0 ? "selected" : "" %>>전체</option>
        <option value="1" <%= storeId == 1 ? "selected" : "" %>>1지점</option>
        <option value="2" <%= storeId == 2 ? "selected" : "" %>>2지점</option>
    </select>

    Film Title:
    <input type="text" name="searchWord" value="<%= searchWord != null ? searchWord : "" %>">

    <button type="submit">검색</button>
</form>

<table border="1">
    <tr>
        <th>Rental ID</th>
        <th>Title</th>
        <th>Inventory ID</th>
        <th>Customer</th>
        <th>Rental Date</th>
        <th>Return Date</th>
    </tr>

<%
    for (HashMap<String, Object> row : list) {
%>
    <tr>
        <td><%= row.get("rentalId") %></td>
        <td><%= row.get("title") %></td>
        <td><%= row.get("inventoryId") %></td>
        <td><%= row.get("fullName") %></td>
        <td><%= row.get("rentalDate") %></td>
        <td><%= row.get("returnDate") %></td>
    </tr>
<%
    }
%>
</table>

<div>
<% if (currentPage > 1) { %>
    <a href="/sakila/db0325/rentalList.jsp?currentPage=<%= currentPage - 1 %>&storeId=<%= storeId %>&searchWord=<%= searchWord != null ? searchWord : "" %>">이전</a>
<% } %>

<% if (currentPage < lastPage) { %>
    <a href="/sakila/db0325/rentalList.jsp?currentPage=<%= currentPage + 1 %>&storeId=<%= storeId %>&searchWord=<%= searchWord != null ? searchWord : "" %>">다음</a>
<% } %>
</div>

</body>
</html>
