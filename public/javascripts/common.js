var inputElement;
function show_loading() {
	$('loading').style.display = 'block';
}
function hide_loading() {
	$('loading').style.display = 'none';	
}
function restoreBackground() {
	inputElement.setStyle({backgroundColor: '#FFFFFF'});
	inputElement = null;
}
function blockComma(element) {
	inputElement = element;
	var txt = inputElement.value;
	if (txt.include(',')) {
		inputElement.setStyle({backgroundColor: '#FF8080'});
		window.setTimeout(restoreBackground, 200);
		inputElement.value = txt.gsub(',', '');
	}
//	if (event.keyCode == 188 || (event.keyCode == 191 && event.shiftKey) ) 
//		Event.stop(event);
}
