<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
	Integer staffId  = (Integer)(session.getAttribute("loginStaff"));	
	Integer inventoryId =  Integer.parseInt(request.getParameter("inventoryId"));	

	if(staffId == null){
		response.sendRedirect("/sakila/loginForm.jsp");
	}

	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	String sql = "update customer set active =1 where customer_id = " + customerId + " "; 
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.executeUpdate();
	
	response.sendRedirect("/sakila/db0327/inventoryList.jsp");

%>

