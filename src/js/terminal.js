//https://codepen.io/uplusion23/pen/qbJVdg
$('#rick').hide();


var terminalElement = $(".terminal")[0];
var dialogue	=	document.getElementsByClassName("dialogue")[0];
1 || (function(o){
  var open = false;
  Object.defineProperty(o, "open", {
    get:	function(){ return o.classList.contains("open"); },
    set:	function(i){ o.classList.toggle("open", !!i); }
  });
}(dialogue));
function snakeText(from, to, refreshRate, charAmount, autoScroll, endFunction){

  var fromText, toText, l, i,
    refreshRate		=	refreshRate	|| 20,
    charAmount		=	charAmount	|| 1;
  if(3 === from.nodeType) fromText = from;
  else for(i = l = from.childNodes.length-1; i >= 0; --i)
    if(3 === from.childNodes[i].nodeType){
      fromText = from.childNodes[i];
      break;
    }
  if(!fromText) throw new ArgumentError("Source object is neither a text node or element containing any text nodes.");
  if(3 === to.nodeType) toText = to;
  else for(i = l = to.childNodes.length-1; i >= 0; --i)
    if(3 === to.childNodes[i].nodeType){
      toText	=	to.childNodes[i];
      break;
    }

  toText	=	toText || to.appendChild(document.createTextNode(""));
  var interval = setInterval(function(){

    var from	=	fromText.data;
    if(!from.length) {
      if(endFunction) loadSite();
      return clearInterval(interval);
    }
    toText.data		+=	from.substr(0, charAmount);
    fromText.data	=	from.substr(charAmount);

    if(autoScroll && ($('.terminalwrapper').get(0).scrollTop > 20))
      console.log($('.terminalwrapper').get(0).scrollTop)
    $('.terminalwrapper').animate({
      scrollTop: $('.terminalwrapper').get(0).scrollHeight}, 0);



  }, refreshRate);
  return interval;
}

var stringData = "\n kevin@murphy ~ $ sudo su \n [sudo] password for kevin:       \n murphy # ./kevin.run\n Loading Website.... \n .. \n .. \n .. \n"
stringData2 = "\n\n\n\n ERROR \n CRITICAL ERROR. \n ABORT ABORT. \n WHY IS THIS HAPPENING? \n AAAAAAAAAAAAAA\n HELP\n 1234567890\n 42\n Your life is a lie.\n Nothing is real "

//snakeText(document.createTextNode(stringData), terminalElement, 53, 2, true, true);


function loadSite(){
    $("body").fadeOut(1000,function(){
      window.location.replace("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
    });
}

function lol(){
  $('#rick').show();
  $("#player")[0].src += "?autoplay=1";
  $("#Title").text("I'M SORRY");
  $("#Subtitle").text("THIS WASN'T SUPPOSED TO HAPPEN");
  snakeText(document.createTextNode(stringData2), terminalElement, 455, 1, true, false);
}

