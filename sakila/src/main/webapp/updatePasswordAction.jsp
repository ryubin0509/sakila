<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> 
<%
	 Integer staffId = (Integer)(session.getAttribute("loginStaff"));
 	 String password =  request.getParameter("password2");

	Connection conn = null;
	PreparedStatement stmt = null;
	
	String sql = " UPDATE staff s1 "
			   + " JOIN (SELECT PASSWORD FROM staff where staff_id = ?) s2 " 
			   + " ON s1.password = s2.password "
			   + " SET s1.password =  ? ";
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	stmt = conn.prepareStatement(sql);
 	stmt.setInt(1,staffId);
 	stmt.setString(2,password);
 	
	stmt.executeUpdate();
	
	System.out.println("로그아웃 성공!");
	response.sendRedirect("/sakila/logout.jsp");
	
 
	
%>