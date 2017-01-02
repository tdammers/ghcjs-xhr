function ghcjs_xhr$ajax(method, url, contentType, body, cont) {
    xhr = ghcjs_xhr$createXMLHTTPObject();
    if (!xhr) {
        cont({status: 500, response: "No XMLHttpRequest implementation found"});
        return;
    }
    xhr.open(method, url, true);
    xhr.setRequestHeader('Content-type', contentType);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            cont(xhr);
        }
    }
    if (body) {
        xhr.send(body);
    }
    else {
        xhr.send();
    }
}

function ghcjs_xhr$xhrGetStatus(xhr) {
    return xhr.status;
}

function ghcjs_xhr$xhrGetBody(xhr) {
    return xhr.response;
}

var ghcjs_xhr$XMLHttpFactories = [
    function () { return new XMLHttpRequest(); },
    function () { return new ActiveXObject("Msxml2.XMLHTTP"); },
    function () { return new ActiveXObject("Msxml3.XMLHTTP"); },
    function () { return new ActiveXObject("Microsoft.XMLHTTP"); }
];

function ghcjs_xhr$createXMLHTTPObject() {
    var xmlhttp = false;
    for (var i=0; i<ghcjs_xhr$XMLHttpFactories.length; i++) {
        try {
            xmlhttp = ghcjs_xhr$XMLHttpFactories[i]();
        }
        catch (e) {
            continue;
        }
        break;
    }
    return xmlhttp;
}
