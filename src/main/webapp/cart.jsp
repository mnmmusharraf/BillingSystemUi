<%@ page session="true" import="java.util.*,java.text.DecimalFormat" %>
<%
    String username = (String) session.getAttribute("staffUser");
    if (username == null) {
        response.sendRedirect("staff-login.jsp");
        return;
    }

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Retrieve Cart
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if(cart==null || cart.isEmpty()){
%>
    <p class="text-center mt-5">Your cart is empty.</p>
<%
    return;
    }


   //Helper for currency format
   DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart / Bill</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-ligh">
        <div class="container py-5">
            <h2 class="mb-4 text-center">Your Cart / Bill</h2>
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Item Id</th>
                        <th>Name</th>
                        <th>Unit Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>  
                    </tr>
                </thead>
                <tbody id="item-table-body">
                    
                </tbody>
            </table>
        </div>
    </body>
</html>
