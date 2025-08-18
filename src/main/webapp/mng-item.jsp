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
    <title>Manage Items</title>
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
            --edit-blue: #eaf1fb;
            --edit-blue-hover: #d4e8fd;
        }
        body {
            background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
            min-height: 100vh;
        }
        .item-header {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
            padding: 1.5rem 1rem 1rem 1rem;
            margin-bottom: 2.2rem;
        }
        .item-header h2 {
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
            border: 1px solid #e3e6ea;
            padding: 1.5rem 1rem;
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
            .item-header { padding: 1rem 0.4rem 0.8rem 0.4rem; }
            .table th, .table td { font-size: 0.98rem; }
            .table-responsive { padding: 1rem 0.3rem; border-radius: 0.7rem; }
            .search-bar { max-width: 100%; }
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4">
        <div class="item-header text-center mb-4">
            <h2><i class="bi bi-box-seam me-2"></i> Manage Items</h2>
        </div>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-3 gap-2">
            <a href="add-item.jsp" class="btn btn-outline-success mb-2 mb-md-0">
                <i class="bi bi-plus-circle"></i> Add New Item
            </a>
            <input type="text" id="searchInput" class="form-control search-bar" placeholder="Search items by name or ID..." />
        </div>
        <!-- Items Table -->
        <div class="table-responsive">
        <table class="table table-bordered table-hover table-striped align-middle">
            <thead>
                <tr>
                    <th>Item ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Stock Quantity</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody id="item-table-body">
                <!-- JavaScript will load rows -->
            </tbody>
        </table>
        </div>
    </div>
    <script>
        let allItem = [];
        
        document.addEventListener("DOMContentLoaded",()=>{
            fetchItem();
            document.getElementById("searchInput").addEventListener("input",function(){
                const query = this.value.toLowerCase();
                const filtered = allItem.filter(item => 
                    item.itemId.toString().toLowerCase().includes(query)||
                    item.itemName.toLowerCase().includes(query)
                );
                renderTable(filtered);
            });
        });
        
        async function fetchItem(){
            try{
                const response = await fetch("http://localhost:8080/BillingSystemBackend/api/item");
                if(!response.ok)
                    throw new Error("Http error" + response.status);
                
                const data = await response.json();
                allItem = data;
                renderTable(allItem);
            }catch(err){
                console.error("Failed to fetch Item", err);
                alert("Could not load item data. Check console for error.");
            }
        }
        
        function renderTable(data){
            const tableBody = document.getElementById("item-table-body");
            tableBody.innerHTML = "";
            
            data.forEach(item => {
                const row = document.createElement("tr");
                
                const idCell = document.createElement("td");
                idCell.textContent = item.itemId;
                
                const nameCell = document.createElement("td");
                nameCell.textContent = item.itemName;
                
                const priceCell = document.createElement("td");
                priceCell.textContent = item.itemPrice;
                
                const stockQuantityCell = document.createElement("td");
                stockQuantityCell.textContent = item.stockQuantity;
                
                const actionCell = document.createElement("td");
                actionCell.className = "text-center";
                
                const editBtn = document.createElement("button");
                editBtn.innerHTML = '<i class="bi bi-pencil-square"></i> Edit';
                editBtn.className = "btn btn-edit btn-sm me-2";
                editBtn.onclick = function () {
                    window.location.href = "edit-item.jsp?itemId=" + item.itemId;
                };
                
                const deleteBtn = document.createElement("button");
                deleteBtn.innerHTML = '<i class="bi bi-trash-fill"></i> Delete';
                deleteBtn.className = "btn btn-delete btn-sm";
                deleteBtn.onclick = function (){
                    deleteItem(item.itemId);
                };
                
                actionCell.appendChild(editBtn);
                actionCell.appendChild(deleteBtn);
                
                row.appendChild(idCell);
                row.appendChild(nameCell);
                row.appendChild(priceCell);
                row.appendChild(stockQuantityCell);
                row.appendChild(actionCell);
                
                tableBody.appendChild(row);
            });
        }
        
        async function deleteItem(itemId){
            const confirmed = window.confirm("Are you sure want to delete this Item.");
            if(!confirmed)
                return;
            
            try{
                const url = "http://localhost:8080/BillingSystemBackend/api/item/" + itemId;
                const response = await fetch(url,{
                    method: "DELETE"
                });
                
                if(response.ok){
                    alert("Item deleted successfully.");
                    fetchItem();
                }else{
                    alert("Failed to delete Item.");
                }
            }catch(err){
                console.error("Error deleting item.", err);
                alert("An error occured while deleting.");
            }
        }
    </script>
</body>
</html>