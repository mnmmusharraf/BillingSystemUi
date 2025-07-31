package com.pahana.billingsystemui.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;


public class LoginServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                
                URL url = new URL("http://localhost:8080/BillingSystemBackend/api/staff/login");
                HttpURLConnection con = (HttpURLConnection) url.openConnection();
                con.setRequestMethod("POST");
                con.setRequestProperty("Content-Type", "application/json");
                con.setDoOutput(true);
                
                String jsonInput = String.format("{\"username\":\"%s\", \"password\":\"%s\"}", username, password);
                try (OutputStream os = con.getOutputStream()){
                    byte[] input = jsonInput.getBytes("utf-8");
                    os.write(input , 0, input.length);
                }
                
                int status = con.getResponseCode();
                if(status == 200){
                    HttpSession session = request.getSession();
                    session.setAttribute("staffUser", username);
                    response.sendRedirect("index.jsp");
                    
                }else{
//                    request.setAttribute("error", "Invalid username or password.");
//                    request.getRequestDispatcher("staff-login.jsp").forward(request, response);
                      String errorMsg = URLEncoder.encode("Invalid username or password","UTF-8");
                      response.sendRedirect("staff-login.jsp?error=" + errorMsg);
                }
                
            } 
    
}
