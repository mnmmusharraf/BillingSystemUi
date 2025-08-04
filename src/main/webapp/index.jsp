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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            transition: transform 0.2s ease-in-out;
        }
        .card:hover {
            transform: scale(1.02);
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="text-center mb-4">
        <h2>Welcome, <%= username %>!</h2>
        <p class="lead">Billing System Dashboard</p>
    </div>

    <div class="row g-4">
        <!-- Manage Customers -->
        <div class="col-md-4">
            <div class="card border-primary h-100">
                <div class="card-body">
                    <h5 class="card-title">Manage Customer Accounts</h5>
                    <p class="card-text">Add, edit, or update customer details and accounts.</p>
                    <a href="mng-customer.jsp" class="btn btn-primary w-100">Go</a>
                </div>
            </div>
        </div>

        <!-- Manage Items -->
        <div class="col-md-4">
            <div class="card border-success h-100">
                <div class="card-body">
                    <h5 class="card-title">Manage Items</h5>
                    <p class="card-text">Add, update or delete product/item information.</p>
                    <a href="manage-items.jsp" class="btn btn-success w-100">Go</a>
                </div>
            </div>
        </div>

        <!-- View Accounts -->
        <div class="col-md-4">
            <div class="card border-info h-100">
                <div class="card-body">
                    <h5 class="card-title">Customer Account Details</h5>
                    <p class="card-text">View billing and account summary per customer.</p>
                    <a href="view-accounts.jsp" class="btn btn-info w-100">Go</a>
                </div>
            </div>
        </div>

        <!-- Calculate & Print Bill -->
        <div class="col-md-4">
            <div class="card border-warning h-100">
                <div class="card-body">
                    <h5 class="card-title">Calculate & Print Bill</h5>
                    <p class="card-text">Generate customer bill based on usage or item selection.</p>
                    <a href="generate-bill.jsp" class="btn btn-warning w-100">Go</a>
                </div>
            </div>
        </div>

        <!-- Help -->
        <div class="col-md-4">
            <div class="card border-secondary h-100">
                <div class="card-body">
                    <h5 class="card-title">Help / Guide</h5>
                    <p class="card-text">Read usage instructions and FAQs for system use.</p>
                    <a href="help.jsp" class="btn btn-secondary w-100">View</a>
                </div>
            </div>
        </div>

        <!-- Logout (Exit System) -->
        <div class="col-md-4">
            <div class="card border-danger h-100">
                <div class="card-body">
                    <h5 class="card-title">Exit / Logout</h5>
                    <p class="card-text">Log out of the system securely, safely, and efficiently.</p>
                    <a href="logout" class="btn btn-danger w-100">Logout</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
