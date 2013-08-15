$(function(){
  $(".change_invoice_status").click(function(){
    $.get($(this).attr("href"));
    return false
  });

  $(".set_payment").click(function(){
    $("#set-payment-modal").modal();

    return false;
  });
});
