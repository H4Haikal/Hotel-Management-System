<%@page contentType="text/html" pageEncoding="UTF-8" language="Java"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Housekeeping Dashboard</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom Styles -->
    <link href="style.css" rel="stylesheet">

    <style>
        .main-content {
            margin-left: 250px; /* Assuming sidebar is fixed with 250px width */
            padding: 30px;
            background: #f8f9fa;
            min-height: 100vh;
        }

        .card-link {
            text-decoration: none;
            color: inherit;
        }

        .card-link:hover {
            background-color: #e9ecef;
        }
    </style>
</head>
<body>

    <%@ include file="include/sidebar.jsp" %>

    <div class="main-content">
        <div class="container">
            <h1 class="mb-4"><i class="bi bi-broom"></i> Housekeeping Dashboard</h1>

            <div class="row g-4">
                <div class="col-md-4">
                    <a href="AssignedTask.jsp" class="card card-link shadow-sm p-3 text-center">
                        <i class="bi bi-person-plus fs-1 text-primary"></i>
                        <h5 class="mt-3">Assign Task to Staff</h5>
                    </a>
                </div>
                <div class="col-md-4">

                    <a href="UpdateTask.jsp" class="card card-link shadow-sm p-3 text-center">
                        <i class="bi bi-pencil-square fs-1 text-warning"></i>
                        <h5 class="mt-3">Update Task Status</h5>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="HousekeepingAssignment.jsp" class="card card-link shadow-sm p-3 text-center">
                        <i class="bi bi-list-check fs-1 text-success"></i>
                        <h5 class="mt-3">View Assignments</h5>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
