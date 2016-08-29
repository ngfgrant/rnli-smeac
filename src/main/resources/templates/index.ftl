<#setting datetime_format="yyyy-MM-dd HH:mm:ss.ms">
<#setting locale="en_GB">
<html xmlns="http://www.w3.org/1999/html" !DOCTYPE>

<head>
    <meta http-equiv="refresh" content="3600">
    <link rel="stylesheet" href="css/bootstrap.css"/>
    <script src="https://code.jquery.com/jquery-3.1.0.min.js"
            integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=" crossorigin="anonymous"></script>

    <style>

        .red {
            color: red;
        }

        .blink_me {
            animation: blinker 2s linear infinite;
        }

        @keyframes blinker {
            50% {
                opacity: 0.0;
            }
        }

    </style>

    <script>
        $(document).ready(function () {
            setInterval(function () {
                $.get("refreshMessages", function (result) {
                    $('#pager').html(result);
                });
            }, 1000);
        });
    </script>

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
            if (i < 10) {
                i = "0" + i
            }
            ;  // add zero in front of numbers < 10
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
            if (i < 10) {
                i = "0" + i
            }
            ;  // add zero in front of numbers < 10
            return i;
        }
        function pageToTop() {
            window.scrollTo(0, 0);
        }

        $(document).ready(function () {
            $("#adminForm").hide();
        });
    </script>


</head>

<body onload="startTime(); startLocalTime(); pageToTop()">

<div class="container-fluid">

<div class="row">
    <div class="col-md-4">
        <div id="pager">
        <#if !pagerMessage?has_content>
            <h1 style="color: blue;">No Recent Launches</h1>
        </#if>
        </div>
        <a href="/clearPagerMessages">Clear Messages</a>
    </div>

    <div class="col-md-4">
        <h1>UTC Time: <span id="time" style="color: red;"></span></h1>
    </div>

    <div class="col-md-4">
        <h1>Local Time: <span id="localTime" style="color: red;"></span></h1>
    </div>
</div>

<div class="row">
<div class="col-md-2">
    <h1 style="color: blue;"><u>Situation</u></h1>

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
    <h1 style="color: blue;"><u>Mission</u></h1>

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


    <h1 style="color: blue;"><u>Execution</u></h1>

    <h3>What needs to be done?</h3>

    <div class="col-md-6">
        <ul class="lead">
            <li>Boat Kit Checklist</li>
            <li>Navigation Checklist</li>
            <li>Communication Checklist</li>
        </ul>
    </div>

    <div class="col-md-6">
        <ul class="lead">

            <li>Launch Vehicle Checklist</li>
        </ul>
    </div>

    <div class="clearfix"></div>

</div>

<div class="col-md-5">
    <h1 style="color: blue;"><u>Administration</u></h1>
<#if adminList?has_content>

    <table class="table" id="adminTable">
        <thead>
        <tr>
            <th>Date</th>
            <th>Type</th>
            <th>Description</th>
            <th>Reporter</th>
            <th>Mech Aware</th>
            <th>Status</th>
            <th>Edit</th>
        </tr>
        </thead>

        <tbody>
            <#list adminList as admin>
                <#assign typeLabel = "warning">
                <#if admin.type = "Defect">
                    <#assign typeLabel = "warning">
                <#elseif admin.type = "Information">
                    <#assign typeLabel = "info">
                <#elseif admin.type = "Danger">
                    <#assign typeLabel = "danger">
                <#else>
                    <#assign typeLabel = "default">
                </#if>

            <tr>
                <td>${admin.timestamp?datetime?string('dd MMM')}</td>
                <td><span class="label label-${typeLabel}">${admin.type}</span></td>
                <td>${admin.description}</td>
                <td>${admin.reporter}</td>

                <td>
                    <select id="mechanicAwareSelect+${admin.id}">
                        <option value="${admin.mechanicAware}">${admin.mechanicAware}</option>
                        <option value="Yes">Yes</option>
                        <option value="No">No</option>
                        <option value="N/A">N/A</option>
                    </select>
                </td>
                <td>
                    <select id="statusSelect+${admin.id}">
                        <option value="${admin.status}">${admin.status}</option>
                        <option value="I.P">I.P</option>
                        <option value="N.S">N.S</option>
                    </select>

                </td>
                <td>
                    <button id="update" name="update" class="btn btn-success"
                            onclick="updateRow('${admin.id}', document.getElementById('mechanicAwareSelect+${admin.id}').value , document.getElementById('statusSelect+${admin.id}').value)">
                        <i class="glyphicon glyphicon-check"></i></button>
                    <button id="remove" name="remove" class="btn btn-danger" style="margin-top: 5px;"
                            onclick="deleteRow('${admin.id}')"><i class="glyphicon glyphicon-remove"></i></button>
                </td>

            </tr>
            </#list>
        </tbody>
    </table>
<#else>
    <div class="well well-lg">
        <p class="lead">There are no outstanding administration notices.</p>
    </div>
</#if>


    <button class="btn btn-info" onclick="$('#adminForm').toggle();">Toggle Form</button>

    <form name="admin" id="adminForm" method="POST" action="/admin" style="margin-top: 20px;">

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
            <textarea id="description" name="description" rows="3" cols="100" type="text" class="form-control"
                      placeholder="Description"></textarea>
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
                <option>N/A</option>
            </select>
        </div>

        <div class="form-group">
            <label for="status">Status</label>
            <select id="status" name="status">
                <option>N.S</option>
                <option>I.P</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success"><i class="glyphicon glyphicon-plus"></i> Add New</button>
        <input type="reset" name="reset" id="resetbtn" class="btn btn-danger" value="Reset"/>
    </form>


    <h1 style="color: blue;"><u>Command / Communication / Confirm</u></h1>
    <ul class="lead">
        <li>Final Confirm</li>
        <li>Questions?</li>
    </ul>


</div>

<div class="col-md-5">
    <div>
        <h1><u>Weather (Local) &amp; Tides (UTC)</u></h1>
        <iframe id="tides" name="tides" src="http://www.bbc.co.uk/weather/coast_and_sea/tide_tables/7/223#tide-details"
                scrolling="no" frameborder="0" width="100%" height="360"></iframe>
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
            <iframe id="forcast" name="forecast"
                    src="http://www.metoffice.gov.uk/public/weather/forecast/gcynfjhev#fcContent" scrolling="no"
                    frameborder="0" width="90%" height="750"></iframe>
        </div>


    </div>
</div>
</div>


<div class="row">
    <div class="col-md-12">

        <div id="ais">
            <h1><u>AIS</u></h1>
            <script type="text/javascript">
                width = '100%'; // the width of the embedded map in pixels or percentage
                height = '800';	// the height of the embedded map in pixels or percentage
                border = '0';	// the width of the border around the map (zero means no border)
                shownames = 'true';	// to display ship names on the map (true or false)
                latitude = '56.0632';	// the latitude of the center of the map, in decimal degrees
                longitude = '-002.7184';	// the longitude of the center of the map, in decimal degrees
                zoom = '11';	// the zoom level of the map (values between 2 and 17)
                maptype = '0';	// use 0 for Normal map, 1 for Satellite, 2 for Hybrid, 3 for Terrain
                trackvessel = '0';	// MMSI of a vessel (note: vessel will be displayed only if within range of the system) - overrides "zoom" option
            </script>

            <script type="text/javascript" src="http://www.marinetraffic.com/js/embed.js"></script>
        </div>
    </div>
</div>
</div>


<script type="text/javascript">
    function deleteRow(id) {
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.open("DELETE", "/admin/" + id, false);
        xmlHttp.send();
        window.location = "/";
    }

    function updateRow(id, mechanicAware, status) {
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.open("PUT", "/admin/" + id + "?mechanicAware=" + mechanicAware + "&status=" + status, false);
        xmlHttp.send();
        window.location = "/";
    }
</script>

</body>

</html>