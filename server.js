var exec = require('child_process').exec;
exec('bin\\julia.exe', ["server.jl", process.env.port], function callback(error, stdout, stderr){
    console.log(error);
    console.log(stdout);
    console.log(stderr);
});