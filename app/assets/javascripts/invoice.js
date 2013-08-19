$(function(){
  $(".change_invoice_status").click(function(){
    $.get($(this).attr("href"));
    return false
  });

  $(".set_payment").click(function(){

    $.getJSON("/invoices/" + $(this).data("invoice-id"), function(data){
      $("#invoice-number").text(data["id"]);
      $("#show-invoice-amount").text(data["amount"]);
      $("#show-paid-invoice-amount").text(data["paid_amount"]);
      $("#company-name").text(data["company"]["name"]);

      $("#set-payment-modal").modal();
    });


    return false;
  });

  $(".undo_invoice").click(function(){
    $.post("/invoices/undo", {"id" : $(this).data("id")});

    location.reload();
    return false;
  });
});
