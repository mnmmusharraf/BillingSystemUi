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
    <title>View Accounts</title>
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
        .accounts-header {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.10);
            padding: 1.5rem 1rem 1rem 1rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        .summary-cards {
            margin-bottom: 2rem;
        }
        .summary-card {
            background: var(--main-blue);
            color: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.13);
            padding: 1rem;
        }
        .summary-card .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.3rem;
        }
        .summary-card .card-value {
            font-size: 1.5rem;
            font-weight: 700;
        }
        .table-responsive {
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
        .btn-info, .btn-danger {
            border-radius: 1rem;
            font-weight: 500;
        }
        .btn-info {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border: none;
        }
        .btn-info:hover, .btn-info:focus {
            background: linear-gradient(90deg, var(--main-blue-dark) 80%, var(--main-blue) 100%);
            color: #fff;
        }
        .btn-danger {
            background: var(--danger-soft);
            color: var(--danger);
            border: none;
        }
        .btn-danger:hover, .btn-danger:focus {
            background: var(--danger);
            color: #fff;
        }
        .search-bar {
            border-radius: 1rem;
            background-color: #f7fafd;
            border: 1px solid #e3e6ea;
            font-size: 1.08rem;
            max-width: 350px;
            margin-right: 1rem;
        }
        .spinner-border {
            display: none;
        }
        @media (max-width: 600px) {
            .accounts-header { padding: 1rem 0.4rem 0.8rem 0.4rem; font-size: 1.2rem; }
            .summary-card { padding: 0.7rem; border-radius: 0.7rem; }
            .table-responsive { padding: 1rem 0.3rem; border-radius: 0.7rem; }
            .search-bar { max-width: 100%; margin-bottom: 1rem; }
        }
    </style>
</head>
<body>
    <%@ include file="billing-navbar.jsp" %>
    <div class="container py-4">
        <div class="accounts-header text-center mb-4">
            <h2><i class="bi bi-journal-text me-2"></i> View Accounts / Bills</h2>
        </div>
        <div class="row summary-cards justify-content-center">
            <div class="col-md-4 mb-2">
                <div class="summary-card text-center">
                    <div class="card-title"><i class="bi bi-receipt"></i> Total Bills</div>
                    <div class="card-value" id="totalBills">...</div>
                </div>
            </div>
            <div class="col-md-4 mb-2">
                <div class="summary-card text-center">
                    <div class="card-title"><i class="bi bi-cash-coin"></i> Total Amount</div>
                    <div class="card-value" id="totalAmount">...</div>
                </div>
            </div>
        </div>
        <div class="d-flex flex-column flex-md-row align-items-center justify-content-between mb-3 gap-2">
            <input type="text" class="form-control search-bar" id="searchBill"
                   placeholder="Search bills by account number, staff user, or date...">
            <div class="spinner-border text-primary" id="loadingSpinner" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
        <div class="table-responsive shadow-sm rounded">
            <table class="table table-bordered table-hover table-striped mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Account Number</th>
                        <th>Staff User</th>
                        <th>Date</th>
                        <th>Total (LKR)</th>
                        <th>Cash Given (LKR)</th>
                        <th>Change Due (LKR)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="bill-table-body">
                    <tr>
                        <td colspan="8" class="text-center text-muted">Loading...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bill Details Modal -->
    <div class="modal fade" id="billModal" tabindex="-1" aria-labelledby="billModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(90deg, #3478f6 70%, #1e50a2 100%); color: #fff; border-radius: 1rem 1rem 0 0;">
                    <h5 class="modal-title" id="billModalLabel">Bill Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="billModalBody">
                    <!-- Details will be injected here -->
                </div>
            </div>
        </div>
    </div>

    <script>
        const API_BASE = "http://localhost:8080/BillingSystemBackend/api";
        const spinner = document.getElementById("loadingSpinner");
        let billsGlobal = []; // for searching

        document.addEventListener("DOMContentLoaded", () => {
            fetchBills();
            document.getElementById("searchBill").addEventListener("input", function () {
                const query = this.value.toLowerCase();
                const filtered = billsGlobal.filter(bill =>
                    (bill.accountNumber || '').toLowerCase().includes(query) ||
                    (bill.staffUser || '').toLowerCase().includes(query) ||
                    (bill.billDate || '').toLowerCase().includes(query)
                );
                renderTable(filtered);
                updateSummary(filtered);
            });
        });

        async function fetchBills() {
            spinner.style.display = "inline-block";
            const tableBody = document.getElementById("bill-table-body");
            tableBody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">Loading...</td></tr>';

            try {
                const response = await fetch(API_BASE + "/billing");
                if (!response.ok)
                    throw new Error("HTTP error " + response.status);
                const bills = await response.json();

                billsGlobal = bills;
                renderTable(bills);
                updateSummary(bills);
            } catch (err) {
                tableBody.innerHTML = '<tr><td colspan="8" class="text-center text-danger">Could not load bills.</td></tr>';
                console.error(err);
            } finally {
                spinner.style.display = "none";
            }
        }

        function renderTable(bills) {
            const tableBody = document.getElementById("bill-table-body");
            tableBody.innerHTML = "";

            if (!bills || bills.length === 0) {
                tableBody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">No bills found.</td></tr>';
                return;
            }

            bills.forEach(bill => {
                const row = document.createElement("tr");

                row.innerHTML =
                        '<td>' + bill.id + '</td>' +
                        '<td>' + (bill.accountNumber || "") + '</td>' +
                        '<td>' + (bill.staffUser || "") + '</td>' +
                        '<td>' + (bill.billDate ? bill.billDate.substring(0, 19).replace("T", " ") : "") + '</td>' +
                        '<td>' + (bill.totalAmount != null ? bill.totalAmount.toFixed(2) + " LKR" : "") + '</td>' +
                        '<td>' + (bill.cashGiven != null ? bill.cashGiven.toFixed(2) + " LKR" : "") + '</td>' +
                        '<td>' + (bill.changeDue != null ? bill.changeDue.toFixed(2) + " LKR" : "") + '</td>' +
                        '<td>' +
                        '<button class="btn btn-info btn-sm me-2" onclick="viewBill(' + bill.id + ')"><i class="bi bi-eye"></i> View</button>' +
                        '<button class="btn btn-danger btn-sm" onclick="deleteBill(' + bill.id + ')"><i class="bi bi-trash-fill"></i> Delete</button>' +
                        '</td>';
                tableBody.appendChild(row);
            });
        }

        function updateSummary(bills) {
            document.getElementById("totalBills").textContent = bills.length;
            const totalAmt = bills.reduce((sum, bill) => sum + (bill.totalAmount || 0), 0);
            document.getElementById("totalAmount").textContent = totalAmt.toFixed(2) + " LKR";
        }

        async function viewBill(id) {
            const modal = new bootstrap.Modal(document.getElementById('billModal'));
            const modalBody = document.getElementById('billModalBody');
            modalBody.innerHTML = "<div>Loading...</div>";

            try {
                const response = await fetch(API_BASE + "/billing/" + id);
                if (!response.ok)
                    throw new Error("HTTP error " + response.status);
                const bill = await response.json();

                let itemsHtml = "";
                if (bill.items && bill.items.length > 0) {
                    itemsHtml =
                            '<table class="table table-bordered table-sm mt-3">' +
                            '<thead>' +
                            '<tr>' +
                            '<th>Item Id</th>' +
                            '<th>Name</th>' +
                            '<th>Unit Price (LKR)</th>' +
                            '<th>Quantity</th>' +
                            '<th>Subtotal (LKR)</th>' +
                            '</tr>' +
                            '</thead>' +
                            '<tbody>' +
                            bill.items.map(function (item) {
                                return '<tr>' +
                                        '<td>' + item.itemId + '</td>' +
                                        '<td>' + item.itemName + '</td>' +
                                        '<td>' + item.unitPrice.toFixed(2) + ' LKR</td>' +
                                        '<td>' + item.quantity + '</td>' +
                                        '<td>' + item.subtotal.toFixed(2) + ' LKR</td>' +
                                        '</tr>';
                            }).join("") +
                            '</tbody>' +
                            '</table>';
                } else {
                    itemsHtml = '<div class="text-muted">No items for this bill.</div>';
                }

                modalBody.innerHTML =
                        '<div><strong>ID:</strong> ' + bill.id + '</div>' +
                        '<div><strong>Account Number:</strong> ' + (bill.accountNumber || "") + '</div>' +
                        '<div><strong>Staff User:</strong> ' + (bill.staffUser || "") + '</div>' +
                        '<div><strong>Date:</strong> ' + (bill.billDate ? bill.billDate.substring(0, 19).replace("T", " ") : "") + '</div>' +
                        '<div><strong>Total:</strong> ' + (bill.totalAmount != null ? bill.totalAmount.toFixed(2) + ' LKR' : "") + '</div>' +
                        '<div><strong>Cash Given:</strong> ' + (bill.cashGiven != null ? bill.cashGiven.toFixed(2) + ' LKR' : "") + '</div>' +
                        '<div><strong>Change Due:</strong> ' + (bill.changeDue != null ? bill.changeDue.toFixed(2) + ' LKR' : "") + '</div>' +
                        '<hr>' +
                        '<h5>Items</h5>' +
                        itemsHtml;
                modal.show();
            } catch (err) {
                modalBody.innerHTML = '<div class="text-danger">Could not load bill details.</div>';
            }
        }

        async function deleteBill(id) {
            if (!confirm("Are you sure you want to delete this bill?"))
                return;

            try {
                const response = await fetch(API_BASE + "/billing/" + id, {method: "DELETE"});
                const result = await response.json();

                if (response.ok) {
                    alert(result.message || "Bill deleted.");
                    fetchBills();
                } else {
                    alert(result.message || "Failed to delete bill.");
                }
            } catch (err) {
                alert("Could not delete bill.");
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>