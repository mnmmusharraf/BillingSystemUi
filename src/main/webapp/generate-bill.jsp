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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Customer</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        :root {
            --main-blue: #3478f6;
            --main-blue-dark: #1e50a2;
            --main-blue-light: #eaf1fb;
            --warning: #f6c347;
            --warning-soft: #fffbe7;
        }
        body {
            background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
            min-height: 100vh;
        }
        .find-header {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
            padding: 1.5rem 1rem 1rem 1rem;
            margin-bottom: 2.2rem;
        }
        .find-header h2 {
            margin: 0;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .search-bar {
            border-radius: 1rem;
            background-color: #f7fafd;
            border: 1px solid #e3e6ea;
            font-size: 1.08rem;
            max-width: 350px;
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
        .btn-billing {
            background: var(--main-blue-light);
            color: var(--main-blue-dark);
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .btn-billing:hover, .btn-billing:focus {
            background: var(--main-blue);
            color: #fff;
        }
        .table-responsive {
            background: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 4px 16px rgba(52,120,246,0.07);
            border: 1px solid #e3e6ea;
            padding: 1.2rem 1rem;
        }
        .table th {
            background: var(--main-blue) !important;
            color: #fff !important;
            border: none;
            font-weight: 600;
        }
        .table-striped>tbody>tr:nth-of-type(odd)>* {
            background-color: #eaf1fb;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .loading-spinner {
            display: none;
        }
        @media (max-width: 600px) {
            .find-header { padding: 1rem 0.4rem 0.8rem 0.4rem; }
            .table th, .table td { font-size: 0.98rem; }
            .table-responsive { padding: 1rem 0.3rem; border-radius: 0.7rem; }
            .search-bar { max-width: 100%; }
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4">
        <!-- Page title -->
        <div class="find-header text-center mb-4">
            <h2><i class="bi bi-search me-2"></i> Find Customer</h2>
        </div>

        <!-- Search Section -->
        <div class="row g-2 mb-4 justify-content-center">
            <div class="col-md-6 col-12">
                <input type="text" id="searchInput" class="form-control search-bar" 
                       placeholder="Search by Account Number, Name, Address, or Telephone" 
                       aria-label="Search Customer">
            </div>
            <div class="col-md-auto col-12 d-grid">
                <button id="search" class="btn btn-blue w-100">
                    <span class="me-2 bi bi-search"></span> Search
                </button>
            </div>
            <div class="col-md-auto col-12 d-flex align-items-center">
                <div class="loading-spinner spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-responsive shadow-sm rounded">
            <table class="table table-bordered table-hover table-striped mb-0">
                <thead>
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
                startBilling.className = "btn btn-billing btn-sm me-2";
                startBilling.onclick = function (){
                    // Clear cart for new customer
                    fetch("http://localhost:8080/BillingSystemBackend/api/cart/clear", { method: "DELETE" })
                        .then(() => {
                            window.location.href = "billing.jsp?accountNum=" + customer.accountNumber;
                        })
                        .catch(() => {
                            window.location.href = "billing.jsp?accountNum=" + customer.accountNumber;
                        });
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