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
            const urlParams = new URLSearchParams(window.location.search);
            const itemId = urlParams.get("itemId");

            let originalName = "";
            let originalPrice = 0;
            let originalStock = 0;

            document.addEventListener("DOMContentLoaded", async function () {
                if (!itemId) {
                    alert("No Item ID provided.");
                    window.location.href = "mng-item.jsp";
                    return;
                }

                try {
                    const res = await fetch("http://localhost:8080/BillingSystemBackend/api/item/" + itemId);
                    if (!res.ok) {
                        throw new Error("Failed to fetch item details.");
                    }

                    const item = await res.json();
                    document.getElementById("itemName").value = item.itemName;
                    document.getElementById("itemPrice").value = item.itemPrice;
                    document.getElementById("stockQuantity").value = item.stockQuantity;

                    originalName = item.itemName;
                    originalPrice = item.itemPrice;
                    originalStock = item.stockQuantity;
                } catch (err) {
                    console.error("Failed to load item.", err);
                    alert("Failed to load item data.");
                }
            });

            async function updateItem(event) {
                event.preventDefault();

                const name = document.getElementById("itemName").value.trim();
                const price = parseFloat(document.getElementById("itemPrice").value);
                const stockQuantity = parseInt(document.getElementById("stockQuantity").value);

                if (!name || isNaN(price) || isNaN(stockQuantity)) {
                    alert("Please fill in all fields correctly.");
                    return;
                }

                // ✅ Check for unique item name only if name was changed
                if (name !== originalName) {
                    try {
                        const url = new URL("http://localhost:8080/BillingSystemBackend/api/item/check-unique");
                        url.search = new URLSearchParams({itemName: name}).toString();

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
                    } catch (err) {
                        console.error("Uniqueness check failed", err);
                        alert("Could not verify item name uniqueness.");
                        return;
                    }
                }

                const updatedItem = {
                    itemId,
                    itemName: name,
                    itemPrice: price,
                    stockQuantity
                };

                try {
                    const updateResponse = await fetch("http://localhost:8080/BillingSystemBackend/api/item/" + itemId, {
                        method: "PUT",
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify(updatedItem)
                    });

                    if (updateResponse.ok) {
                        alert("Item updated successfully!");
                        window.location.href = "mng-item.jsp";
                    } else {
                        alert("Failed to update item.");
                    }
                } catch (err) {
                    console.error("Error updating item.", err);
                    alert("An error occurred while updating the item.");
                }
            }
        </script>

    </head>

    <body class="container mt-5">
        <h2 class="mb-4">Update Item</h2>
        <form onsubmit="updateItem(event)" class="w-50">
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

            <button type="submit" class="btn btn-primary">Update Item</button>
            <a href="mng-item.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </body>
</html>
