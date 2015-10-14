;(function() {
    var messagingIframe,
        bridge = 'external',
        PROTOCOL_SCHEME = 'tfcall';
  
    if (window[bridge]) { return }

	function _createQueueReadyIframe(doc) {
        messagingIframe = doc.createElement('iframe');
		messagingIframe.style.display = 'none';
		doc.documentElement.appendChild(messagingIframe);
	}
	window[bridge] = {};
    var methods = [%@];
    for (var i=0;i<methods.length;i++){
        var method = methods[i];
        var code = "(window[bridge])[method] = function " + method + "() {messagingIframe.src = PROTOCOL_SCHEME + ':' + arguments.callee.name + ':' + encodeURIComponent(JSON.stringify(arguments));}";
        eval(code);
    }
  
    _createQueueReadyIframe(document);
})();
