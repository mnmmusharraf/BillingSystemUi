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
    <meta charset="UTF-8">
    <title>Pahana Edu Billing System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #eaf1fb 0%, #f8faff 100%);
        }
        .card {
            border-radius: 1.2rem;
            box-shadow: 0 4px 20px rgba(52,120,246,0.08);
            border: none;
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
            overflow: hidden;
        }
        .card:hover {
            transform: translateY(-4px) scale(1.03);
            box-shadow: 0 8px 32px rgba(52,120,246,0.14);
            z-index: 2;
        }
        .card-icon {
            font-size: 2.3rem;
            margin-bottom: 0.7rem;
            display: inline-block;
        }
        .card.bg-primary-subtle { background: #eaf3fc; }
        .card.bg-success-subtle { background: #eafcf3; }
        .card.bg-info-subtle { background: #eaf7fc; }
        .card.bg-warning-subtle { background: #fffbe7; }
        .card.bg-secondary-subtle { background: #f2f2f6; }
        .card.bg-danger-subtle { background: #fdeaea; }
        .btn {
            border-radius: 0.8rem;
            font-weight: 500;
            font-size: 1.08rem;
        }
        @media (max-width: 991px) {
            .row.g-4 > div { margin-bottom: 1.2rem; }
        }
    </style>
</head>
<body>
<%@ include file="billing-navbar.jsp" %>
<div class="container py-4">
    <div class="row g-4 justify-content-center">

        <!-- Manage Customers -->
        <div class="col-md-4 col-sm-6">
            <div class="card bg-primary-subtle h-100 text-center p-3">
                <span class="card-icon text-primary"><i class="bi bi-people-fill"></i></span>
                <h5 class="card-title">Manage Customer Accounts</h5>
                <p class="card-text">Add, edit, or update customer details and accounts.</p>
                <a href="mng-customer.jsp" class="btn btn-primary w-100"><i class="bi bi-arrow-right-circle"></i> Go</a>
            </div>
        </div>

        <!-- Manage Items -->
        <div class="col-md-4 col-sm-6">
            <div class="card bg-success-subtle h-100 text-center p-3">
                <span class="card-icon text-success"><i class="bi bi-box-seam"></i></span>
                <h5 class="card-title">Manage Items</h5>
                <p class="card-text">Add, update or delete product/item information.</p>
                <a href="mng-item.jsp" class="btn btn-success w-100"><i class="bi bi-arrow-right-circle"></i> Go</a>
            </div>
        </div>

        <!-- View Accounts -->
        <div class="col-md-4 col-sm-6">
            <div class="card bg-info-subtle h-100 text-center p-3">
                <span class="card-icon text-info"><i class="bi bi-file-earmark-text"></i></span>
                <h5 class="card-title">Customer Account Details</h5>
                <p class="card-text">View billing and account summary per customer.</p>
                <a href="view-accounts.jsp" class="btn btn-info w-100"><i class="bi bi-arrow-right-circle"></i> Go</a>
            </div>
        </div>

        <!-- Calculate & Print Bill -->
        <div class="col-md-4 col-sm-6">
            <div class="card bg-warning-subtle h-100 text-center p-3">
                <span class="card-icon text-warning"><i class="bi bi-printer"></i></span>
                <h5 class="card-title">Calculate & Print Bill</h5>
                <p class="card-text">Generate customer bill based on usage or item selection.</p>
                <a href="generate-bill.jsp" class="btn btn-warning w-100 text-dark"><i class="bi bi-arrow-right-circle"></i> Go</a>
            </div>
        </div>

        <!-- Help -->
        <div class="col-md-4 col-sm-6">
            <div class="card bg-secondary-subtle h-100 text-center p-3">
                <span class="card-icon text-secondary"><i class="bi bi-question-circle"></i></span>
                <h5 class="card-title">Help / Guide</h5>
                <p class="card-text">Read usage instructions and FAQs for system use.</p>
                <a href="help.jsp" class="btn btn-secondary w-100"><i class="bi bi-arrow-right-circle"></i> View</a>
            </div>
        </div>

        <!-- Logout (Exit System) -->
        <div class="col-md-4 col-sm-6">
            <div class="card bg-danger-subtle h-100 text-center p-3">
                <span class="card-icon text-danger"><i class="bi bi-box-arrow-right"></i></span>
                <h5 class="card-title">Exit / Logout</h5>
                <p class="card-text">Log out of the system securely, safely, and efficiently.</p>
                <a href="logout" class="btn btn-danger w-100"><i class="bi bi-box-arrow-right"></i> Logout</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>