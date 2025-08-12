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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Generate Bill</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .loading-spinner{
                display: none;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="mb-4 text-center">
                <h2>Add to Cart</h2>
            </div>
            
            <div class="row g-2 mb-4">
                <div class="col-md-6">
                    <input type="text" id="searchInput" class="form-control"
                           placeholder="Search by Item Name" 
                           aria-label="Search Item">
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
            
            <div class="table-responsive shadow-sm rounded">
                <table class="table table-bordered table-hover table-striped mb-0">
                    <thead class="table-dark">
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
                    
                    const addToCart = document.createElement("button");
                    addToCart.textContent = "Add to Cart";
                    addToCart.className = "btn btn-warning btn-sm me-2";
                    addToCart.onclick = function (){
                        //window.location.href = "billing.jsp?accountNum=" + customer.accountNumber;
                    };
                    
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
                        throw new Error("Http error" + response.status);
                    
                    const data = await response.json();
                    console.log("Fetched item data: ", data);
                    
                    allItem = data;
                    renderTable(allItem);
                }catch(err){
                    console.error("Failed to fetch Item", err);
                    alert("Could not load item data. Check console for error.");
                }
            }
            
        </script>
    </body>
</html>
