$(document).ready(function() {
	$('.datepicker').datepicker();


$(".modalButton").click(function(){
    var id = this.id;
    var modalNou = '#modal' + id;
    $(modalNou).modal('show');
 });
  
});