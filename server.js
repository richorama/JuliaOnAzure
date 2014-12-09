var spawn = require('child_process').spawn;
console.log("node is about to start julia");

var ls = spawn('bin\\julia.exe', ["server.jl", process.env.port], function callback(error, stdout, stderr){
    console.log(error);
    console.log(stdout);
    console.log(stderr);
});

ls.stdout.on('data', function (data) {
  console.log('stdout: ' + data);
});

ls.stderr.on('data', function (data) {
  console.log('stderr: ' + data);
});

ls.on('close', function (code) {
  console.log('child process exited with code ' + code);
});