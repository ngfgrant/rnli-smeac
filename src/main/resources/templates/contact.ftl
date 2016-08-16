<html>
<head>

</head>
<body>
<form name="contact" id="contact" method="POST" action="/contact">


    <div class="form-group">
        <label for="reporter">Name</label>
        <input id="name" name="name" type="text" class="form-control" placeholder="Name">
    </div>

    <div class="form-group">
        <label for="number">Number</label>
        <input id="number" name="number" type="text" class="form-control" placeholder="Number - 447........">
    </div>

    <button type="submit" class="btn btn-success"><i class="glyphicon glyphicon-plus"></i> Add New</button>
    <input type="reset" name="reset" id="resetbtn" class="btn btn-danger" value="Reset"/>
</form>
</body>
</html>