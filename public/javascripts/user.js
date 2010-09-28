function fillStudentsList(value) {
	new Ajax.Request('/user/list_students',
	  {
    	method:'post',
		parameters: {'id': value },
	  onFailure: function(){ alert('Ошибка при составлении списка группы') },
		onLoading: function(){ show_loading()},
		onComplete: function() {hide_loading()}
		
	  });	
}
function disableSubmit(f) {
	Form.getElements(f).find (function (e) {return e.type == 'submit'}).disable();
	show_loading();
}
