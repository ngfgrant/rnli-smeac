<html !DOCTYPE>

<head>
<meta http-equiv="refresh" content="10">
<link rel="stylesheet" href="css/bootstrap.css" />
<script src="https://code.jquery.com/jquery-3.1.0.min.js"   integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s="   crossorigin="anonymous"></script>

<script type="text/javascript">
	function startTime() {
    	var today = new Date();
    	var h = today.getUTCHours();
    	var m = today.getMinutes();
    	var s = today.getSeconds();
    	m = checkTime(m);
    	s = checkTime(s);
    	document.getElementById('time').innerHTML =
   		h + ":" + m + ":" + s;
    	var t = setTimeout(startTime, 500);
	}
	function checkTime(i) {
    	if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
    	return i;
	}
</script>

<script type="text/javascript">
	function startLocalTime() {
    	var todayl = new Date();
    	var hl = todayl.getHours();
    	var ml = todayl.getMinutes();
    	var sl = todayl.getSeconds();
    	ml = checkLocalTime(ml);
    	sl = checkLocalTime(sl);
    	document.getElementById('localTime').innerHTML =
   		hl + ":" + ml + ":" + sl;
    	var tl = setTimeout(startLocalTime, 500);
	}
	
	function checkLocalTime(i) {
    	if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
    	return i;
	}
</script>	
	

</head>

<body onload="startTime(); startLocalTime()">

<div class="container-fluid">

  <div class="row">
		<div class="col-md-3">
			<h1 style="color: red;"><u>Situation</u></h1>
			<h3>What is happing / What has happened?</h3>
			<div class="col-md-6">
				<ul class="lead">
					<li>Type of Distress?</li>
					<li>Location?</li>
					<li>Number of Persons?</li>
				
				</ul>
			</div>
			
			<div class="col-md-6">
				<ul class="lead">
					<li>How Long Ago?</li>
					<li>Other Information?</li>
				</ul>
			</div>
			
				
			<div class="clearfix"></div>
			<h1 style="color: red;"><u>Mission</u></h1>
			<h3>What are we going to do?</h3>
			
			<div class="col-md-6">
				<ul class="lead">
					<li>Search</li>
					<li>Tow</li>
					<li>Casualty Care</li>
				</ul>
			</div>
						
			<div class="col-md-6">
				<ul class="lead">
					<li>Transfer</li>
					<li>Other</li>
				</ul>
			</div>
				
			<div class="clearfix"></div>
			
			
			<h1 style="color: red;"><u>Execution</u></h1>
			<h3>What needs to be done?</h3>
			<div class="col-md-6">
				<ul class="lead">
					<li>Boat Kit Checklist</li>
					<li>Navigation Checklist</li>
				</ul>
			</div>
			
			<div class="col-md-6">
				<ul class="lead">
					<li>Communication Checklist</li>
					<li>Launch Vehicle Checklist</li>
				</ul>
			</div>
			
			<div class="clearfix"></div>

		</div>
		
		<div class="col-md-4">
			<h1 style="color: red;"><u>Administration</u></h1>
			<table class="table" id="adminTable" > 
				<thead> 
					<tr> 
						<th>Type</th> 
						<th>Description</th> 
						<th>Reporter</th> 
						<th>Mech Aware</th> 
						<th>Status</th> 
						<th>Remove</th>
					</tr> 
				</thead> 
			
				<tbody> 
					<tr>
					
						
					</tr> 
				</tbody> 
			</table>
			
			
		<form name="admin" id="admin">
			
			<div class="form-group">
    			<label for="type">Type</label>
       			<select id="type" name="type"> 
					<option>Defect</option>
					<option>Information</option>
					<option>Danger</option>
				</select>
			</div>
			
			<div class="form-group">
    			<label for="description">Description</label>
				<textarea id="description" name="description" rows="3" cols="100" type="text" class="form-control" placeholder="Description"></textarea>
	    	</div>
	    	
	    	<div class="form-group">
    			<label for="reporter">Reporter</label>
	    		<input id="reporter" name="reporter" type="text" class="form-control" placeholder="Name"> 				
			</div>
			
			<div class="form-group">
    			<label for="mechanicAware">Mechanic Aware</label>					
       			<select id="mechanicAware" name="mechanicAware"> 
					<option>No</option>
					<option>Yes</option>
					<option>Not Applicable</option>
				</select>
			</div>	
				
			<div class="form-group">
    			<label for="status">Status</label>							
				<select id="status" name="status"> 
					<option>Not Started</option>
					<option>In Progress</option>
				</select>
       		</div>
        
        <button type="button" onClick="updateForm();" class="btn btn-success"><i class="glyphicon glyphicon-plus"></i> Add New</button>
        <input type="reset" name="reset" id="resetbtn" class="btn btn-danger" value="Reset" />
    </form>
				
											
			<h1 style="color: red;"><u>Command / Communication / Confirm</u></h1>
				<ul class="lead">
					<li>Final Confirm</li>
					<li>Questions?</li>
				</ul>


		</div>
		
		<div class="col-md-5">
			<div>
			
			<span><h1>UTC Time: <span id="time" style="color: red;"></span></h1><span><h1>Local Time: <span id="localTime" style="color: red;"></span></h1></span></span>
			
			
			<h1><u>Weather &amp; Tides</u></h1>
			<iframe id="tides" name="tides" src="http://www.bbc.co.uk/weather/coast_and_sea/tide_tables/7/223#tide-details" scrolling="no" frameborder="0" width="100%" height="360"></iframe>
			<!--			
			<iframe name="pressureChart" id="pressureChart" src="http://www.metoffice.gov.uk/public/weather/surface-pressure/#wxMain" scrolling="no" frameborder="0" width="100%" height="810"></iframe>
			-->			
		<!--
			<iframe src="http://www.metoffice.gov.uk/public/weather/marine-inshore-waters/#iw2" scrolling="no" frameborder="0" width="370" height="360"></iframe>
		-->
		<!--
			<iframe src="http://www.metoffice.gov.uk/public/weather/marine-inshore-waters/#inshoreWatersGeneralSection" scrolling="no" frameborder="0" width="380" height="150"></iframe>
		-->		
		
		<div id="forecast">
  			<iframe id="forcast" name="forecast" src="http://www.metoffice.gov.uk/public/weather/forecast/gcynfjhev#fcContent" scrolling="no" frameborder="0" width="90%" height="750"></iframe>
  		</div>
		
		
			</div>
		</div>
  </div>
  
  
  <div class="row">
  	<div class="col-md-12">

  		<div id="ais">
			<h1><u>AIS</u></h1>
				<script type="text/javascript"> 
					width='100%'; // the width of the embedded map in pixels or percentage 
					height='500';	// the height of the embedded map in pixels or percentage 
					border='0';	// the width of the border around the map (zero means no border) 
					shownames='true';	// to display ship names on the map (true or false) 
					latitude='56.0632';	// the latitude of the center of the map, in decimal degrees 
					longitude='-002.7184';	// the longitude of the center of the map, in decimal degrees 
					zoom='11';	// the zoom level of the map (values between 2 and 17) 
					maptype='0';	// use 0 for Normal map, 1 for Satellite, 2 for Hybrid, 3 for Terrain 
					trackvessel='0';	// MMSI of a vessel (note: vessel will be displayed only if within range of the system) - overrides "zoom" option 
				</script> 

				<script type="text/javascript" src="http://www.marinetraffic.com/js/embed.js"></script>
			</div>	
  	</div>
  </div>
</div>


<script type="text/javascript">
		function deleteRow(o) {
    		var p = o.parentNode.parentNode;
         	p.parentNode.removeChild(p);
    	}

        function updateForm() {
        
            var type = document.getElementById("type").value;
            var description = document.getElementById("description").value;
            var reporter = document.getElementById("reporter").value;   
            var mechanicAware = document.getElementById("mechanicAware").value;
            var status = document.getElementById("status").value; 
            var table=document.getElementById("adminTable");
            
            var row=table.insertRow(-1);
            var cell1=row.insertCell(0);
            var cell2=row.insertCell(1);
            var cell3=row.insertCell(2);
            var cell4=row.insertCell(3);
            var cell5=row.insertCell(4);
            var cell6=row.insertCell(5);
                        
            cell1.innerHTML=type;
            cell2.innerHTML=description;        
            cell3.innerHTML=reporter;  
            cell4.innerHTML=mechanicAware;
            cell5.innerHTML=status;    
            cell6.innerHTML="<button  id=\"remove\" name=\"remove\" class=\"btn btn-danger\" onclick=\"deleteRow(this)\"><i class=\"glyphicon glyphicon-remove\"></i></button>";    
        }

</script>

</body>

</html>