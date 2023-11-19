<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="oracle.jdbc.OraclePreparedStatement"%>
<%@page import="oracle.jdbc.OracleResultSetMetaData"%>
<%@page import="oracle.jdbc.OracleResultSet"%>
<%@page import="oracle.jdbc.OracleConnection"%>
<%@page import="helperclasses.SQLConnection"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,300;9..40,400&family=Lumanosimo&family=Poppins&display=swap" rel="stylesheet">
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Personal Info</title>
    <style>
        * {
            font-family: 'DM Sans';
        }

        table, tr, td {
            padding: 10px;
            border: 5px solid black;
            border-collapse: collapse;
            color: white;
            font-size: 25px;
            margin: 0 auto;
        }

        th {
            padding: 10px;
            border: 5px solid black;
            margin-bottom: 30px;
            margin-top: 20px;
            border-collapse: collapse;
            color: white;
            font-size: 4rem;
        }

        button {
            padding: 10px 35px;
            border-radius: 40px;
            background-color: #ee6010;
            color: white;
            margin-right: 10px;
            border-color: transparent;
            font-size: 15px;
            font-weight: 650;
        }

        body {
            background-color: color;
        }

        p {
            margin-bottom: 6rem;
        }

        .profile-image-container {
            border-radius: 50%;
            overflow: hidden;
            width: 150px;
            height: 150px;
            margin: 0 auto;
            display: block;
            margin-bottom: 20px;
            position: relative;
        }

        .profile-image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .edit-icon {
            position: absolute;
            bottom: 5px;
            right: 5px;
            cursor: pointer;
            color: white;
        }

        input[type="file"] {
            display: none;
        }
    </style>
</head>

<%
    // STEP 3: DECLARING OBJECTS AND VARIABLES
    OracleConnection oconn;
    OraclePreparedStatement ops;
    OracleResultSet ors;
    OracleResultSetMetaData orsmd;
    int counter;
%>
<%
    // STEP 4: REGISTRATION OF ORACLE DRIVER
    SQLConnection sqlcon = new SQLConnection();

    // STEP 5: INSTANTIATING THE CONNECTION
    oconn = sqlcon.connect();

    HttpSession userSession = request.getSession();
    String loggedInEmail = (String) userSession.getAttribute("username");

    // Execute SQL query
    String query = "SELECT * FROM user_details WHERE EMAIL = ?";
    ops = (OraclePreparedStatement) oconn.prepareStatement(query);
    ops.setString(1, loggedInEmail);
    ors = (OracleResultSet) ops.executeQuery();

    // STEP 8: GETTING THE COLUMNS INFORMATION(METADATA)
    orsmd = (OracleResultSetMetaData) ors.getMetaData();
%>
<body style="background-color: black">
    <p style="text-align: center; color: #ee6010; font-size: 40px; font-family: Comfortaa; font-weight: bold; margin-top: 5rem; font-weight: 600;">Personal Info</p>
    <div class="profile-image-container" onclick="document.getElementById('profileImageInput').click()">
        <img src="../images/anirban.jpg" alt="Profile Image" id="profileImage">
        <div class="edit-icon" title="Change Profile Photo" onclick="triggerFileInput()">&#9998;</div>
    </div>
    <input type="file" id="profileImageInput" accept="image/*" onchange="displayImage(this)">
    <table>
        <tbody>
            <% 
                Map<String, String> column_head = new HashMap<>();
                column_head.put("F_NAME", "First Name");
                column_head.put("L_NAME", "Last Name");
                column_head.put("EMAIL", "Email");
                column_head.put("PH_NO", "Phone Number");
                column_head.put("ADDRESS", "Address");
                column_head.put("GENDER", "Gender");

                while (ors.next()) { %>
                    <tr>
                        <%
                        for (counter = 1; counter <= orsmd.getColumnCount(); counter++) {
                            String columnName = column_head.get(orsmd.getColumnName(counter));
                            String columnValue = ors.getString(counter);
                        %>
                            <tr>
                                <td><strong><%= columnName %> :</strong></td>
                                <td><%= columnValue %></td>
                            </tr>
                        <%
                        }
                        %>
                        <tr>
                            <td colspan="2">
                                <button onclick="editRecord('<%=ors.getString(1)%>')">Edit</button>
                            </td>
                        </tr>
                    </tr>
                <% } %>
        </tbody>
    </table>
    <script>
        function displayImage(input) {
            const profileImageContainer = document.getElementById('profileImage');
            const file = input.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    profileImageContainer.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }

        function triggerFileInput() {
            document.getElementById('profileImageInput').click();
        }
    </script>
</body>
</html>
