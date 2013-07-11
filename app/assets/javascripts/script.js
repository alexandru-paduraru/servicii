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
			window.location.href = window.location.pathname;
		});	
	});
	
	if($('.alert-error').html()){
		$("#employee_form").show();
	}
	index = 2
	$('#add_service_button').click(function(){
		index++;
		td_service = '<td><input type="text" placeholder="Service name" name="invoice[service_'+ index +'][service_name]"></td>';
		td_value = '<td><input type="text" placeholder="Value" name="invoice[service_'+ index +'][service_value]"></td>';
		td_qty = '<td><input type="text" placeholder="Qty" name="invoice[service_'+ index +'][service_qty]"></td>';
		td_total = '<td></td>'
		$('#services_table tr:last').before('<tr>' + td_service + td_value + td_qty + td_total + '</tr>');
	});
	
	$('#send_invoice').click(function(){
	var signup_data = $('#new_invoice').serialize();
	customer_id = $('#invoice_customer_id').val();
	response = $('#ajax_response');
	if( 1 == 2){
		response.addClass('alert alert-danger');
		response.html('Parola specificata este diferita de cea din confirmare!');
		return;
	}
	$.post('/customers/' + customer_id + '/invoices',signup_data, function(data){
		response.addClass('alert alert-success');
		response.html('raspuns din server ' + data);
	});
});
});