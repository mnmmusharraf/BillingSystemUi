<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Staff Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            body, html {
                height: 100%;
                background-color: #f8f9fa;
            }
            .login-container {
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .login-form {
                width: 100%;
                max-width: 400px;
                padding: 2rem;
                background-color: white;
                border-radius: 0.5rem;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <form class="login-form" method="POST" action="login">
                <h3 class="mb-4 text-center">Staff Login</h3>

                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="username" 
                        name="username" 
                        placeholder="Enter username" 
                        required 
                        autofocus 
                        />
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input 
                        type="password" 
                        class="form-control" 
                        id="password" 
                        name="password" 
                        placeholder="Enter password" 
                        required 
                        />
                </div>

                <%-- String error = (String) request.getAttribute("error"); %>
                <% if (error != null) {%>
                <div class="alert alert-danger mb-3" role="alert"><%= error%></div>
                <% } --%>
                
                <%
                    String error = request.getParameter("error");
                    if(error!=null){
                %>
                <div class="alert alert-danger mb-3" role="alert"><%= error%></div>
                <%
                    }
                %>
                
                    

                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>
        </div>
    </body>
</html>
