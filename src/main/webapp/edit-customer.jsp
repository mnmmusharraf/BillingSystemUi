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
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
        <style>
            :root {
                --main-blue: #3478f6;
                --main-blue-dark: #1e50a2;
                --main-blue-light: #eaf1fb;
                --danger: #ed5565;
                --danger-soft: #fbe3e5;
            }
            body {
                background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
                min-height: 100vh;
            }
            .form-container {
                background: #fff;
                border-radius: 1.2rem;
                box-shadow: 0 4px 24px rgba(52,120,246,0.09);
                border: 1px solid #eaeaea;
                max-width: 430px;
                margin: 3rem auto;
                padding: 2.5rem 2rem 2rem 2rem;
            }
            .form-title {
                background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
                color: #fff;
                border-radius: 1rem 1rem 0 0;
                box-shadow: 0 2px 8px rgba(52,120,246,0.08);
                padding: 1rem 1rem 0.7rem 1.2rem;
                margin-bottom: 2rem;
                text-align: center;
                font-weight: 700;
                font-size: 1.35rem;
                letter-spacing: 1px;
            }
            .form-label {
                color: var(--main-blue);
                font-weight: 500;
            }
            .form-control {
                border-radius: 1rem;
                background-color: #f7fafd;
                font-size: 1.09rem;
            }
            .form-control:focus {
                border-color: var(--main-blue);
                box-shadow: 0 0 0 0.1rem rgba(52,120,246,.10);
                background-color: #f4f8ff;
            }
            .btn-blue {
                background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
                color: #fff;
                border: none;
                border-radius: 1rem;
                font-weight: 500;
                box-shadow: 0 2px 8px rgba(52,120,246,0.09);
                transition: background 0.2s;
            }
            .btn-blue:hover, .btn-blue:focus {
                background: linear-gradient(90deg, var(--main-blue-dark) 80%, var(--main-blue) 100%);
                color: #fff;
            }
            .btn-cancel {
                border-radius: 1rem;
                font-weight: 500;
                background: var(--danger-soft);
                color: var(--danger);
                border: none;
                transition: background 0.2s, color 0.2s;
                margin-left: 0.8rem;
            }
            .btn-cancel:hover, .btn-cancel:focus {
                background: var(--danger);
                color: #fff;
            }
            @media (max-width: 600px) {
                .form-container { padding: 1.2rem 0.5rem 1rem 0.5rem; margin-top: 1.5rem; }
                .form-title { font-size: 1.09rem; padding: 0.7rem 0.3rem 0.5rem 0.5rem; }
            }
        </style>
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
    <body>
        <%@ include file="billing-navbar.jsp" %>
        <div class="form-container">
            <div class="form-title">
                <i class="bi bi-pencil-square me-2"></i> Edit Customer
            </div>
            <form onsubmit="updateCustomer(event)">
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

                <button type="submit" class="btn btn-blue"><i class="bi bi-save"></i> Update Customer</button>
                <a href="mng-customer.jsp" class="btn btn-cancel">Cancel</a>
            </form>
        </div>
    </body>
</html>