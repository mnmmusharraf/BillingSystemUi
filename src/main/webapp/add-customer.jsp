<%@ page session="true" %>
<% 
    String username = (String) session.getAttribute("staffUser");
    if(username==null){
       response.sendRedirect("staff-login.jsp");
       return;
    }
    
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires",0);
%> 

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Customer</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script>
            async function addCustomer(event){
                event.preventDefault();
                
                const name =  document.getElementById("name").value.trim();
                const address = document.getElementById("address").value.trim();
                const telephone = document.getElementById("telephone").value.trim();
                
                try{
                    const customer = {name,address,telephone};
                    
                    const response = await fetch("http://localhost:8080/BillingSystemBackend/api/customer", {
                        method: "POST",
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify(customer)
                    });
                    
                    if(response.ok){
                        alert("Customer added successfully!");
                        window.location.href = "mng-customer.jsp";
                    }else{
                        alert("Failed to add customer.");
                    }
                    
                }catch(error){
                    console.error("Error", error);
                    alert("Error occured while adding customer.");
                }
            }
        </script>
    </head>
    <body class="container mt-4">
        <h2 class="mb-4">Add New Customer</h2>
        <form onsubmit="addCustomer(event)" class="w-50">
            <div class="mb-3">
                <label for="name" class="form-label">Name</label>
                <input type="text" id="name" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label for="address" class="form-label">Address</label>
                <input type="text" id="address" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label for="telephone" class="form-label">Telephone</label>
                <input type="text" id="telephone" class="form-control" required>
            </div>
            
            <button type="submit" class="btn btn-primary">Add Customer</button>
            <a href="mng-customer.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </body>
</html>
