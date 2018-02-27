"use strict";
var socket = new WebSocket("ws://localhost:5555/websocket");

var my_gid = guid();
var my_cookie = "guid=" + my_gid;

var ip_info;

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

function is_websocket_closed() {
    if (socket.readyState == WebSocket.CLOSED) {
        log_this("websocket was closed, reopen", 2);
        socket.onopen;
    } else {
        log_this("websocket is open", 0)
    }
}

function ws_send(data_to_send) {
    is_websocket_closed();
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
    var obj_to_log = JSON.stringify(message, undefined);

    log_this(obj_to_log, 0);

    if (obj.hasOwnProperty('keys')) {
        document.getElementById("publicKey").innerHTML = obj.keys[1];
        document.getElementById("privateKey").innerHTML = obj.keys[3];
        document.getElementById("deposit").innerHTML = obj.keys[7];

    } else if (obj.hasOwnProperty('sign')) {
        document.getElementById("signatureArrea").innerHTML = obj.sign[1];
    } else if (obj.hasOwnProperty('verify')) {
        log_this(obj.verify[1], 0);
        var txt;
        if (true == obj.verify[1]) {
            txt = "Signature OK!";
        } else {
            txt = "Signature wrong!";
        }
        document.getElementById("message").innerHTML = txt;
    } else if (obj.hasOwnProperty('load')) {
        document.getElementById("ipLast").innerHTML = obj.load[5];
        document.getElementById("identityLast").innerHTML = obj.load[1];
        document.getElementById("deposit").innerHTML = obj.load[9];
    } else if (obj.hasOwnProperty('signforsend')) {
        document.getElementById("signatureToRecipientArrea").innerHTML = obj.signforsend[1];
    }
    else {
        log_this("ERROR " + obj, 1);
    }
};

// callback-Funktion wird gerufen, wenn eine Fehler auftritt
socket.onerror = function (errorEvent) {
    log_this("error! connection lost" + errorEvent, 1);
    is_websocket_closed();
};

socket.onclose = function (closeEvent) {
    log_this("Connection closed, Code: " + closeEvent.code + " reason: " + closeEvent.reason, 1);
    is_websocket_closed();
};

//common buttons
function load(ce) {
    log_this("user clicked " + ce, 0);
    if (socket.readyState == socket.OPEN) {
        var publicKey1 = document.getElementById("publicKey").value;

        var msg = {messageKey: "load", public_key: publicKey1};
        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

function getKeyPaar(ce) {
    log_this("user clicked " + ce, 0);
    if (socket.readyState == socket.OPEN) {

        var msg = {messageKey: "keys", guid: my_gid, ip: ip_info};
        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

// only user + sc
function my_sign(ce) {
    log_this("user clicked " + ce, 0);
    if (socket.readyState == socket.OPEN) {
        var message1 = document.getElementById("messageArrea").value;

        var key1 = document.getElementById("privateKey").value;
        var key2 = document.getElementById("publicKey").value;
        var msg = {messageKey: "sign", message: message1, privateKey: key1, publicKey: key2};

        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

function my_verify(ce) {
    log_this("user clicked " + ce, 0);
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

function my_set(ce) {
    log_this("user clicked " + ce, 0);
    // TODO
}

// transfer
function rec_sign(ce) {
    log_this("user clicked " + ce, 0);
    if (socket.readyState == socket.OPEN) {
        var message1 = document.getElementById("messageToRecipient").value;

        var key1 = document.getElementById("privateKey").value;
        var key2 = document.getElementById("publicKey").value;

        var recipient = document.getElementById("recipient").value;
        var msg = {
            messageKey: "signforsend",
            message: message1,
            privateKey: key1,
            publicKey: key2,
            recipient: recipient
        };

        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

function rec_verify(ce) {
    log_this("user clicked " + ce, 0);
    if (socket.readyState == socket.OPEN) {
        var signature1 = document.getElementById("signatureToRecipientArrea").value;

        var publicKey1 = document.getElementById("publicKey").value;
        var message1 = document.getElementById("messageToRecipient").value;
        var msg = {messageKey: "verify", publicKey: publicKey1, signature: signature1, message: message1};

        log_this(JSON.stringify(msg, null, 2), 0);
        socket.send(JSON.stringify(msg));
    } else {
        log_this('websocket is not connected', 1);
    }
}

function rec_send(ce) {
    log_this("user clicked " + ce, 0);
    // TODO
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

function create_block(pHash, Hash, MerkleRoot, Data, TimeStamp) {
    var div = document.createElement("div");
    div.innerHTML = "<span>" + current_time + "-" + message + "</span>";


    document.getElementById("blockchain").insertBefore(div,
        document.getElementById("blockchain").firstChild);
}

function createTable(pHash, Hash, MerkleRoot, Data, TimeStamp) {
    var table = document.createElement('table');

    var row0 = table.insertRow(0);
    var row1 = table.insertRow(1);
    var row2 = table.insertRow(2);
    var row3 = table.insertRow(3);
    var row4 = table.insertRow(4);

    var row0col1 = row0.insertCell(0);
    row0col1.innerHTML = 'pHash';

    var row1col1 = row1.insertCell(0);
    row1col1.innerHTML = 'Hash';

    var row2col1 = row2.insertCell(0);
    row2col1.innerHTML = 'Root';

    var row3col1 = row3.insertCell(0);
    row3col1.innerHTML = 'Data';

    var row4col1 = row4.insertCell(0);
    row4col1.innerHTML = 'TimeStamp';

    var row0col2 = row0.insertCell(1);
    row0col2.innerHTML = pHash;

    var row1col2 = row1.insertCell(1);
    row1col2.innerHTML = Hash;

    var row2col2 = row2.insertCell(1);
    row2col2.innerHTML = MerkleRoot;

    var row3col2 = row3.insertCell(1);
    row3col2.innerHTML = Data;

    var row4col2 = row4.insertCell(1);
    row4col2.innerHTML = TimeStamp;

    var div = document.getElementById('blockchain');
    div.appendChild(table);
}

// logging
function log_this(message, log_type) {
    //console.log(message);
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

    createTable("1", "2", "3", "4", "5");

    ws_test_send();
}

function ws_test_send() {
    ws_send("send test data");
}

// get ip address
$.getJSON('//freegeoip.net/json/?callback=?', function (data) {
    var info = JSON.stringify(data, null, 2);
    var json = JSON.parse(info);
    log_this(ip_info, 0);
    ip_info = json["ip"];
    document.getElementById("ip").innerHTML = ip_info;
});