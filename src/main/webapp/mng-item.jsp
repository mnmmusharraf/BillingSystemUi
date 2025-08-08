<%@ page session="true" %>
<% 
    String username = (String) session.getAttribute("staffUser");
    if(username==null){
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
        <title>Manage Items</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="mb-4 text-center">
                <h2>Manage Items</h2>
            </div>
            
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <a href="add-items.jsp" class="btn btn-outline-success">Add New Item</a>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search..." style="width: 250px"/>
                </div>
            </div>
            <!-- Items Table -->
            <table class="table table-bordered table-hover table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Item ID</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Stock Quantity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="item-table-body">
                    <!-- JavaScript will load rows -->
                </tbody>
            </table>
        </div>
        <script>
            let allItem = [];
            
            document.addEventListener("DOMContentLoaded",()=>{
                fetchItem();
                
                // Add search functionlity
                document.getElementById("searchInput").addEventListener("input",function(){
                    const query = this.value.toLowerCase();
                    const filtered = allItem.filter(item => 
                        item.itemId.toLowerCase().includes(query)||
                        item.name.toLowerCase().includes(query)
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
                    console.log("Fetched item data: ", data);
                    
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
                    nameCell.textContent = item.name;
                    
                    const priceCell = document.createElement("td");
                    priceCell.textContent = item.price;
                    
                    const stockQuantityCell = document.createElement("td");
                    stockQuantityCell.textContent = item.stockQuantity;
                    
                    const actionCell = document.createElement("td");
                    
                    const editBtn = document.createElement("button");
                    editBtn.textContent = "Edit";
                    editBtn.className = "btn btn-warning btn-sm me-2";
                    editBtn.onclick = function () {
                        window.location.href = "edit-item.jsp?itemId=" + item.itemId;
                    };
                    
                    const deleteBtn = document.createElement("button");
                    deleteBtn.textContent = "Delete";
                    deleteBtn.className = "btn btn-danger btn-sm";
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
