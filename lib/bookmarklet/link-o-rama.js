//<a href="http://www.harmless.com/" onclick="var f = docu- ment.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = 'http://www.example.com/account/destroy'; f.submit();return false;">To the harmless survey</a>
//This should be a lot easier and with a better callback than an 'ok' alert
(function(){
  var script = document.createElement("script");
  script.src = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
  script.onload = script.onreadystatechange = function(){
    $.post('http://localhost:5000/add', {data:encodeURI(window.location), success: function(){alert('ok')}});
  };
  document.getElementsByTagName("head")[0].appendChild(script);
})();
