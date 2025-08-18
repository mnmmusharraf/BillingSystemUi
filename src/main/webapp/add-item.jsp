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
<html lang="en">
<head>
    <title>Add New Item</title>
    <meta charset="UTF-8">
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
        }
        body {
            background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
            min-height: 100vh;
        }
        .form-container {
            background: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 4px 24px rgba(52,120,246,0.09);
            border: 1px solid #eaeaea;
            max-width: 430px;
            margin: 3rem auto;
            padding: 2.5rem 2rem 2rem 2rem;
        }
        .form-title {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1rem 1rem 0 0;
            box-shadow: 0 2px 8px rgba(52,120,246,0.08);
            padding: 1rem 1rem 0.7rem 1.2rem;
            margin-bottom: 2rem;
            text-align: center;
            font-weight: 700;
            font-size: 1.35rem;
            letter-spacing: 1px;
        }
        .form-label {
            color: var(--main-blue);
            font-weight: 500;
        }
        .form-control {
            border-radius: 1rem;
            background-color: #f7fafd;
            font-size: 1.09rem;
        }
        .form-control:focus {
            border-color: var(--main-blue);
            box-shadow: 0 0 0 0.1rem rgba(52,120,246,.10);
            background-color: #f4f8ff;
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
        .btn-cancel {
            border-radius: 1rem;
            font-weight: 500;
            background: var(--danger-soft);
            color: var(--danger);
            border: none;
            transition: background 0.2s, color 0.2s;
            margin-left: 0.8rem;
        }
        .btn-cancel:hover, .btn-cancel:focus {
            background: var(--danger);
            color: #fff;
        }
        @media (max-width: 600px) {
            .form-container { padding: 1.2rem 0.5rem 1rem 0.5rem; margin-top: 1.5rem; }
            .form-title { font-size: 1.09rem; padding: 0.7rem 0.3rem 0.5rem 0.5rem; }
        }
    </style>
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
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="form-container">
        <div class="form-title">
            <i class="bi bi-plus-circle me-2"></i> Add New Item
        </div>
        <form onsubmit="addItem(event)">
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

            <button type="submit" class="btn btn-blue"><i class="bi bi-plus"></i> Add Item</button>
            <a href="mng-item.jsp" class="btn btn-cancel">Cancel</a>
        </form>
    </div>
</body>
</html>