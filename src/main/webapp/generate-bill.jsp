<%@ page session="true" %>
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
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Find Customer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .loading-spinner {
            display: none;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        
        <!-- Page title -->
        <div class="text-center mb-4">
            <h2 class="fw-bold">Find Customer</h2>
        </div>

        <!-- Search Section -->
        <div class="row g-2 mb-4">
            <div class="col-md-6">
                <input type="text" id="searchInput" class="form-control" 
                       placeholder="Search by Account Number, Name, Address, or Telephone" 
                       aria-label="Search Customer">
            </div>
            <div class="col-md-auto">
                <button id="search" class="btn btn-primary w-100">
                    <span class="me-2 bi bi-search"></span> Search
                </button>
            </div>
            <div class="col-md-auto">
                <div class="loading-spinner spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-responsive shadow-sm rounded">
            <table class="table table-bordered table-hover table-striped mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Account Number</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Telephone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="customer-table-body">
                    <tr>
                        <td colspan="5" class="text-center text-muted">No results yet</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        let allCustomer = [];
        fetchCustomer();

        document.addEventListener("DOMContentLoaded", () => {
            document.getElementById("search").addEventListener("click", () => {
                let searchTerms = document.getElementById("searchInput").value.trim();
                if (searchTerms) {
                    searchCustomer(searchTerms);
                } else {
                    fetchCustomer();
                }
            });
        });
        
        document.getElementById("searchInput").addEventListener("keypress", e => {
                if (e.key === "Enter") document.getElementById("search").click();
            });

        async function searchCustomer(searchTerms) {
            const spinner = document.querySelector(".loading-spinner");
            spinner.style.display = "inline-block";

            try {
                const url = new URL("http://localhost:8080/BillingSystemBackend/api/customer/search");
                url.search = new URLSearchParams({ searchTerms }).toString();

                const response = await fetch(url);
                if (!response.ok) throw new Error("HTTP error " + response.status);

                const data = await response.json();
                allCustomer = data;
                renderTable(allCustomer);

            } catch (err) {
                console.error(err);
                alert("Could not search.");
            } finally {
                spinner.style.display = "none";
            }
        }

        function renderTable(data) {
            const tableBody = document.getElementById("customer-table-body");
            tableBody.innerHTML = "";

            if (data.length === 0) {
                tableBody.innerHTML = `<tr>
                    <td colspan="5" class="text-center text-muted">No matching customers found.</td>
                </tr>`;
                return;
            }

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
                    
                    const actionCell = document.createElement("td");
                    
                    const startBilling = document.createElement("button");
                    startBilling.textContent = "Start Billing";
                    startBilling.className = "btn btn-warning btn-sm me-2";
                    startBilling.onclick = function (){
                        window.location.href = "billing.jsp?accountNum=" + customer.accountNumber;
                    };
                    
                    actionCell.appendChild(startBilling);
                    
                    row.appendChild(accountNumCell);
                    row.appendChild(nameCell);
                    row.appendChild(addressCell);
                    row.appendChild(telephoneCell);
                    
                    row.appendChild(actionCell);
                    
                    tableBody.appendChild(row);
                });
        }
        
        
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
    </script>
</body>
</html>