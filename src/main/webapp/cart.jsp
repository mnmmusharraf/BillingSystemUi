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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cart / Bill</title>
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
            padding: 1.3rem 1rem 1rem 1rem;
            margin-bottom: 2rem;
            text-align: center;
            font-weight: 700;
            font-size: 2rem;
            letter-spacing: 1px;
        }
        .cart-table-container {
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
        }
        .btn-cancel:hover, .btn-cancel:focus {
            background: var(--danger);
            color: #fff;
        }
        .btn-info, .btn-secondary {
            border-radius: 1rem;
            font-weight: 500;
        }
        .btn-danger {
            border-radius: 1rem;
            font-weight: 500;
        }
        @media (max-width: 600px) {
            .bill-header { font-size: 1.3rem; padding: 1rem 0.4rem 0.8rem 0.4rem; }
            .cart-table-container { padding: 1rem 0.3rem; border-radius: 0.7rem; }
            .table th, .table td { font-size: 0.98rem; }
        }
        #postPrintActions {
            display: none;
        }
        .update-btn, .remove-btn {
            margin-right: 0.5rem;
            border-radius: 0.8rem;
            font-weight: 500;
            border: none;
            padding: 0.4rem 0.85rem;
            transition: background 0.2s, color 0.2s;
        }
        .update-btn {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
        }
        .update-btn:hover, .update-btn:focus {
            background: linear-gradient(90deg, var(--main-blue-dark) 80%, var(--main-blue) 100%);
            color: #fff;
        }
        .remove-btn {
            background: var(--danger-soft);
            color: var(--danger);
        }
        .remove-btn:hover, .remove-btn:focus {
            background: var(--danger);
            color: #fff;
        }
        .form-control:focus {
            border-color: var(--main-blue);
            box-shadow: 0 0 0 0.1rem rgba(52,120,246,.10);
            background-color: #f4f8ff;
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4" id="mainContent">
        <div class="bill-header">
            <i class="bi bi-cart-check me-2"></i> Your Cart / Bill
        </div>
        <h5 class="text-center mb-4">
            Account Number: <%= accountNum != null ? accountNum : "Not set" %>
        </h5>
        <div class="cart-table-container mb-4">
            <table class="table table-bordered table-hover table-striped mb-0">
                <thead>
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
                    <tr>
                        <td colspan="5" class="text-end">Cash Given</td>
                        <td>
                            <input type="number" class="form-control" id="cashGiven" min="0" step="0.01" value="0.00" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" class="text-end">Change Due</td>
                        <td id="changeDue" class="fw-bold">0.00</td>
                    </tr>
                </tfoot>
            </table>
        </div>
        <div class="text-center mt-3" id="actionButtons">
            <button id="clearCart" class="btn btn-cancel">Clear Cart</button>
            <button id="calculateBtn" class="btn btn-blue ms-2">Calculate</button>
            <button id="printBillBtn" class="btn btn-blue ms-2">Print Bill</button>
        </div>
        <div class="text-center mt-3" id="postPrintActions">
            <button id="viewAccountsBtn" class="btn btn-info me-2">Go to View Accounts</button>
            <button id="generateBillBtn" class="btn btn-secondary">Generate Another Bill</button>
        </div>
    </div>

    <script>
        var API_BASE = "http://localhost:8080/BillingSystemBackend/api";
        var cartData = [];

        function renderCart() {
            fetch(API_BASE + "/cart")
                .then(function(res) { return res.json(); })
                .then(function(cart) {
                    cartData = cart; // Save for later use
                    var tbody = document.getElementById("item-table-body");
                    var total = 0;

                    if (cart.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="6" class="text-center">Your cart is empty.</td></tr>';
                        document.getElementById("total").textContent = "0.00";
                        document.getElementById("changeDue").textContent = "0.00";
                        document.getElementById("cashGiven").value = "0.00";
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

                    // Update change due when cart changes
                    updateChangeDue();

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

        function updateChangeDue() {
            var total = parseFloat(document.getElementById("total").textContent) || 0;
            var cashGiven = parseFloat(document.getElementById("cashGiven").value) || 0;
            var change = cashGiven - total;
            document.getElementById("changeDue").textContent = change >= 0 ? change.toFixed(2) : "0.00";
        }

        // Initial load
        renderCart();

        document.getElementById("cashGiven").addEventListener("input", updateChangeDue);

        document.getElementById("calculateBtn").addEventListener("click", function() {
            updateChangeDue();
        });

        // Print Bill button handler: validate, calculate, insert to DB, then clear cart & show navigation buttons
        document.getElementById("printBillBtn").addEventListener("click", function() {
            updateChangeDue();

            var total = parseFloat(document.getElementById("total").textContent) || 0;
            var cashGivenInput = document.getElementById("cashGiven");
            var cashGivenVal = cashGivenInput.value.trim();

            // ---- Validation ----
            if (cashGivenVal === "" || isNaN(cashGivenVal) || parseFloat(cashGivenVal) < total) {
                alert("Please enter a valid 'Cash Given' amount that is greater than or equal to the total.");
                cashGivenInput.focus();
                return;
            }
            var cashGiven = parseFloat(cashGivenVal);
            var changeDue = parseFloat(document.getElementById("changeDue").textContent) || 0;

            // Get staff user and account number from JSP variables
            var staffUser = "<%= username %>";
            var accountNumber = "<%= accountNum != null ? accountNum : "" %>";

            // Prepare bill date in ISO format
            var billDate = new Date().toISOString();

            // Prepare items for bill (convert cartData)
            var items = cartData.map(function(item) {
                return {
                    itemId: item.itemId,
                    itemName: item.name,
                    unitPrice: item.price,
                    quantity: item.quantity,
                    subtotal: item.price * item.quantity
                };
            });

            // Prepare bill object
            var bill = {
                accountNumber: accountNumber,
                staffUser: staffUser,
                billDate: billDate,
                totalAmount: total,
                cashGiven: cashGiven,
                changeDue: changeDue,
                items: items
            };

            // POST to /api/billing
            fetch(API_BASE + "/billing", {
                method: "POST",
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(bill)
            })
            .then(function(response) {
                if (!response.ok) throw new Error("Failed to insert bill");
                return response.json();
            })
            .then(function(data) {
                // After successful DB insert, print, then clear cart, then show navigation buttons
                //window.print();
                // Clear cart
                return fetch(API_BASE + "/cart/clear", { method: "DELETE" });
            })
            .then(function() {
                // Hide cart/bill section, show navigation buttons
                document.getElementById("mainContent").querySelector("#actionButtons").style.display = "none";
                document.getElementById("postPrintActions").style.display = "block";
                renderCart(); // This will update the table to empty
            })
            .catch(function(error) {
                alert("Could not save bill! " + error.message);
            });
        });

        // Post-print navigation buttons
        document.getElementById("viewAccountsBtn").addEventListener("click", function() {
            window.location.href = "view-accounts.jsp";
        });
        document.getElementById("generateBillBtn").addEventListener("click", function() {
            window.location.href = "generate-bill.jsp";
        });

        document.getElementById("clearCart").addEventListener("click", function() {
            fetch(API_BASE + "/cart/clear", { method: "DELETE" })
                .then(function() {
                    renderCart();
                })
                .catch(function(err) { console.error("Error clearing cart:", err); });
        });
        
        const cashGiven = document.getElementById('cashGiven');

        cashGiven.addEventListener('focus', function() {
          if (this.value === "0.00") {
            this.value = "";
          }
        });

        cashGiven.addEventListener('blur', function() {
          if (this.value === "") {
            this.value = "0.00";
          }
        });
    </script>
</body>
</html>