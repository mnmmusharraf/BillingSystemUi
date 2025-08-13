<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("staffUser");
    if (username == null) {
        response.sendRedirect("staff-login.jsp");
        return;
    }
    
    // Save accountNum from URL into session
    String accountNumParam = request.getParameter("accountNum");
    if (accountNumParam != null) {
        session.setAttribute("accountNum", accountNumParam);
    }
    String accountNum = (String) session.getAttribute("accountNum");


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
         <h5 class="text-center mb-4">
            Account Number: <%= accountNum != null ? accountNum : "Not set" %>
        </h5>
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Item Id</th>
                    <th>Name</th>
                    <th>Unit Price</th>
                    <th>Quantity</th>
                    <th>Actions</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody id="item-table-body">
                <!-- Data will be injected here -->
            </tbody>
            <tfoot>
                <tr class="table-secondary">
                    <td colspan="5" class="text-end fw-bold">Total</td>
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

        // Function to render the cart table and attach handlers
        function renderCart() {
            fetch(API_BASE + "/cart")
                .then(function(res) { return res.json(); })
                .then(function(cart) {
                    var tbody = document.getElementById("item-table-body");
                    var total = 0;

                    if (cart.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="6" class="text-center">Your cart is empty.</td></tr>';
                        document.getElementById("total").textContent = "0.00";
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
                                "<td>" +
                                    "<input type='number' value='" + item.quantity + "' min='1' />" +
                                "</td>" +
                                "<td>" +
                                    "<button class='update-btn' data-id='" + item.itemId + "'>Update</button>" +
                                    "<button class='remove-btn' data-id='" + item.itemId + "'>Remove</button>" +
                                "</td>" +
                                "<td>" + subtotal.toFixed(2) + "</td>" +
                            "</tr>";
                    });

                    tbody.innerHTML = rows;
                    document.getElementById("total").textContent = total.toFixed(2);

                    // Add event listeners for update and remove after rendering
                    document.querySelectorAll('.update-btn').forEach(function(btn) {
                        btn.addEventListener('click', function() {
                            var itemId = btn.getAttribute('data-id');
                            var quantity = btn.closest('tr').querySelector('input[type="number"]').value;
                            fetch(API_BASE + '/cart/' + itemId, {
                                method: 'PUT',
                                headers: {'Content-Type': 'application/json'},
                                body: JSON.stringify({quantity: quantity})
                            }).then(function() {
                                renderCart();
                            });
                        });
                    });

                    document.querySelectorAll('.remove-btn').forEach(function(btn) {
                        btn.addEventListener('click', function() {
                            var itemId = btn.getAttribute('data-id');
                            fetch(API_BASE + '/cart/' + itemId, { method: 'DELETE' })
                                .then(function() {
                                    renderCart();
                                });
                        });
                    });
                })
                .catch(function(err) {
                    console.error("Error loading cart:", err);
                });
        }

        // Initial load
        renderCart();

        // Clear cart
        document.getElementById("clearCart").addEventListener("click", function() {
            fetch(API_BASE + "/cart/clear", { method: "DELETE" })
                .then(function() {
                    renderCart();
                })
                .catch(function(err) { console.error("Error clearing cart:", err); });
        });
    </script>
</body>
</html>