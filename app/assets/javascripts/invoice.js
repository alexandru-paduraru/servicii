$(function(){
  $(".change_invoice_status").click(function(){
    $.get($(this).attr("href"));
    return false
  });
});
