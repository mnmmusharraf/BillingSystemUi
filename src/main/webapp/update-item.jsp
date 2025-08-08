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
    <meta charset="UTF-8">
    <title>Update Item</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <script>
        let itemId = null;

        // Load item data from query parameter
        async function loadItemData() {
            const params = new URLSearchParams(window.location.search);
            itemId = params.get("id");
            if (!itemId) {
                alert("No item ID provided.");
                window.location.href = "manage-items.jsp";
                return;
            }

            try {
                const response = await fetch(`http://localhost:8080/BillingSystemBackend/api/item/${itemId}`);
                if (!response.ok) {
                    throw new Error("Failed to fetch item data");
                }

                const item = await response.json();
                document.getElementById("name").value = item.name;
                document.getElementById("price").value = item.price;
                document.getElementById("stockQuantity").value = item.stockQuantity;
            } catch (error) {
                console.error(error);
                alert("Error loading item data.");
            }
        }

        async function updateItem(event) {
            event.preventDefault();

            const name = document.getElementById("name").value.trim();
            const price = parseFloat(document.getElementById("price").value);
            const stockQuantity = parseInt(document.getElementById("stockQuantity").value);

            if (!name || isNaN(price) || isNaN(stockQuantity)) {
                alert("Please fill in all fields correctly.");
                return;
            }

            const updatedItem = { id: itemId, name, price, stockQuantity };

            try {
                const response = await fetch(`http://localhost:8080/BillingSystemBackend/api/item/${itemId}`, {
                    method: "PUT",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(updatedItem)
                });

                if (response.ok) {
                    alert("Item updated successfully!");
                    window.location.href = "manage-items.jsp";
                } else {
                    alert("Failed to update item.");
                }
            } catch (error) {
                console.error(error);
                alert("An error occurred while updating the item.");
            }
        }

        window.onload = loadItemData;
    </script>
</head>

<body class="container mt-5">
    <h2 class="mb-4">Update Item</h2>
    <form onsubmit="updateItem(event)" class="w-50">
        <div class="mb-3">
            <label for="name" class="form-label">Item Name:</label>
            <input type="text" id="name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">Price:</label>
            <input type="number" id="price" class="form-control" min="0" step="0.01" required>
        </div>

        <div class="mb-4">
            <label for="stockQuantity" class="form-label">Stock Quantity:</label>
            <input type="number" id="stockQuantity" class="form-control" min="0" required>
        </div>

        <button type="submit" class="btn btn-primary">Update Item</button>
        <a href="mng-item.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</body>
</html>
