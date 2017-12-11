"use strict";
var socket = new WebSocket("ws://localhost:5555/ws");

var my_gid = guid();
var my_cookie = "guid=" + my_gid;

// menu functions

function home(ce) {
    log_this("user clicked " + ce, 0);
};

function my_projects(ce) {
    log_this("user clicked " + ce, 0);
};

function my_contracts(ce) {
    log_this("user clicked " + ce, 0);
};

function my_actions(ce) {
    log_this("user clicked " + ce, 0);
};

function contact(ce) {
    log_this("user clicked " + ce, 0);
};

function about(ce) {
    log_this("user clicked " + ce, 0);
};

function help(ce) {
    log_this("user clicked " + ce, 0);
};


// websocket
function init() {
    log_this("init client with uuid " + my_gid, 0);
    document.cookie = my_cookie;
    if (!("WebSocket" in window)) {
        log_this("websockets are not supported", 1);
    } else {
        log_this("websockets are supported", 0);
    }
    // set inital data
    document.getElementById("identity").innerHTML = my_gid;
};

init();

socket.onopen = function () {
    log_this("websockets connection ok", 0);
};

// callback-Funktion wird gerufen, wenn eine neue Websocket-Nachricht eintrifft
socket.onmessage = function (messageEvent) {
    var message = messageEvent.data;
    log_this("incomming message : " + message, 0);
};

// callback-Funktion wird gerufen, wenn eine Fehler auftritt
socket.onerror = function (errorEvent) {
    log_this("error! connection lost", 1);
};

socket.onclose = function (closeEvent) {
    log_this("Connection closed, Code: " + closeEvent.code + " reason: " + closeEvent.reason, 1);
};

// utils
// http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16)
            .substring(1);
    }

    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4()
        + s4() + s4();
}


// log
function log_this(message, log_type) {
    console.log(message);
    var current_time = new Date();
    var div = document.createElement("div");

    if (log_type == 0) {
        div.className = "log_info";
    } else if (log_type == 1) {
        div.className = "log_error";
    } else if (log_type == 2) {
        div.className = "log_debug";
    } else if (log_type == 3) {
        div.className = "log_trace";
    } else {
        div.className = "log";
    }

    div.innerHTML = "<span>" + current_time + "-" + message + "</span>";

    document.getElementById("log").insertBefore(div,
        document.getElementById("log").firstChild);
}

// tests
function test(ce) {
    log_this("user clicked " + ce, 0);
    log_this("test_info_log", 0);
    log_this("test_error_log", 1);
    log_this("test_debug_log", 2);
    log_this("test_trace_log", 3);
    log_this("generate test guid " + guid(), 0);
}