function checkCorrectAnswers(id) {
	var flag = false;
	var answs = $A($(id).getElementsByClassName('answers'));
	if (answs && answs.size()>0) {
		flag = answs.any(function(a){
			if (a.checked)
				return true ;
		})
	}
	if (flag) return true;
	alert('Необходимо выбрать хотя бы один правильный ответ');
	return false;
}
function mark_for_destroy(elem) {
	elem.next('.should_destroy').value = 1;
	elem.up('.exam_topic').hide();
}
function updateTopicSelector(element) {
	new Ajax.Request('/stat/update_topic_selector',
	  {
    	method:'post',
		parameters: {discipline_id: element.value},
	    onFailure: function(){ alert('Javascript Error') },
		onLoading: function(){ show_loading()},
		onComplete: function() {hide_loading()}
	  });
}
function setImportantFlag(elem) {
	var flag = $(elem).checked ? 1 : 0;
	$(elem).next('.important_flag').value = flag;
}
