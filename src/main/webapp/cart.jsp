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
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cart / Bill</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <h2 class="mb-4 text-center">Your Cart / Bill</h2>
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Item Id</th>
                    <th>Name</th>
                    <th>Unit Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody id="item-table-body">
                <!-- Data will be injected here -->
            </tbody>
            <tfoot>
                <tr class="table-secondary">
                    <td colspan="4" class="text-end fw-bold">Total</td>
                    <td id="total" class="fw-bold">0.00</td>
                </tr>
            </tfoot>
        </table>
        <div class="text-center mt-3">
            <button id="clearCart" class="btn btn-danger">Clear Cart</button>
        </div>
    </div>

    <script>
        var API_BASE = "http://localhost:8080/BillingSystemBackend/api";

        // Load cart from API
        fetch(API_BASE + "/cart")
            .then(function(res) { return res.json(); })
            .then(function(cart) {
                var tbody = document.getElementById("item-table-body");
                var total = 0;

                if (cart.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center">Your cart is empty.</td></tr>';
                    return;
                }

                var rows = "";
                cart.forEach(function(item) {
                    var subtotal = item.price * item.quantity;
                    total += subtotal;
                    rows +=
                        "<tr>" +
                            "<td>" + item.itemId + "</td>" +
                            "<td>" + item.name + "</td>" +
                            "<td>" + item.price.toFixed(2) + "</td>" +
                            "<td>" + item.quantity + "</td>" +
                            "<td>" + subtotal.toFixed(2) + "</td>" +
                        "</tr>";
                });

                tbody.innerHTML = rows;
                document.getElementById("total").textContent = total.toFixed(2);
            })
            .catch(function(err) {
                console.error("Error loading cart:", err);
            });

        // Clear cart
        document.getElementById("clearCart").addEventListener("click", function() {
            fetch(API_BASE + "/cart/clear", { method: "DELETE" })
                .then(function() {
                    location.reload();
                })
                .catch(function(err) { console.error("Error clearing cart:", err); });
        });
    </script>
</body>
</html>
