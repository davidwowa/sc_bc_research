"use strict";
var socket = new WebSocket("ws://localhost:5555/websocket");

var my_gid = guid();
var my_cookie = "guid=" + my_gid;

var ip_info;

// menu functions
function home(ce) {
    log_this("user clicked " + ce, 0);
}

function my_projects(ce) {
    log_this("user clicked " + ce, 0);
}

function my_contracts(ce) {
    log_this("user clicked " + ce, 0);
}

function my_actions(ce) {
    log_this("user clicked " + ce, 0);
}

function contact(ce) {
    log_this("user clicked " + ce, 0);
}

function about(ce) {
    log_this("user clicked " + ce, 0);
}

function help(ce) {
    log_this("user clicked " + ce, 0);
}

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
}

init();

function ws_send(data_to_send) {
    log_this("send message over websocket " + data_to_send, 0);
    socket.send(data_to_send);
}

socket.onopen = function () {
    log_this("websockets connection ok", 0);
};

// callback-Funktion wird gerufen, wenn eine neue Websocket-Nachricht eintrifft
socket.onmessage = function (messageEvent) {
    var message = messageEvent.data;
    var obj = JSON.parse(message);

    if (obj.hasOwnProperty('keys')) {
        log_this(obj.keys[0] + " " + obj.keys[1], 0);
        log_this(obj.keys[2] + " " + obj.keys[3], 0);

        document.getElementById("publicKey").innerHTML = obj.keys[1];
        document.getElementById("privateKey").innerHTML = obj.keys[3];

    } else if (obj.hasOwnProperty('sign')) {

        log_this("signature to message " + obj.sign[1], 0);

        document.getElementById("signatureArrea").innerHTML = obj.sign[1];
    } else if (obj.hasOwnProperty('verify')) {
        log_this("verify " + obj.verify[1], 0);
    } else {
        log_this("ERROR " + obj, 1);
    }
};

// callback-Funktion wird gerufen, wenn eine Fehler auftritt
socket.onerror = function (errorEvent) {
    log_this("error! connection lost" + errorEvent, 1);
};

socket.onclose = function (closeEvent) {
    log_this("Connection closed, Code: " + closeEvent.code + " reason: " + closeEvent.reason, 1);
};

//buttons
function getKeyPaar() {
    if (socket.readyState == socket.OPEN) {
        var msg = {messageKey: "keys", guid: my_gid, ip: ip_info};
        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

function sign() {
    if (socket.readyState == socket.OPEN) {
        var message1 = document.getElementById("messageArrea").value;

        var key1 = document.getElementById("privateKey").value;
        var msg = {messageKey: "sign", message: message1, privateKey: key1};

        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

function verify() {
    if (socket.readyState == socket.OPEN) {
        var signature1 = document.getElementById("signatureArrea").value;

        var publicKey1 = document.getElementById("publicKey").value;
        var message1 = document.getElementById("messageArrea").value;
        var msg = {messageKey: "verify", publicKey: publicKey1, signature: signature1, message: message1};

        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

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

    ws_test_send();
}

function ws_test_send() {
    ws_send("send test data");
}

$.getJSON('//freegeoip.net/json/?callback=?', function (data) {
    var info = JSON.stringify(data, null, 2);
    var json = JSON.parse(info);
    log_this(ip_info, 0);
    ip_info = json["ip"];
    document.getElementById("ip").innerHTML = ip_info;
});