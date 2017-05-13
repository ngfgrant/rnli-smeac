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

<!-- Time and Messages -->
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

<!-- SMEAC -->
<div class="row">
    <!-- Situation -->
    <div class="col-md-2">
        <h1 style="color: blue;"><u>Situation</u></h1>

        <h3>What has happened?</h3>

        <div class="">
            <ul class="lead">
                <li>What?</li>
                <li>Where?</li>
                <li>When?</li>
                <li>How?</li>
                <li># of Persons?</li>
                <li>Other Info?</li>
            </ul>
        </div>
    </div>

    <!-- Mission -->
    <div class="col-md-2">

        <h1 style="color: blue;"><u>Mission</u></h1>

        <h3>What are we doing?</h3>

        <div class="">
            <ul class="lead">
                <li>Search</li>
                <li>Tow</li>
                <li>Casualty Care</li>
                <li>Transfer</li>
                <li>Other</li>
            </ul>
        </div>
    </div>

    <!-- Execution -->
    <div class="col-md-2">
        <h1 style="color: blue;"><u>Execution</u></h1>

        <h3>What Needs Done?</h3>

        <div class="">
            <ul class="lead">
                <li>Boat Kit / PPE</li>
                <li>Navigation</li>
                <li>Communication</li>
                <li>Weather Breifing</li>
                <li>Launch</li>
                <li>Other</li>
            </ul>
        </div>
    </div>

    <!-- Admin -->
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
                    <#elseif admin.type = "Info">
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
                    <option>Info</option>
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

    </div>

    <!-- Confirm -->
    <div class="col-md-1">
        <h2 style="color: blue;"><u>Confirm</u></h2>
        <ul class="lead">
            <li>LA?</li>
            <li>Roles?</li>
            <li>Comms?</li>
            <li>Kit</li>
            <li>Q's?</li>

        </ul>

    </div>

</div>

<!-- Weather -->
<div class="row">
    <div class="col-md-6">
        <h1><u>Weather (Local) &amp; Tides (UTC)</u></h1>

        <div>
            <iframe id="tides" name="tides"
                    src="http://www.bbc.co.uk/weather/coast_and_sea/tide_tables/7/223#tide-details"
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

            <!-- http://www.metoffice.gov.uk/public/weather/forecast/gcynfjhev#fcContent -->

        </div>
    </div>

    <div class="col-md-6">
        <div id="forecast">
            <h3 id="t"></h3>
            <p>Issued by the Met Office at <span id="metOfficeTime"></span>. <br/>
                Inshore Waters Forecast to 12 miles offshore.  <br/>
                For the period <span id="dateFromTo"></span></p>
            <h4>General Situation</h4>
            <p id="gst"></p>

            <h4 id="h"></h4>

            <div id="currentForcast">
                <h5 id="f_tx"></h5>
                <p>
                    <span id="f_w"></span>
                    <span if="f_ss"></span>
                    <span id="f_wt"></span>
                    <span id="f_v"></span>
                </p>
            </div>

            <div id="futureForcast">
                <h5 id="o_tx"></h5>
                <p>
                    <span id="o_w"></span>
                    <span if="o_ss"></span>
                    <span id="o_wt"></span>
                    <span id="o_v"></span>
                </p>
            </div>


        </div>
    </div>
</div>

<!-- AIS -->
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


<script>

    $.get("http://0.0.0.0:9090/met-office", function (data) {

        /*
        Met Office Code to ensure date formatting is correct
         */
        var pXML = $(data),
                areas,
                iD,
                vF,
                vFD,
                vFT,
                vT,
                vTD,
                vTT,
                issueDate = new Date(),
                validFromDate = new Date(),
                validToDate = new Date(),
                htmlCode = '',
                dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        // build up the issue date in '1130 UTC on Tuesday 25 September 2015' format
        iD = pXML.find('iUTC').attr('dUTC').split('-');
        issueDate.setUTCFullYear(iD[0], iD[1] - 1, iD[2]);
        issueDate.setUTCHours(0, 0, 0, 0);
        iD = pXML.find('iUTC').attr('tUTC') + ' UTC on ' + dayNames[issueDate.getUTCDay()] + ' ' + issueDate.getUTCDate() + ' ' + monthNames[issueDate.getUTCMonth()] + ' ' + issueDate.getUTCFullYear();

        // build up the valid from date in '1130 UTC Wednesday 26 September' format
        vF = pXML.find('v').attr('fm').split('T');
        vFD = vF[0].split('-');
        vFT = vF[1].split(':');
        vFT = vFT[0] + vFT[1] + ' UTC ';
        validFromDate.setUTCFullYear(vFD[0], vFD[1] - 1, vFD[2]);
        validFromDate.setUTCHours(0, 0, 0, 0);
        vFD = vFT + dayNames[validFromDate.getUTCDay()] + ' ' + validFromDate.getUTCDate() + ' ' + monthNames[validFromDate.getUTCMonth()];

        // build up the valid to date in '1130 UTC Wednesday 26 September 2015' format
        vT = pXML.find('v').attr('To').split('T');
        vTD = vT[0].split('-');
        vTT = vT[1].split(':');
        vTT = vTT[0] + vTT[1] + ' UTC ';
        validToDate.setUTCFullYear(vTD[0], vTD[1] - 1, vTD[2]);
        validToDate.setUTCHours(0, 0, 0, 0);
        vTD = vTT + dayNames[validToDate.getUTCDay()] + ' ' + validToDate.getUTCDate() + ' ' + monthNames[validToDate.getUTCMonth()] + ' ' + validToDate.getUTCFullYear();

        /*
        End of Met office Code
         */

        $xml = $(data),
                $t = $xml.find("t"),
                $gst = $xml.find("gst"),
                $bk = $xml.find('bk[id="' + 2 + '"]'),
                $h = $bk.find('h'),
                $sw = $bk.find('sw'),

                $f = $bk.find('f'),
                $f_tx = $f.find('tx'),
                $f_w = $f.find('w'),
                $f_ss = $f.find('ss'),
                $f_wt = $f.find('wt'),
                $f_v = $f.find('v'),

                $o = $bk.find('o');
                $o_tx = $o.find('tx'),
                $o_w = $o.find('w'),
                $o_ss = $o.find('ss'),
                $o_wt = $o.find('wt'),
                $o_v = $o.find('v');


        // Top information
        $("#t").append($t.text());
        $("#dateFromTo").append(vFD + ' to ' + vTD );
        $("#metOfficeTime").append(iD);

        // general headers
        $("#gst").append($gst.text());
        $("#bk").append($bk.text());
        $("#h").append($h.text());
        $("#sw").append($sw.text());

        // current forecast
        $("#f").append($f.text());
        $("#f_tx").append($f_tx.text());
        $("#f_w").append($f_w.text());
        $("#f_ss").append($f_ss.text());
        $("#f_wt").append($f_wt.text());
        $("#f_v").append($f_v.text());

        // outlook forecast
        $("#o").append($o.text());
        $("#o_tx").append($o_tx.text());
        $("#o_w").append($o_w.text());
        $("#o_ss").append($o_ss.text());
        $("#o_wt").append($o_wt.text());
        $("#o_v").append($o_v.text());
    }, "xml");

</script>

</body>

</html>