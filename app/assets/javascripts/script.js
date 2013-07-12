$(document).ready(function() {
	var request;
	index = 1
	
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
		if($("#employee_form")){
			$("#employee_form").show();
		}
	}
	
	$('#bla').click(function(){
		index++;
		td_service = '<td><input type="text" placeholder="Service name" name="invoice[service_'+ index +'][service_name]"></td>';
		td_value = '<td><input type="text" placeholder="Value" name="invoice[service_'+ index +'][service_value]"></td>';
		td_qty = '<td><input type="text" placeholder="Qty" name="invoice[service_'+ index +'][service_qty]"></td>';
		td_total = '<td></td>'
		$('#services_table tr:last').before('<tr>' + td_service + td_value + td_qty + td_total + '</tr>');
	});
	
	
	$('#add_service_button').click(function(){
		response = $('#ajax_response');
		customer_id = $('#invoice_customer_id').val();
		if (request){
			request.abort();
		}
		var serializedData = $('#new_invoice').serialize();
		qty = $('#service_qty').val();

		if($.isNumeric(qty) && parseInt(qty) > 0){
			request = $.ajax({
	        	url: '/customers/' + customer_id + '/invoices/new/services/new',
	        	type: "post",
	        	data: serializedData,
	            success: function(data){
	            		response.html('');
	            		response.addClass('alert alert-success');
	            		response.append('Service added successfully!');
		            	addNewServiceRow(data.id,data.name,data.value,qty);
		            	$('#service_qty').val('0');
		            	$('#service_name').val('');
		            	$('#service_value').val('');
	      		},
	      		error: function(xhr){
		      		var errors = $.parseJSON(xhr.responseText).errors
		      		response.addClass('alert alert-danger');
		      		response.html('');
		      		response.append('<h4>Service errors:</h4>');
		      		response.append('<ul>');
		      		$.each(errors, function(i, val){
			      		response.append('<li>' + errors[i] + '</li>');
		      		});
		      		response.append('</ul>');
		      		return;
		      	}
	        });
		} else {
			response.html('');
			response.addClass('alert alert-danger');
			response.append('<h4>Service errors: </h4>');
			response.append('Qty field can\'t be blank and must be > 0');
		}
	});
	
	function addNewServiceRow(id,name,value,qty){
		td_number = '<td>' + index + '</td>';
		service_id = '<input type="hidden" name="service_'+ index +'[id]" value="'+ id +'">';
		td_service = '<td><input class="span2" type="text" name="service_'+ index +'[name]" value="'+ name +'"></td>';
		td_value = '<td><input class="span2" type="text" name="service_'+ index +'[value]" value="' + value +'"></td>';
		td_qty = '<td><input class="span2" type="text" name="service_'+ index +'[qty]" value="' + qty + '"></td>';
		td_actions = '<td></td>';
		td_total = '<td>$ ' + (value * qty) + ',00</td>'
		$('#services_table tr:first').after('<tr>' + service_id + td_number + td_service + td_value + td_qty + td_actions + td_total + '</tr>');
		$('#services_table tr:last td:last').html('1000');
		$('#invoice_number_of_services').val(index);
		index++;
		
	}
	
	$('#invoice_submit').click(function(){
		response = $('#ajax_response');
		customer_id = $('#invoice_customer_id').val();
		if (request){
			request.abort();
		}
		var serializedData = $('#new_invoice').serialize();

			request = $.ajax({
	        	url: '/customers/' + customer_id + '/invoices',
	        	type: "post",
	        	data: serializedData,
	            success: function(data){
	            		response.html('');
	            		response.addClass('alert alert-success');
	            		response.append(data);
		            	
	      		},
	      		error: function(xhr){
		      		var errors = $.parseJSON(xhr.responseText).errors
		      		response.addClass('alert alert-danger');
		      		response.html('');
		      		response.append('<h4>Service errors:</h4>');
		      		response.append('<ul>');
		      		$.each(errors, function(i, val){
			      		response.append('<li>' + errors[i] + '</li>');
		      		});
		      		response.append('</ul>');
		      		return;
		      	}
	        });
		
	});
	
});