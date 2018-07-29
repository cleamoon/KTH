// compilation

function compile() {

  if (running) {
    togglerun();
  }
  robotPos = {
  'x': 0.,
  'y': 0.,
  'theta': 0.
  };
  startgoalpos = {
    "x0": 0.,
    "y0": 0.,
    "xg": 0.,
    "yg": 0.
  };
  draw();

  var own_files = $('#own_files')[0].files;
  var controller_file_found = false;
  var variables_file_found = false;
  var renew_state_file_found = false;
  for (i = 0; i < own_files.length; i++) {
    if (own_files[i].name == "Controller.c") {
      controller_file = own_files[i];
      controller_file_found = true;
    }
    if (own_files[i].name == "OwnVariables.c") {
      variables_file = own_files[i];
      variables_file_found = true;
    }
    if (own_files[i].name == "RenewControllerState.c") {
      renew_state_file = own_files[i];
      renew_state_file_found = true;
    }
  }
  if (!controller_file_found) {
    alert("No file Controller.c found")
    return
  }
  if (!variables_file_found) {
    alert("No file OwnVariables.c found")
    return
  }
  if (!renew_state_file_found) {
    alert("No file RenewControllerState.c found")
    return
  }

  load_file_state = "load_controller_file";
  reader = new FileReader();
  reader.onload = function(event) {
    if (load_file_state == "load_variables_file") {
      variable_file_content = event.target.result;
      compile_files_loaded();
    } else
    if (load_file_state == "load_renew_state_file") {
      renew_state_file_content = event.target.result;
      load_file_state = "load_variables_file";
      reader.readAsText(variables_file);
    } else
    if (load_file_state == "load_controller_file") {
      controller_file_content = event.target.result;
      load_file_state = "load_renew_state_file";
      reader.readAsText(renew_state_file);
    }
  };
  reader.readAsText(controller_file);

}

function compile_files_loaded() {

  student_code = {
    'OwnVariables': variable_file_content,
    'Controller': controller_file_content,
    'RenewControllerState': renew_state_file_content
  };

  log_text("Requested compilation, waiting for the result...");
  $.get("compile", student_code).done(compile_result);

}

function compile_result(result_str) {

  result = JSON.parse(result_str);

  log_text('--------- compilation result ---------');
  log_text(result['compile_out']);
  log_text('--------------------------------------');
  if (result['status'] == 'error') { // compilation did not work at all
    successful_compile = false;
    $('#robot_embed').html('');
    $('#runbutton').addClass('diasbled');
    $('#setpositionbutton').addClass('disabled');
    log_text("There is something wrong with the backend. Try reloading the page!");
  }
  if (result['status'] == 'success') {
    if (result['compilation_status'] == 'not_compiled') {
      successful_compile = false;
      $('#robot_embed').html('');
      $('#runbutton').addClass('disabled');
      $('#setpositionbutton').addClass('disabled');
    }
    if (result['compilation_status'] == 'compiled') {
      successful_compile = true;
      $('#robot_embed').html('<embed width=0 height=0 id="robot_sim" src="results/' + result['result_folder'] + '/robot_controller.nmf" type="application/x-pnacl" />');
      $('#runbutton').removeClass('disabled');
      $('#setpositionbutton').removeClass('disabled');
    }
  }

}

// rendering

function get_mapposition(robotPos) {

  // converts from reality to map coordinates
  var xoffset = -1.1;
  var yoffset = 2.4;
  var thetaoffset = 0.;
  var xscale = 164.214847759152;
  var yscale = 165.860400829302;
  var thetascale = Math.PI / 180;

  var realx = robotPos['x'];
  var realy = robotPos['y'];


  var mapx = (realx - xoffset) * xscale
  var mapy = (-realy + yoffset) * yscale
  
  if ('theta' in robotPos) {
    var realtheta = robotPos['theta'];
    var maptheta = (realtheta - thetaoffset) * thetascale;
  }
  else {
    var maptheta = -1;
  }
  return {
    'x': Math.round(mapx),
    'y': Math.round(mapy),
    'theta': maptheta
  }

}

function get_realposition(mapx, mapy) {

  // converts from reality to map coordinates
  var xoffset = -1.1;
  var yoffset = 2.4;
  var xscale = 164.214847759152;
  var yscale = 165.860400829302;

  var realx = mapx / xscale + xoffset;
  var realy = -1 * mapy / yscale + yoffset;

  return {
    'x': realx,
    'y': realy
  };

}

function drawStartGoal(ctx, SGPos) {

  var size = 25;
  var startPos = get_mapposition({'x':SGPos['x0'], 'y':SGPos['y0']});
  var goalPos = get_mapposition({'x':SGPos['xg'], 'y':SGPos['yg']});
  x0 = startPos['x'];
  y0 = startPos['y'];
  xg = goalPos['x'];
  yg = goalPos['y'];
  ctx.strokeStyle = '#0000FF';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(x0, y0);
  ctx.lineTo(xg, yg);
  ctx.stroke();

}

function drawRobot(ctx, robotPos) {

  var size = 25;
  var mapPos = get_mapposition(robotPos);
  x = mapPos['x'];
  y = mapPos['y'];
  heading = mapPos['theta'];
  ctx.strokeStyle = '#000000';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(x, y);
  ctx.arc(x, y, size, 0, 2 * Math.PI);
  ctx.fillStyle = "#FFFF00";
  ctx.stroke();
  ctx.fill();
  if (pacman) {
    ctx.beginPath();
    ctx.moveTo(x, y);
    ctx.fillStyle = "#000000";
    ctx.arc(x, y, size, -pacm * Math.PI-heading, pacm * Math.PI-heading);
    ctx.stroke();
    ctx.fill();
    if (pacm > 0.2) {
      pacs = -0.01;
    }
    if (pacm <= 0.01) {
      pacs = 0.01;
    }
    pacm += pacs;
  }
  ctx.beginPath();
  ctx.strokeStyle = '#000000';
  ctx.lineWidth = 2;
  ctx.moveTo(x, y);
  ctx.lineTo(x + size * Math.cos(heading), y - size * Math.sin(heading));
  ctx.stroke();

}

function tooglePacman(){pacman=!pacman;}

function drawCorridor(ctx) {

  var offsetX = -60;
  var offsetY = -60;
  lineWidth = 60;
  gridSize = 2 * lineWidth;


  ctx.strokeStyle = '#FFFFFF';
  ctx.fillStyle = '#FFFFFF';
  ctx.lineWidth = lineWidth;

  map_nodes = {
    1: [1, 1],
    2: [3, 1],
    3: [5, 1],
    4: [1, 3],
    5: [3, 3],
    6: [5, 3],
    7: [1, 5],
    8: [3, 5],
    9: [5, 5]
  };
  map_edges = [
    [1, 2],
    [2, 3],
    [4, 5],
    [5, 6],
    [7, 8],
    [8, 9],
    [1, 4],
    [2, 5],
    [3, 6],
    [4, 7],
    [5, 8],
    [6, 9]
  ];

  map_nodes_pos = {};
  for (var node in map_nodes) {
    map_nodes_pos[node] = [map_nodes[node][0] * gridSize + offsetX, map_nodes[node][1] * gridSize + offsetY];
  }

  for (var edge_i in map_edges) {
    var edge = map_edges[edge_i];
    var xs = map_nodes[edge[0]][0] * gridSize + offsetX;
    var ys = map_nodes[edge[0]][1] * gridSize + offsetY;
    var xd = map_nodes[edge[1]][0] * gridSize + offsetX;
    var yd = map_nodes[edge[1]][1] * gridSize + offsetY;
    ctx.beginPath();
    ctx.moveTo(xs, ys);
    ctx.lineTo(xd, yd);
    ctx.stroke();
    ctx.beginPath();
    ctx.fillRect(xs - lineWidth / 2, ys - lineWidth / 2, lineWidth, lineWidth);
    ctx.beginPath();
    ctx.fillRect(xd - lineWidth / 2, yd - lineWidth / 2, lineWidth, lineWidth);
  }

  ctx.fillStyle = '#FF0000';
  for (var node in map_nodes) {
    ctx.font = "20px Georgia";
    ctx.fillText(node, map_nodes[node][0] * gridSize + offsetX, map_nodes[node][1] * gridSize + offsetY);
  }

  var mapZero = get_mapposition({
    'x': 0,
    'y': 0,
    'theta': 0
  });

  ctx.lineWidth = 6;
  ctx.strokeStyle = '#0000FF';
  ctx.fillStyle = '#0000FF';
  ctx.beginPath();
  ctx.moveTo(mapZero['x'], mapZero['y']);
  ctx.lineTo(mapZero['x'] + 30, mapZero['y']);
  ctx.stroke();
  ctx.beginPath();
  ctx.moveTo(mapZero['x'], mapZero['y']);
  ctx.lineTo(mapZero['x'], mapZero['y'] - 30);
  ctx.stroke();
  ctx.beginPath();
  ctx.fillRect(mapZero['x'] - 3, mapZero['y'] - 3, 6, 6);

}

function draw() {

  ctx.clearRect(0, 0, c.width, c.height);
  drawCorridor(ctx);
  drawStartGoal(ctx, startgoalpos);
  drawRobot(ctx, robotPos);
  $("#x_diplay").text(robotPos["x"].toFixed(2));
  $("#y_diplay").text(robotPos["y"].toFixed(2));
  $("#theta_diplay").text(robotPos["theta"].toFixed(0));

}

// logging

function log_text(text) {

  debug_log += text;
  if (text.substr(-1) != "\n")
    debug_log += "\n";
  new_text = true;
}

function update_textarea() {

  if (new_text) {
    textarea.value = debug_log;
    textarea.scrollTop = textarea.scrollHeight;
    new_text = false;
  }
}

function getposlog() {

  if (!logging) {

    var blob = new Blob([pos_log], {
      type: 'text/css'
    });
    url = window.URL.createObjectURL(blob);
    a_pos.href = url;
    a_pos.download = 'pos_log.csv';
    a_pos.click();
    window.URL.revokeObjectURL(url);

  }

}

function getserlog() {

  if (!logging) {

    var blob = new Blob([serial_log], {
      type: 'text/css'
    });
    url = window.URL.createObjectURL(blob);
    a_ser.href = url;
    a_ser.download = 'serial_log.csv';
    a_ser.click();
    window.URL.revokeObjectURL(url);

  }

}

function clearlog() {

  if (confirm('Do you really want to clear the log?')) {
    pos_log = 'timestamp;x;y;theta\n';
    serial_log = 'timestamp;message\n';
  }

}

function togglelogging() {

  if (logging) {
    logging = false;
    $('#logbutton').removeClass('active');
    $('#clearlogbutton').removeClass('disabled');
    $('#getposlogbutton').removeClass('disabled');
    $('#getserlogbutton').removeClass('disabled');
  } else {
    logging = true;
    $('#logbutton').addClass('active');
    $('#clearlogbutton').addClass('disabled');
    $('#getposlogbutton').addClass('disabled');
    $('#getserlogbutton').addClass('disabled');
  }

}

// robot control

function updatePos() {

  if (robotSimLoaded) {
    RobotSim.postMessage({
      "command": "mocap?",
      "dt": 1. / MocapUpdateHz
    });
  }

}

function togglerun() {

  if (successful_compile) {
    if (initialized & !running) {
      control_interval = setInterval(updateControl, 1. / ControlUpdateHz * 1000);
      mocap_interval = setInterval(updatePos, 1. / MocapUpdateHz * 1000);
      running = true;
      $('#runbutton').addClass('active')
      $('#leftbutton').removeClass('disabled');
      $('#forwardbutton').removeClass('disabled');
      $('#backwardbutton').removeClass('disabled');
      $('#rightbutton').removeClass('disabled');
      //$('#clearlogbutton').removeClass('disabled');
      $('#logbutton').removeClass('disabled');
      //$('#getlogbutton').removeClass('disabled');
      $('#controlonbutton').removeClass('disabled');
      $('#send_waypoints_button').removeClass('disabled');
    } else {
      clearInterval(control_interval);
      clearInterval(mocap_interval);
      $('#runbutton').removeClass('active')
      $('#leftbutton').addClass('disabled');
      $('#forwardbutton').addClass('disabled');
      $('#backwardbutton').addClass('disabled');
      $('#rightbutton').addClass('disabled');
      $('#clearlogbutton').addClass('disabled');
      $('#logbutton').addClass('disabled');
      $('#getposlogbutton').addClass('disabled');
      $('#getserlogbutton').addClass('disabled');
      $('#controlonbutton').addClass('disabled');
      $('#send_waypoints_button').addClass('disabled');
      if (autocontrol) {
        togglecontrol();
      }
      running = false;
      $('#runbutton').removeClass('active')
    }
  }

}

function togglecontrol() {

  if (successful_compile & initialized & running) {
    if (!autocontrol) {
      autocontrol = true;
      $('#controlonbutton').addClass('active');
      $('#setreferencebutton').removeClass('disabled');
      //$('#send_waypoints_button').removeClass('disabled');
      $('#leftbutton').addClass('disabled');
      $('#forwardbutton').addClass('disabled');
      $('#backwardbutton').addClass('disabled');
      $('#rightbutton').addClass('disabled');
      if (send_waypoints) {
        send_next_waypoint();
      } else {
        setreference();
      }
    } else {
      autocontrol = false;
      $('#controlonbutton').removeClass('active');
      $('#setreferencebutton').addClass('disabled');
      //$('#send_waypoints_button').addClass('disabled');
      $('#leftbutton').removeClass('disabled');
      $('#forwardbutton').removeClass('disabled');
      $('#backwardbutton').removeClass('disabled');
      $('#rightbutton').removeClass('disabled');
    }
  }

}

function updateControl() {

  if (robotSimLoaded) {
    if (autocontrol) {
      setAutomatic();
    } else {
      setManual();
    }
    $("#control_pulse_on").fadeToggle(0.2 / ControlUpdateHz * 1000).fadeToggle(0.2 / ControlUpdateHz * 1000);
  }

}

function setManual() {

  RobotSim.postMessage({
    "command": "manual",
    "left": Math.round(speed - 0.5 * rotSpeed),
    "right": Math.round(speed + 0.5 * rotSpeed)
  });

}

function setAutomatic() {

  RobotSim.postMessage({
    "command": "pose",
    "x": 100.0 * robotPos["x"],
    "y": 100.0 * robotPos["y"],
    "theta": robotPos["theta"]
  });

}

function moveforward() {
  speed = parseInt($('#u_forward')[0].value);
}

function movebackward() {
  speed = -parseInt($('#u_forward')[0].value);
}

function stopforward() {
  speed = 0.;
}

function rotateright() {
  rotSpeed = -parseInt($('#u_rot')[0].value);
}

function rotateleft() {
  rotSpeed = parseInt($('#u_rot')[0].value);
}

function stoprotate() {
  rotSpeed = 0.;
}

function select_start_node() {

  var node = $("#select_start_node")[0].value;
  console.log(node);
  if (node == 0) {
    var real_pos = {'x':0., 'y':0.};
  } 
  else {
    var x = map_nodes_pos[node][0];
    var y = map_nodes_pos[node][1];
    var real_pos = get_realposition(x, y);
  }
  $("#ref_x_s")[0].value = parseFloat(real_pos['x'].toFixed(4));
  $("#ref_y_s")[0].value = parseFloat(real_pos['y'].toFixed(4));
  $("#pos_x")[0].value = parseFloat(real_pos['x'].toFixed(4));
  $("#pos_y")[0].value = parseFloat(real_pos['y'].toFixed(4));

}

function select_goal_node() {

  var node = $("#select_goal_node")[0].value;
  if (node == 0) {
    var real_pos = {'x':0., 'y':0.};
  } 
  else {
    var x = map_nodes_pos[node][0];
    var y = map_nodes_pos[node][1];
    var real_pos = get_realposition(x, y);
  }
  $("#ref_x_g")[0].value = parseFloat(real_pos['x'].toFixed(4));
  $("#ref_y_g")[0].value = parseFloat(real_pos['y'].toFixed(4));

}

function setposition() {

  RobotSim.postMessage({
    "command": "setpos",
    "x": parseFloat($("#pos_x")[0].value),
    "y": parseFloat($("#pos_y")[0].value),
    "theta": parseFloat($("#pos_theta")[0].value)
  });
  updatePos();

}

function setreference() {

  startgoalpos = {
    "x0": parseFloat($("#ref_x_s")[0].value),
    "y0": parseFloat($("#ref_y_s")[0].value),
    "xg": parseFloat($("#ref_x_g")[0].value),
    "yg": parseFloat($("#ref_y_g")[0].value)
  };
  RobotSim.postMessage({
    "command": "startgoal",
    "x0": 100.0 * parseFloat($("#ref_x_s")[0].value),
    "y0": 100.0 * parseFloat($("#ref_y_s")[0].value),
    "xg": 100.0 * parseFloat($("#ref_x_g")[0].value),
    "yg": 100.0 * parseFloat($("#ref_y_g")[0].value)
  });

}

function toggle_send_waypoints() {

  if (running & !send_waypoints) {
    send_waypoints = true;
    $('#send_waypoints_button').addClass('active');
    $('#setreferencebutton').addClass('disabled');
    if (autocontrol) {
      send_next_waypoint();
    }
  } else {
    send_waypoints = false;
    $('#send_waypoints_button').removeClass('active');
    $('#setreferencebutton').removeClass('disabled');

  }

}


// function start_waypoint_navigation() {
//   if (running & !send_waypoints) {
//     send_waypoints = true;
//     $('#send_waypoints_button').addClass('active');
//     $('#setreferencebutton').addClass('disabled');
//     if (autocontrol) {
//       send_next_waypoint();
//     }
//   }
// }
//
//
// function end_waypoint_navigation(){
//   send_waypoints = false;
//   $('#send_waypoints_button').removeClass('active');
//   $('#setreferencebutton').removeClass('disabled');
// }



function send_next_waypoint() {

  var text = $('#input_waypoints')[0].value;
  if (text == '') {
    log_text('No more waypoints found.');
    toggle_send_waypoints();
  } else {
    var lines = text.split('\n');
    var first_line = lines.shift();
    var fields = first_line.split(';')
    if (fields.length != 4) {
      log_text('Invalid format for the next waypoint.');
      $('#input_waypoints')[0].value = lines.join('\n');
      send_next_waypoint();
    } else {
      log_text('Sending robot from ' + fields[0] + ',' + fields[1] + ' to ' + fields[2] + ',' + fields[3]);
      startgoalpos = {
        "x0": parseFloat(fields[0]),
        "y0": parseFloat(fields[1]),
        "xg": parseFloat(fields[2]),
        "yg": parseFloat(fields[3])
      };
      RobotSim.postMessage({
        "command": "startgoal",
        "x0": 100.0 * parseFloat(fields[0]),
        "y0": 100.0 * parseFloat(fields[1]),
        "xg": 100.0 * parseFloat(fields[2]),
        "yg": 100.0 * parseFloat(fields[3])
      });
    }
    $('#input_waypoints')[0].value = lines.join('\n');
  }

}

function handleMessage(message_event) {

  var data = message_event.data;
  if (data["type"] == "mocap?_reply") {
    if (logging) {
      pos_log += Date.now() + ';' + data['x'] + ';' + data['y'] + ';' + data['theta'] + '\n';
    }
    robotPos = {
      'x': data["x"],
      'y': data["y"],
      'theta': data["theta"]
    };
    draw();
  }
  if (data["type"] == "serial_message") {
    log_text(data["load"]);
    serial_log += Date.now() + ';' + data['load'] + '\n';
  }
  if (data["type"] == "done") {
    if (send_waypoints) {
      send_next_waypoint();
    }
  }

}

// init

function moduleDidLoad() {

  console.log("Module loaded");
  RobotSim = document.getElementById('robot_sim');
  robotSimLoaded = true;
  draw();

}

function init() {

  c = $('#myCanvas')[0];
  ctx = c.getContext('2d');
  draw();
  initialized = true;
  textarea = $("#log_textarea")[0];

  setInterval(update_textarea, 1000);
  
  a_pos = document.createElement("a");
  document.body.appendChild(a_pos);
  a_pos.style = "display: none";
  
  a_ser = document.createElement("a");
  document.body.appendChild(a_ser);
  a_ser.style = "display: none";

}

robotSimLoaded = false;


robotPos = {
  'x': 0.,
  'y': 0.,
  'theta': 0.
};
startgoalpos = {
    "x0": 0.,
    "y0": 0.,
    "xg": 0.,
    "yg": 0.
  };
speed = 0.;
rotSpeed = 0.;
pacm = 0;
pacs = 0.01;
pacman = false;

MocapUpdateHz = 50.;
ControlUpdateHz = 1.;

initialized = false;
running = false;
autocontrol = false;
logging = false;
successful_compile = false;
send_waypoints = false;
new_text = false;

pos_log = 'timestamp;x;y;theta\n';
serial_log = 'timestamp;message\n';

debug_log = '';

$(document).ready(init);
