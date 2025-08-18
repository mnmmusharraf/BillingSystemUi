<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Pahana Edu Staff Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body, html {
            min-height: 100vh;
            background: linear-gradient(135deg, #eaf1fb 0%, #f8faff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            width: 100vw;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-form {
            width: 100%;
            max-width: 410px;
            padding: 2.2rem 2rem 2rem 2rem;
            background: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 4px 32px rgba(52,120,246,0.08);
            border: 1px solid #eaeaea;
        }
        .login-form h3 {
            color: #3478f6;
            font-weight: 700;
        }
        .login-icon {
            font-size: 2.5rem;
            color: #3478f6;
            margin-bottom: 1.2rem;
            display: block;
            text-align: center;
        }
        .form-label {
            color: #3478f6;
            font-weight: 500;
        }
        .form-control {
            border-radius: 1rem;
            background-color: #f7fafd;
            font-size: 1.1rem;
        }
        .form-control:focus {
            border-color: #3478f6;
            box-shadow: 0 0 0 0.15rem rgba(52,120,246,.10);
            background-color: #f4f8ff;
        }
        .btn-primary {
            background: linear-gradient(90deg, #3478f6 70%, #1e50a2 100%);
            border: none;
            border-radius: 1rem;
            font-weight: 600;
            font-size: 1.08rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
        }
        .btn-primary:hover, .btn-primary:focus {
            background: linear-gradient(90deg, #1e50a2 80%, #3478f6 100%);
        }
        .alert-danger {
            border-radius: 0.8rem;
        }
        @media (max-width: 600px) {
            .login-form {
                padding: 1.2rem 0.5rem 1rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <form class="login-form" method="POST" action="login">
            <span class="login-icon"><i class="bi bi-person-badge-fill"></i></span>
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

            <%
                String error = request.getParameter("error");
                if(error!=null){
            %>
            <div class="alert alert-danger mb-3" role="alert"><%= error%></div>
            <%
                }
            %>

            <button type="submit" class="btn btn-primary w-100 mt-2">Login</button>
        </form>
    </div>
</body>
</html>