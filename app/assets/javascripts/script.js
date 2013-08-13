$(document).ready(function() {
	var request;
	index = 1
	amount = 0;
	
	
	$('#search_field').keyup(function(){
        val = $('#search_field').val().trim();
        if(val != ''){
            $('.reset-search-button').fadeIn('fast');
            if(val.length >= 0){ 
                requestSearch();               
            }
        } else {
            $('.reset-search-button').fadeOut('fast');
            requestSearch();
        }
    });
    
    $('.tablesorter').tablesorter();
    $('#invoices-table').tablesorter({
        headers:{
            0:{
                sorter: false
            },
            5:{
                sorter:false
            },
            6:{
                sorter: false
            }
        }
    });
    
    function requestSearch(){
        var serializedData = $('#searchForm').serialize();
        var table = $('.tablesorter');
        request = $.ajax({
    	url: '/customers/search',
    	type: 'get',
    	dataType: 'JSON',
    	data: serializedData,
        success: function(data){
           showTable(table);
           clearTable($('#customers-table'));
           $.each(data, function(i, val){
                var count = data.length;
	      		var customer = data[i].customer;
	      		var open_invoices = data[i].open_invoices;
	      		insertRowTableCustomers(i+1, customer.organization_name, customer.first_name, customer.last_name, customer.email, customer.account, open_invoices, customer.id);
	      		if(i==count-1){
    	      	    $(".tablesorter").trigger("update"); 
	      		}
      		});		
  		},
  		error: function(xhr){
      		clearTable($('#customers-table'));
      		//displayNoSearchResult(xhr.responseText);
      		hideTable(table, xhr.responseText);
      		return;
      	}
    });
    }
    

    function insertRowTableCustomers(rowNumber, organization_name, first_name, last_name, email, account, open_invoices, id){
        td_number = '<td>' + rowNumber + '</td>';
		organization = '<td>' + organization_name + ' / ';
		customer_name = first_name + ' ' + last_name + '</td>';
		email = '<td>' + email + '</td>';
		account = '<td>' + account + '</td>';
		open_invoices = '<td>' + open_invoices + '</td>'; 
		icon = '<td><i class="icon-chevron-right"/></td>';
		actions = '<td><a href="/customer_details/' + id +'"><span class="label label-info"><i class="icon-eye-open"></i> Details</span></a> <a href="/delete/'+ id +'"> <span class="label label-important">Archive</span> </a></td>';
		$('#customers-table tbody').append('<tr data-link="/customer_details/' + id + '">' + td_number + organization + customer_name + email + open_invoices + icon + '</tr>');
		$("tr[data-link]").click(function() {
    		window.location = $(this).data("link");
        });
    }
    
    $('#search_field_invoices').keyup(function(){
        val = $(this).val().trim();
        if(val != ''){
            $('.reset-search-button-invoices').fadeIn('fast');
            if(val.length >= 0){ 
                requestSearchInvoices();               
            }
        } else {
            $('.reset-search-button-invoices').fadeOut('fast');
            requestSearchInvoices();
        }
    });
    
    function requestSearchInvoices(){
        var serializedData = $('#searchForm').serialize();
        table = $('#invoices-table');
        request = $.ajax({
    	url: '/invoices/search',
    	type: 'get',
    	dataType: 'JSON',
    	data: serializedData,
        success: function(data){
           showTable(table);
           clearTable(table);
           $.each(data, function(i, val){
	      		count = data.length;
	      		var customer = data[i].customer;
	      		var invoice = data[i].invoice;
	      		insertRowTable(i+1, customer.organization_name, customer.first_name, customer.last_name, invoice.number, invoice.amount, invoice.id, invoice.state);
	      		if(i==count-1){
    	      	    table.trigger("update"); 
	      		}
      		});		
  		},
  		error: function(xhr){
      		clearTable(table);
      		//displayNoSearchResult(xhr.responseText);
      		hideTable(table, xhr.responseText);
      		return;
      	}
    });
    }
    
    function insertRowTable(rowNumber, organization_name, first_name, last_name, number, amount, id, state){
        var state_string = "";
        if(state){
            state_string = state;
        }
        td_number = '<td>' + rowNumber + '</td>';
		organization = '<td>' + organization_name + ' / ';
		customer_name = first_name + ' ' + last_name + '</td>'; 
		number = '<td>' + number + '</td>';
		amount = '<td>$' + amount + ',00</td>';
		status = '<td>'+ state_string  +'</td>';
		icon = '<td><i class="icon-chevron-right"/></td>';
		action = '<td></td>';
		actions = '<td><a href="/customer_details/' + id +'"><span class="label label-info"><i class="icon-eye-open"></i> Details</span></a> <a href="/delete/'+ id +'"> <span class="label label-important">Archive</span> </a></td>';
		$('#invoices-table tbody').append('<tr data-link="/invoice_details/'+ id +'">' + td_number + organization + customer_name + number + amount + status + action + icon + '</tr>');
		$("tr[data-link]").click(function() {
    		window.location = $(this).data("link");
        });
    }
    
    $('#search_field_invoices_collections').keyup(function(){
        val = $(this).val().trim();
        if(val != ''){
            $('.reset-search-button-collections').fadeIn('fast');
            if(val.length >= 0){ 
                requestSearchInvoicesCollections();               
            }
        } else {
            $('.reset-search-button-collections').fadeOut('fast');
            requestSearchInvoicesCollections();
        }
    });
    
    function requestSearchInvoicesCollections(){
        var serializedData = $('#searchForm').serialize();
        request = $.ajax({
    	url: '/collections/invoices/search',
    	type: 'get',
    	dataType: 'JSON',
    	data: serializedData,
        success: function(data){
           clearTable($('#invoices-collections-table'));
           $.each(data, function(i, val){
	      		var customer = data[i].customer;
	      		var invoices = data[i].open_invoices;
	      		insertRowTableCollections(i+1, customer.organization_name, customer.first_name, customer.last_name, invoices, customer.id);
      		});		
  		},
  		error: function(xhr){
      		clearTable($('#invoices-collections-table'));
      		displayNoSearchResult(xhr.responseText);
      		return;
      	}
    });
    }
    
    function insertRowTableCollections(rowNumber, organization_name, first_name, last_name, invoices, id){
        td_number = '<td>' + rowNumber + '</td>';
		organization = '<td>' + organization_name + ' / ';
		customer_name = first_name + ' ' + last_name + '</td>'; 
		customer_id = '<td>' + id + '</td>';
		icon = '<td><i class="icon-chevron-right"/></td>';
		response = '<td>ok</td>';
		invoices_list = '<td><ul class="unstyled">';
		$.each(invoices, function(i, val){
		      invoices_list += '<li> # ' + invoices[i].number + ' issued ' + invoices[i].date + '</li>'; 
		});
		invoices_list += '</ul></td>';
		$('#invoices-collections-table tr:last').after('<tr data-link="/customer_details/'+ id +'">' + td_number + organization + customer_name + customer_id + invoices_list + response +  icon + '</tr>');
		$("tr[data-link]").click(function() {
    		window.location = $(this).data("link");
        });
    }
    
    
    function clearTable(table){
      //  alert('intrat in ' + table.id);
         table.find("tbody tr").remove();
        $(".tablesorter tbody").children().remove();
    }
    
    function displayNoSearchResult(message){
       // message = "No results have been found for your search! :(";
       // $("#customers-table tbody, #invoices-table tbody, #invoices-collections-table tbody").append('<tr><td colspan=5><h4 class="muted" style="text-align:center">' + message + '</h4></td></tr>');
        $(".tablesorter").css('opacity','0');
        $("#info-message").html(message).fadeIn();
    }
    
    function hideTable(table,message){
        table.css('opacity','0');
        $("#info-message").html(message).fadeIn();
    };
    
    function showTable(table){
        table.css('opacity','1');
        $("#info-message").hide();
    };
    
    $('.reset-search-button').click(function(){
        $('#search_field').val('');
        $(this).fadeOut('fast');
        requestSearch();
    });
    
    $('.reset-search-button-invoices').click(function(){
        $('#search_field_invoices').val('');
        $(this).fadeOut('fast');
        requestSearchInvoices(); 
    });
    
    $('.reset-search-button-collections').click(function(){
        $('#search_field_invoices_collections').val('');
        $(this).fadeOut('fast');
        requestSearchInvoicesCollections(); 
    });
    
	$('.datepicker').datepicker();
	
	//rich-text-editor
	$('#some-textarea').wysihtml5();
	
	$(".modalButton").click(function(){
	    var id = this.id;
	    var modalNou = '#modal' + id;
	    $(modalNou).modal('show');
	 });
	 
	 //for centering the modal when its width is increased
	 $('.custom_width_modal').css({'width': '680px','margin-left': function () {return -($(this).width() / 2);}})

	  //for making row in table click-able
	$("tr[data-link]").click(function() {
       window.location = $(this).data("link");
    });
    
    $('tr').hover(function(){
        $('.customer_actions').css('opacity','1');
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
	            		response.removeClass('alert-danger');
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
		total = value * qty;
		service_id = '<input type="hidden" name="service_'+ index +'[id]" value="'+ id +'">';
		td_service = '<td><input readonly="readonly" class="span2" type="text" name="service_'+ index +'[name]" value="'+ name +'"></td>';
		td_value = '<td><input readonly="readonly" class="span2" type="text" name="service_'+ index +'[value]" value="' + value +'"></td>';
		td_qty = '<td><input readonly="readonly" class="span2" type="text" name="service_'+ index +'[qty]" value="' + qty + '"></td>';
		td_actions = '<td></td>';
		td_total = '<td><span class="pull-right">$' + total + ',00</span></td>'
		$('#services_table tr:first').after('<tr>' + service_id + td_number + td_service + td_qty + td_value + td_actions + td_total + '</tr>');
		amount += total;
		$('#invoice_amount').val(amount);
		$('#services_table tr:last td:last').html('<span class="amount_info">Total: </span> <span class="total_due_amount">$' + amount + ',00</span>');
		$('#invoice_number_of_services').val(index);
		index++;
		
	}
	
	$('#invoice_submit').click(function(){
		response = $('#ajax_response');
		var submit_button = $(this).attr("disabled","disabled");
		var draft_button = $("#invoice_save_draft").attr("disabled","disabled");
		submit_button.html("Sending...")
		customer_id = $('#customer_id').val();
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
	            		submit_button.html("Invoice sent");
		            	window.location.href = '/customers/' + customer_id +'/invoices';
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
		      		submit_button.removeAttr("disabled");
		      		draft_button.removeAttr("disabled");
		      		submit_button.html("Submit Invoice")
		      		return;
		      	}
	        });
		
	   });
	
	$("[rel='tooltip']").tooltip();
	$(".edit-btn").hover(function(){
    	  $(this).animate({
        	  width: '44'
    	  },70, function(){
            $(this).html('<i class="icon-edit"></i> Edit');	  
    	  });  
	}, function(){
	    $(this).html('<i class="icon-edit"></i>');
    	$(this).animate({
        	 width: '18'
    	  },70);  
	});
	
	$('#editCustomerButton').click(function(){
	   $('#detailsCustomerForm').fadeOut('fast',function(){
	       $('#editCustomerButton').hide();
    	   $('#editCustomerForm').fadeIn();   
	   });
	   
	});
	$('#closeEditForm').click(function(){
	   $('#editCustomerForm').fadeOut('fast',function(){
    	   $('#editCustomerButton').show();
    	   $('#detailsCustomerForm').fadeIn();   
	   });
	});
	
	$('#submitEditForm').click(function(){
	    var response = $('#errorAjaxDiv');
	    var close_button = '<button type="button" class="close" data-dismiss="alert">&times;</button>';
    	var serializedData = $('#editCustomerForm > form').serialize();
        request = $.ajax({
    	url: '/customer_details/' + $('#customerId').val(),
    	type: 'post',
    	data: serializedData,
        success: function(data){
		      $('#main-span').prepend('<div class="alert alert-success">' + close_button + data + '</div>');
		       $('#editCustomerForm').fadeOut('fast',function(){
    		       $('#editCustomerButton').show();
    		   $('#detailsCustomerForm').fadeIn();   
    		   });
    		   response.html('');
    		   response.hide();
  		},
  		error: function(xhr){
  		    var errors = $.parseJSON(xhr.responseText)
      		response.html('');
      		response.show();
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