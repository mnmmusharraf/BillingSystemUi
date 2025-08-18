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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Generate Bill</title>
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
        }
        body {
            background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
            min-height: 100vh;
        }
        .bill-header {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
            padding: 1.5rem 1rem 1rem 1rem;
            margin-bottom: 2.2rem;
            text-align: center;
            font-weight: 700;
            font-size: 2rem;
            letter-spacing: 1px;
        }
        .search-bar {
            border-radius: 1rem;
            background-color: #f7fafd;
            border: 1px solid #e3e6ea;
            font-size: 1.08rem;
            max-width: 300px;
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
        .btn-cart {
            background: var(--main-blue-light);
            color: var(--main-blue-dark);
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            position: relative;
            transition: background 0.2s, color 0.2s;
        }
        .btn-cart:hover, .btn-cart:focus {
            background: var(--main-blue);
            color: #fff;
        }
        .btn-add {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1rem;
            font-weight: 500;
            border: none;
            transition: background 0.2s, color 0.2s;
        }
        .btn-add:hover, .btn-add:focus {
            background: linear-gradient(90deg, var(--main-blue-dark) 80%, var(--main-blue) 100%);
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
        .badge.bg-danger {
            font-size: 0.95rem;
            font-weight: 600;
            box-shadow: 0 1px 4px #ed556555;
        }
        @media (max-width: 600px) {
            .bill-header { font-size: 1.3rem; padding: 1rem 0.4rem 0.8rem 0.4rem; }
            .table th, .table td { font-size: 0.98rem; }
            .table-responsive { padding: 1rem 0.3rem; border-radius: 0.7rem; }
            .search-bar { max-width: 100%; }
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4">
        <div class="bill-header mb-4">
            <i class="bi bi-receipt me-2"></i> Add to Cart
        </div>
        
        <div class="row g-2 mb-4 align-items-center">
            <!-- Search box -->
            <div class="col-md-6">
                <input type="text" id="searchInput" class="form-control search-bar"
                       placeholder="Search by Item Name" 
                       aria-label="Search Item">
            </div>

            <!-- Search button -->
            <div class="col-md-auto">
                <button id="search" class="btn btn-blue w-100">
                    <span class="me-2 bi bi-search"></span> Search
                </button>
            </div>

            <!-- Loading spinner -->
            <div class="col-md-auto">
                <div class="loading-spinner spinner-border text-primary d-none" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>

            <!-- Cart button -->
            <div class="col-md-auto">
                <button id="viewCart" class="btn btn-cart position-relative">
                    <i class="bi bi-cart-fill"></i> Cart
                    <span id="cartCount" 
                          class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        0
                    </span>
                </button>
            </div>
        </div>

        <div class="table-responsive shadow-sm rounded">
            <table class="table table-bordered table-hover table-striped mb-0">
                <thead>
                    <tr>
                        <th>Item Id</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Stock Quantity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="item-table-body">
                    <tr>
                        <td colspan="5" class="text-center text-muted">No results yet</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const accountNum = urlParams.get("accountNum");
        let allItem = [];
        let cart = [];
        fetchItem();
        
        document.addEventListener("DOMContentLoaded",() => {
            document.getElementById("search").addEventListener("click",() => {
                let searchTerms = document.getElementById("searchInput").value.trim();
                if(searchTerms){
                    searchItem(searchTerms);
                }else{
                    fetchItem();
                }
            });
        });
        
        document.getElementById("searchInput").addEventListener("keypress", e => {
            if (e.key === "Enter") document.getElementById("search").click();
        });

        async function searchItem(searchTerms){
            const spinner = document.querySelector(".loading-spinner");
            spinner.style.display = "inline-block";
            
            try{
                const url = new URL("http://localhost:8080/BillingSystemBackend/api/item/search");
                url.search = new URLSearchParams({searchTerms}).toString();
                
                const response = await fetch(url);
                if(!response.ok) throw new Error("Http error " + response.status);
                
                const data = await response.json();
                allItem = data;
                renderTable(allItem);
            }catch(err){
                console.error(err);
                alert("Could not search");
            }finally{
                spinner.style.display = "none";
            }
        }
        
        function renderTable(data){
            const tableBody = document.getElementById("item-table-body");
            tableBody.innerHTML = "";
            
            if(data.length === 0){
                tableBody.innerHTML= `<tr>
                <td colspan="5" class="text-center text-muted">No matching items found.</td>
            </tr>`;
            return;
            }
            
            data.forEach(item => {
                const row = document.createElement("tr");
                
                const idCell = document.createElement("td");
                idCell.textContent = item.itemId;
                
                const nameCell = document.createElement("td");
                nameCell.textContent = item.itemName;
                
                const priceCell = document.createElement("td");
                priceCell.textContent = item.itemPrice;
                
                const quantityCell = document.createElement("td");
                quantityCell.textContent = item.stockQuantity;
                
                const actionCell = document.createElement("td");
                
                const qtyInput = document.createElement("input");
                qtyInput.type = "number";
                qtyInput.min = "1";
                qtyInput.value = "1"; 
                qtyInput.className = "form-control form-control-sm d-inline-block me-2";
                qtyInput.style.width = "70px"; 
                
                const addToCart = document.createElement("button");
                addToCart.textContent = "Add to Cart";
                addToCart.className = "btn btn-add btn-sm me-2";
                const API_BASE = "http://localhost:8080/BillingSystemBackend/api";
                // Add item to cart
                addToCart.onclick = function () {
                    const quantity = parseInt(qtyInput.value);
                    const cartItem = {
                        itemId: item.itemId,
                        quantity: quantity
                    };

                    fetch(API_BASE + "/cart/add", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(cartItem)
                    })
                    .then(response => {
                        if (!response.ok) throw new Error("HTTP error " + response.status);
                        return response.json();
                    })
                    .then(data => {
                        cart = data; // The API returns the whole updated cart
                        document.getElementById("cartCount").textContent = cart.length;
                    })
                    .catch(err => {
                        console.error(err);
                        alert("Error adding to cart.");
                    });
                };

                actionCell.appendChild(qtyInput);
                actionCell.appendChild(addToCart);
                
                row.appendChild(idCell);
                row.appendChild(nameCell);
                row.appendChild(priceCell);
                row.appendChild(quantityCell);
                row.appendChild(actionCell);
                
                tableBody.appendChild(row);
                
            });
        }
        
        async function fetchItem(){
            try{
                const response = await fetch("http://localhost:8080/BillingSystemBackend/api/item");
                if(!response.ok)
                    throw new Error("Http error " + response.status);
                
                const data = await response.json();
                allItem = data;
                renderTable(allItem);
            }catch(err){
                console.error("Failed to fetch Item", err);
                alert("Could not load item data. Check console for error.");
            }
        }

        document.getElementById("viewCart").onclick = function () {
            let url = "cart.jsp";
            if (accountNum) url += "?accountNum=" + encodeURIComponent(accountNum);
            window.location.href = url;
        };
    </script>
</body>
</html>