function ghcjs_xhr$ajax(method, url, contentType, body, cont) {
    xhr = new XMLHttpRequest();
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
