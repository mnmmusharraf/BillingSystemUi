<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("staffUser");
    if (username == null) {
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
    <title>Add New Item</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <script>
        async function addItem(event) {
            event.preventDefault();

            const itemName = document.getElementById("itemName").value.trim();
            const itemPrice = parseFloat(document.getElementById("itemPrice").value);
            const stockQuantity = parseInt(document.getElementById("stockQuantity").value);

            if (!itemName || isNaN(itemPrice) || isNaN(stockQuantity)) {
                alert("Please fill in all fields correctly.");
                return;
            }

            // Check item name uniqueness before proceeding
            try {
                const url = new URL("http://localhost:8080/BillingSystemBackend/api/item/check-unique");
                url.search = new URLSearchParams({itemName}).toString();

                const checkResponse = await fetch(url);
                if (!checkResponse.ok) {
                    alert("Failed to check item name uniqueness.");
                    return;
                }

                const checkResult = await checkResponse.json();

                if (checkResult.itemNameExists) {
                    alert("Item name already exists. Please choose another.");
                    return;
                }

                const item = { itemName, itemPrice, stockQuantity };

                const response = await fetch("http://localhost:8080/BillingSystemBackend/api/item", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(item)
                });

                if (response.ok) {
                    alert("Item added successfully!");
                    window.location.href = "mng-item.jsp";
                } else {
                    alert("Failed to add item.");
                }

            } catch (error) {
                console.error("Error:", error);
                alert("An error occurred while adding the item.");
            }
        }
    </script>
</head>

<body class="container mt-5">
    <h2 class="mb-4">Add New Item</h2>
    <form onsubmit="addItem(event)" class="w-50">
        <div class="mb-3">
            <label for="itemName" class="form-label">Item Name:</label>
            <input type="text" id="itemName" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="itemPrice" class="form-label">Price:</label>
            <input type="number" id="itemPrice" class="form-control" min="0" step="0.01" required>
        </div>

        <div class="mb-4">
            <label for="stockQuantity" class="form-label">Stock Quantity:</label>
            <input type="number" id="stockQuantity" class="form-control" min="0" required>
        </div>

        <button type="submit" class="btn btn-primary">Add Item</button>
        <a href="manage-items.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</body>
</html>
