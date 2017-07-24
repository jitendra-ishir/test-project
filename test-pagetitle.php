<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="Generator" content="EditPlus®">
        <meta name="Author" content="">
        <meta name="Keywords" content="">
        <meta name="Description" content="">
        <title>Document</title>
    </head>
    <body>
        <h1>TEST</h1>
        <script type="text/javascript">
            var xmlhttp;
            xmlhttp = new XMLHttpRequest();
            xmlhttp.open('GET', "test.txt", false);
            xmlhttp.send();
            document.write(xmlhttp.responseText.split('\r\n').map(function (i) {
                return i.replace(/(.+),(.+),(.+)/g, 'Name: $1<br>Color: $2<br>Avatar: $3<br>')
            }).join('<br/>'));
        </script>
    </body>
</html>
