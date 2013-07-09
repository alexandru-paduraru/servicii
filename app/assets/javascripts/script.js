$(document).ready(function() {
	$('.datepicker').datepicker();

	
	$(".modalButton").click(function(){
	    var id = this.id;
	    var modalNou = '#modal' + id;
	    $(modalNou).modal('show');
	 });
	  
	
	$("#create_employee_button").click(function(){
	    $("#employee_form").slideDown('slow',function(){
			$("#create_employee_button").attr("type","sumbit");
			 	   
	    });
	});
	
	$("#create_employee_button_close").click(function(){
		$("#employee_form").slideUp('slow',function(){
			$("#create_employee_button").attr("type","button");
		});	
	});
	
	if($('.alert-error').html()){
		$("#employee_form").show();
	}
});