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
        <title>Manage Customers</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">  
        <div class="container py-5">
            <div class="mb-4 text-center">
                <h2>Manage Customers</h2>
            </div>
            
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <a href="add-customer.jsp" class="btn btn-outline-success">Add New Customer</a>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search..." style="width: 250px"/>
                </div>
            </div>
            
            <!-- Customers Table -->
            <table class="table table-bordered table-hover table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Account Number</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Telephone</th>
                        <th>Units Consumed</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="customer-table-body">
                    <!-- JavaScript will load rows --> 
                </tbody>
            </table>   
        </div>
        
        <script>
            let allCustomer = [];
            
            document.addEventListener("DOMContentLoaded",()=> {
                fetchCustomer();
                
                // Add search functionality
                document.getElementById("searchInput").addEventListener("input",function(){
                    const query = this.value.toLowerCase();
                    const filtered = allCustomer.filter(customer =>
                            customer.accountNumber.toLowerCase().includes(query) ||
                                    customer.name.toLowerCase().includes(query)||
                                    customer.address.toLowerCase().includes(query)||
                                    customer.telephone.toLowerCase().includes(query)
                                    );
                            renderTable(filtered);
                });
            });
            
            async function fetchCustomer(){
                try{
                    const response = await fetch("http://localhost:8080/BillingSystemBackend/api/customer");
                    if(!response.ok)
                        throw new Error("Http error " + response.status);
                    
                    const data = await response.json();
                    console.log("Fetched customer data: " , data);
                    
                    allCustomer = data;
                    renderTable(allCustomer);
                }catch(err){
                    console.error("Failed to fetch customer",err);
                    alert("Could not load customer data. Check console for error.");
                }
            }
            
            function renderTable(data){
                const tableBody = document.getElementById("customer-table-body");
                tableBody.innerHTML = "";
                
                data.forEach(customer => {
                    const row = document.createElement("tr");
                    
                    const accountNumCell = document.createElement("td");
                    accountNumCell.textContent = customer.accountNumber;
                    
                    const nameCell = document.createElement("td");
                    nameCell.textContent = customer.name;
                    
                    const addressCell =  document.createElement("td");
                    addressCell.textContent = customer.address;
                    
                    const telephoneCell = document.createElement("td");
                    telephoneCell.textContent = customer.telephone;
                    
                    const unitsConsumedCell = document.createElement("td");
                    unitsConsumedCell.textContent = customer.consumedUnits;
                    
                    const actionCell = document.createElement("td");
                    
                    const editBtn = document.createElement("button");
                    editBtn.textContent = "Edit";
                    editBtn.className = "btn btn-warning btn-sm me-2";
                    editBtn.onclick = function (){
                        window.location.href = "edit-customer.jsp?accountNum=" + customer.accountNum;
                    };
                    
                    const deleteBtn = document.createElement("button");
                    deleteBtn.textContent = "Delete";
                    deleteBtn.className = "btn btn-danger btn-sm";
                    deleteBtn.onclick = function () {
                        deleteCustomer(customer.accountNum);
                    };
                    
                    actionCell.appendChild(editBtn);
                    actionCell.appendChild(deleteBtn);
                    
                    row.appendChild(accountNumCell);
                    row.appendChild(nameCell);
                    row.appendChild(addressCell);
                    row.appendChild(telephoneCell);
                    row.appendChild(unitsConsumedCell);
                    row.appendChild(actionCell);
                    
                    tableBody.appendChild(row);
                });
            }
            
            async function deleteCustomer(accountNum){
                const confirmed = window.confirm("Are you sure want to delete this Customer");
                if(!confirmed)
                    return;
                
                try{
                    const url = "http://localhost:8080/BillingSystemBackend/api/customer/" + accountNum;
                    const response = await fetch(url, {
                        method: "DELETE"
                    });
                    
                    if(response.ok) {
                        alert("Customer deleted successfully!");
                        fetchCustomer();
                    }else{
                        alert("Failed to delete Customer");
                    }
                }catch(err){
                    console.error("Error deleting customer: ", err);
                    alert("An error occured while deleting!.");
                }
            }
            
        </script>
        
    </body>
</html>
