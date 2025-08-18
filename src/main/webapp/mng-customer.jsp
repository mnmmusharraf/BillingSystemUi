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
    <title>Manage Customers</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        :root {
            --main-blue: #3478f6;
            --main-blue-dark: #1e50a2;
            --main-blue-light: #eaf1fb;
            --danger: #ed5565;
            --danger-soft: #fbe3e5;
            --edit-blue: #eaf1fb;
            --edit-blue-hover: #d4e8fd;
        }
        body {
            background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
            min-height: 100vh;
        }
        .customer-header {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
            padding: 1.5rem 1rem 1rem 1rem;
            margin-bottom: 2.2rem;
        }
        .customer-header h2 {
            margin: 0;
            font-weight: 700;
        }
        .search-bar {
            border-radius: 1rem;
            background-color: #f7fafd;
            border: 1px solid #e3e6ea;
            font-size: 1.08rem;
            max-width: 300px;
        }
        .table-responsive {
            background: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 4px 16px rgba(52,120,246,0.07);
            border: 1px solid #f3f4f7;
            padding: 1.5rem 1rem;
        }
        .table th {
            background: var(--main-blue) !important;
            color: #fff !important;
            border: none;
            font-weight: 600;
        }
        .table-striped>tbody>tr:nth-of-type(odd)>* {
            background-color: #f7fafd;
        }
        .table th, .table td {
            vertical-align: middle;
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
        .btn-edit {
            background: var(--edit-blue);
            color: var(--main-blue-dark);
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .btn-edit:hover, .btn-edit:focus {
            background: var(--edit-blue-hover);
            color: var(--main-blue);
        }
        .btn-delete {
            background: var(--danger-soft);
            color: var(--danger);
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .btn-delete:hover, .btn-delete:focus {
            background: var(--danger);
            color: #fff;
        }
        .btn-outline-success {
            border-radius: 1rem;
            font-weight: 500;
            border: none;
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff !important;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
            transition: background 0.2s;
        }
        .btn-outline-success:hover, .btn-outline-success:focus {
            background: linear-gradient(90deg, var(--main-blue-dark) 80%, var(--main-blue) 100%);
            color: #fff !important;
        }
        @media (max-width: 600px) {
            .customer-header { padding: 1rem 0.4rem 0.8rem 0.4rem; }
            .table th, .table td { font-size: 0.98rem; }
            .table-responsive { padding: 1rem 0.3rem; border-radius: 0.7rem; }
            .search-bar { max-width: 100%; }
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4">
        <div class="customer-header text-center mb-4">
            <h2><i class="bi bi-person-bounding-box me-2"></i> Manage Customers</h2>
        </div>
        
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-3 gap-2">
            <a href="add-customer.jsp" class="btn btn-outline-success mb-2 mb-md-0">
                <i class="bi bi-person-plus-fill"></i> Add New Customer
            </a>
            <input type="text" id="searchInput" class="form-control search-bar" placeholder="Search customers by name, address, or telephone..." />
        </div>
        
        <!-- Customers Table -->
        <div class="table-responsive">
        <table class="table table-bordered table-hover table-striped align-middle">
            <thead>
                <tr>
                    <th>Account Number</th>
                    <th>Name</th>
                    <th>Address</th>
                    <th>Telephone</th>
                    <th>Units Consumed</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody id="customer-table-body">
                <!-- JavaScript will load rows --> 
            </tbody>
        </table>
        </div>
    </div>
    
    <script>
        let allCustomer = [];
        
        document.addEventListener("DOMContentLoaded",()=> {
            fetchCustomer();
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
                actionCell.className = "text-center";
                
                const editBtn = document.createElement("button");
                editBtn.innerHTML = '<i class="bi bi-pencil-square"></i> Edit';
                editBtn.className = "btn btn-edit btn-sm me-2";
                editBtn.onclick = function (){
                    window.location.href = "edit-customer.jsp?accountNum=" + customer.accountNumber;
                };
                
                const deleteBtn = document.createElement("button");
                deleteBtn.innerHTML = '<i class="bi bi-trash-fill"></i> Delete';
                deleteBtn.className = "btn btn-delete btn-sm";
                deleteBtn.onclick = function () {
                    deleteCustomer(customer.accountNumber);
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
            const confirmed = window.confirm("Are you sure want to delete this customer?");
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
                    alert("Failed to delete customer.");
                }
            }catch(err){
                console.error("Error deleting customer: ", err);
                alert("An error occurred while deleting.");
            }
        }
    </script>
</body>
</html>