// Disabling copy to clipboard
function disabletext(e){
	if (e.target.id != "answers[]")
	return false
}

function reEnable(){
	return true
}
document.onselectstart=new Function ("return false")

//if the browser is NS6
if (window.sidebar){
document.onmousedown=disabletext
document.onclick=reEnable
}	

var sequence_number = 1;
function isAnswerSelected(form){
	var is_checked = $A($(form).getElementsByClassName('check_or_radio')).any( function(itm){return itm.checked; });
	if (is_checked) {
		return true;
		
	} else {
		alert("Выберите минимум один вариант ответа");
		return false;						
	}
}
function selectSeqAnswer(a) {
	if (a.checked) {
		form = a.up('form');
		var seq_id = a.up('.seq_container').id.substr(4);
		var check = $A($(form).getElementsByClassName('check_or_radio'))[seq_id];
		check.value = sequence_number;
		a.previous('.sequence_number').innerHTML = sequence_number;
		sequence_number++;

	} else 
	{
		clearSeqAnswers(a.up('form'));
	}
}
function clearSeqAnswers(f) {
	$A($(f).getElementsByClassName('check_or_radio')).each(
		function(item){
			item.value = 0;
			item.checked = false;
			item.previous('.sequence_number').innerHTML = '';					
		});
	sequence_number = 1;		
}
function beforeSeqSubmit(form) {
	$A($(form).getElementsByClassName('check_or_radio')).each(
		function(item){
			item.checked = true;
		});
	return isAnswerSelected(form);
}
function breakTest() {
	new Ajax.Request('/user/break_test',
	  {
    	method:'post',
		  onFailure: function(){ alert('Ошибка при завершении теста') }
	  });	
}
