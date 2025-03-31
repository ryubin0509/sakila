<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*"%>
<%
	

	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer filmId = Integer.parseInt(request.getParameter("filmId"));
	Integer staffId = Integer.parseInt(request.getParameter("staffId"));
	Date now = new Date();
	String rentalDate  = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	System.out.println(rentalDate);
	
	Connection conn = null;
	PreparedStatement stmt = null;
    String sql = "INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id) " 
               + "VALUES ('" + rentalDate + "', " + inventoryId + ", " + customerId + ", NULL, " + staffId + ")";
	
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
    stmt = conn.prepareStatement(sql);		   
    stmt.executeUpdate(); 
	
    response.sendRedirect("/sakila/db0327/inventoryList.jsp");
%> 