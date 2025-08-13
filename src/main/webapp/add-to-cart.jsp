<%@ page import="java.util.*" %>
<%
    

    int itemId = Integer.parseInt(request.getParameter("itemId"));
    int qty = Integer.parseInt(request.getParameter("qty"));

    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }

    Map<String, Object> cartItem = new HashMap<>();
    cartItem.put("itemId", itemId);
    cartItem.put("qty", qty);

    cart.add(cartItem);

    session.setAttribute("cart", cart);

    response.setContentType("application/json");
    out.print("{\"status\":\"success\"}");
%>
