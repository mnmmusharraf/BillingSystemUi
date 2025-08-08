<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("staffUser");
    if(username == null){
       response.sendRedirect("staff-login.jsp");
       return;
    }
    
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            const accountNum = urlParams.get("accountNum");
            let originalName = "";
            let originalAddress = "";
            let originalTelephone = "";
            document.addEventListener("DOMContentLoaded", async function(){
            if (!accountNum){
            alert("No Customer Account Number provided.");
            window.location.href = "mng-customer.jsp";
            return;
            }

            try{
            const res = await fetch("http://localhost:8080/BillingSystemBackend/api/customer/" + accountNum);
            if (!res.ok){
            throw new Error("Failed to fetch Customer details.");
            }

            const customer = await res.json();
            document.getElementById("name").value = customer.name;
            document.getElementById("address").value = customer.address;
            document.getElementById("telephone").value = customer.telephone;
            originalName = customer.name;
            originalAddress = customer.address;
            originalTelephone = customer.telephone;
            } catch (err){
            console.error("Failed to load Customer.", err);
            alert("Failed to load Customer data.");
            //window.location.href = "mng-customer.jsp";
            }
            });
            async function updateCustomer(event){
            event.preventDefault();
            const name = document.getElementById("name").value.trim();
            const address = document.getElementById("address").value.trim();
            const telephone = document.getElementById("telephone").value.trim();
            const updatedCustomer = {name, address, telephone};
            try{
            const updateResponse = await fetch("http://localhost:8080/BillingSystemBackend/api/customer/" + accountNum, {
            method: "PUT",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify(updatedCustomer)
            });
            if (updateResponse.ok){
            alert("Customer Updated successfully.");
            window.location.href = "mng-customer.jsp";
            } else{
            alert("Failed to update customer.");
            }
            } catch (err){
            console.error("Error updating customer.", err);
            alert("Error occured while updating customer.");
            }
            }
        </script>
    </head>
    <body class="container mt-4">
        <h2 class="mb-4">Edit Customer</h2>
        <form onsubmit="updateCustomer(event)" class="w-50">
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

            <button type="submit" class="btn btn-primary">Update Customer</button>
            <a href="mng-customer.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </body>
</html>
