$(function(){
  $(".revert_action").click(function(){
    var id = this.id;
    var modalNou = '#revert-action-modal-' + id;
    $(modalNou).modal('show');
  });
});
