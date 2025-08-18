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
    <title>Help & User Guide | Admin & Billing System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #eaf1fb 0%, #f8faff 100%);
            min-height: 100vh;
        }
        .help-header {
            background: linear-gradient(90deg, #3478f6 70%, #1e50a2 100%);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.10);
            padding: 1.5rem 1rem 1rem 1rem;
            margin-bottom: 2.2rem;
            text-align: center;
        }
        .help-section {
            background: #fff;
            border-radius: 1.1rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.08);
            padding: 2rem 1.5rem;
            margin-bottom: 2rem;
        }
        .help-section h3 {
            color: #3478f6;
            margin-bottom: 1.5rem;
            font-weight: 700;
        }
        .help-section h4 {
            color: #1e50a2;
            margin-top: 2rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        .help-section ul, .help-section ol {
            margin-bottom: 1.2rem;
        }
        .code-block {
            background: #f4f8ff;
            border-radius: 0.7rem;
            padding: 1rem;
            font-family: "Fira Mono", "Consolas", "Courier New", monospace;
            font-size: 0.98rem;
        }
        .help-section .table {
            background: #f7fafd;
        }
        .help-contact {
            background: #eaf1fb;
            border-radius: 1rem;
            padding: 1rem;
        }
        @media (max-width: 700px) {
            .help-header { font-size: 1.2rem; padding: 1rem 0.4rem 0.7rem 0.4rem;}
            .help-section { padding: 1rem 0.7rem; }
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4">
        <div class="help-header mb-4">
            <h2><i class="bi bi-question-circle me-2"></i> Help & User Guide</h2>
            <p class="lead mb-0">Admin & Billing System</p>
        </div>
        <div class="help-section mb-4">
            <h3>Overview</h3>
            <p>
                Welcome to the Admin & Billing System! This robust platform allows staff to manage customers, items, and billing operations efficiently and accurately. Below you'll find detailed guides for all major workflows, including customer management, item management, billing, and account viewing. If you are new, please follow the sections step-by-step.
            </p>
        </div>

        <div class="help-section mb-4">
            <h3>Staff Login & Session Management</h3>
            <ul>
                <li>Access to the system is restricted to authorized staff members only.</li>
                <li>On visiting any page, you will be redirected to <code>staff-login.jsp</code> if not logged in.</li>
                <li>Your session will persist as long as you are active. Log out to end your session.</li>
            </ul>
        </div>

        <div class="help-section mb-4">
            <h3>Customer Management</h3>
            <h4>Find Customer</h4>
            <ul>
                <li>Navigate to <strong>Find Customer</strong> via the navigation bar.</li>
                <li>Use the search bar to find customers by account number, name, address, or telephone.</li>
                <li>Results are displayed in a blue-themed table. If no match is found, you will see a message.</li>
                <li>
                    <strong>Start Billing</strong> button:
                    <ul>
                        <li>Click to clear the cart and begin billing for the selected customer.</li>
                        <li>You will be redirected to the billing workflow with the customer's account number.</li>
                    </ul>
                </li>
            </ul>
        </div>

        <div class="help-section mb-4">
            <h3>Item Management</h3>
            <h4>Manage Items</h4>
            <ul>
                <li>Access <strong>Manage Items</strong> from the navigation bar.</li>
                <li>View all items with their ID, name, price, and stock quantity in a blue-themed table.</li>
                <li>Search items by name or ID using the search bar.</li>
                <li>
                    <strong>Actions</strong> available:
                    <ul>
                        <li><span class="badge bg-info text-dark">Edit</span> - Update item details.</li>
                        <li><span class="badge bg-danger">Delete</span> - Remove the item from inventory.</li>
                    </ul>
                </li>
                <li>
                    <strong>Add New Item</strong>:
                    <ul>
                        <li>Click <strong>Add New Item</strong> to open the item creation form.</li>
                        <li>Fill in the item name, price, and stock quantity.</li>
                        <li>System checks for item name uniqueness before saving.</li>
                    </ul>
                </li>
            </ul>
        </div>

        <div class="help-section mb-4">
            <h3>Billing Workflow</h3>
            <h4>Generate Bill / Add to Cart</h4>
            <ol>
                <li>After selecting a customer, you will be redirected to the <strong>Generate Bill</strong> page.</li>
                <li>
                    <strong>Searching & Adding Items:</strong>
                    <ul>
                        <li>Search items by name.</li>
                        <li>Enter quantity and click <strong>Add to Cart</strong> (blue button).</li>
                        <li>Cart count updates automatically.</li>
                    </ul>
                </li>
                <li>
                    <strong>Viewing Cart:</strong>
                    <ul>
                        <li>Click the <strong>Cart</strong> button to view current cart items.</li>
                    </ul>
                </li>
            </ol>
            <h4>Cart & Bill Page</h4>
            <ul>
                <li>Displays all items in the cart with details and subtotals (amounts labeled in <strong>LKR</strong>).</li>
                <li>Update or remove items as needed.</li>
                <li>Shows total, cash given, and change due (calculated).</li>
                <li>
                    <strong>Actions:</strong>
                    <ul>
                        <li><strong>Clear Cart</strong> – Empties current cart.</li>
                        <li><strong>Calculate</strong> – Calculates change due.</li>
                        <li><strong>Print Bill</strong> – Saves bill to database, clears cart, and shows next steps.</li>
                    </ul>
                </li>
                <li>After printing, you can view accounts or generate another bill.</li>
            </ul>
        </div>

        <div class="help-section mb-4">
            <h3>View Accounts / Bills</h3>
            <ul>
                <li>Access <strong>View Accounts</strong> to see all bills generated in the system.</li>
                <li>Summary cards show total bills and total amount collected (in <strong>LKR</strong>).</li>
                <li>Search bills by account number, staff user, or date.</li>
                <li>
                    <strong>Actions:</strong>
                    <ul>
                        <li><strong>View</strong> – See detailed bill and items in a modal popup.</li>
                        <li><strong>Delete</strong> – Remove a bill from the system (confirmation required).</li>
                    </ul>
                </li>
                <li>All amounts are shown in <strong>LKR</strong> (Sri Lankan Rupee).</li>
            </ul>
        </div>

        <div class="help-section mb-4">
            <h3>UI Features & Tips</h3>
            <ul>
                <li>Consistent blue-theme throughout for clarity and branding.</li>
                <li>Tables are responsive and easy to navigate on all devices.</li>
                <li>Buttons are color-coded for function (blue for main, red for danger).</li>
                <li>Modals and forms are designed for easy input and review.</li>
                <li>Session security: Always log out after use.</li>
            </ul>
        </div>

        <div class="help-section mb-4 help-contact">
            <h3>Contact & Support</h3>
            <ul>
                <li>If you face issues or have suggestions, contact your system administrator.</li>
                <li>For technical support, email <a href="mailto:support@example.com">support@example.com</a>.</li>
                <li>Refer to this help page anytime for workflow guidance.</li>
            </ul>
        </div>

        <div class="text-center text-muted py-3">
            &copy; 2025 Admin & Billing System. Designed by musharraf.
        </div>
    </div>
</body>
</html>