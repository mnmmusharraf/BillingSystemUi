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
<html>
    <head>
        <meta charset="UTF-8">
        <title>View Accounts</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .spinner-border {
                display: none;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="text-center mb-4">
                <h2 class="fw-bold">View Accounts / Bills</h2>
            </div>
            <div class="mb-3 text-end">
                <div class="spinner-border text-primary" id="loadingSpinner" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
            <div class="table-responsive shadow-sm rounded">
                <table class="table table-bordered table-hover table-striped mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Account Number</th>
                            <th>Staff User</th>
                            <th>Date</th>
                            <th>Total</th>
                            <th>Cash Given</th>
                            <th>Change Due</th>
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
                    <div class="modal-header">
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
            document.addEventListener("DOMContentLoaded", fetchBills);

            async function fetchBills() {
                spinner.style.display = "inline-block";
                const tableBody = document.getElementById("bill-table-body");
                tableBody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">Loading...</td></tr>';

                try {
                    const response = await fetch(API_BASE + "/billing");
                    if (!response.ok)
                        throw new Error("HTTP error " + response.status);
                    const bills = await response.json();

                    renderTable(bills);
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
                            '<td>' + (bill.totalAmount != null ? bill.totalAmount.toFixed(2) : "") + '</td>' +
                            '<td>' + (bill.cashGiven != null ? bill.cashGiven.toFixed(2) : "") + '</td>' +
                            '<td>' + (bill.changeDue != null ? bill.changeDue.toFixed(2) : "") + '</td>' +
                            '<td>' +
                            '<button class="btn btn-info btn-sm me-2" onclick="viewBill(' + bill.id + ')">View</button>' +
                            '<button class="btn btn-danger btn-sm" onclick="deleteBill(' + bill.id + ')">Delete</button>' +
                            '</td>';
                    tableBody.appendChild(row);
                });
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
                                '<th>Unit Price</th>' +
                                '<th>Quantity</th>' +
                                '<th>Subtotal</th>' +
                                '</tr>' +
                                '</thead>' +
                                '<tbody>' +
                                bill.items.map(function (item) {
                                    return '<tr>' +
                                            '<td>' + item.itemId + '</td>' +
                                            '<td>' + item.itemName + '</td>' +
                                            '<td>' + item.unitPrice.toFixed(2) + '</td>' +
                                            '<td>' + item.quantity + '</td>' +
                                            '<td>' + item.subtotal.toFixed(2) + '</td>' +
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
                            '<div><strong>Total:</strong> ' + (bill.totalAmount != null ? bill.totalAmount.toFixed(2) : "") + '</div>' +
                            '<div><strong>Cash Given:</strong> ' + (bill.cashGiven != null ? bill.cashGiven.toFixed(2) : "") + '</div>' +
                            '<div><strong>Change Due:</strong> ' + (bill.changeDue != null ? bill.changeDue.toFixed(2) : "") + '</div>' +
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