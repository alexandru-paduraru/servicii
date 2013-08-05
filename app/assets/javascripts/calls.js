function hangup() {
  $("#call-status").text("You hang up");
  Twilio.Device.disconnectAll();
}

/* Connect to Twilio when we call this function. */
function call_number(number) {
  if(number !== undefined && number !== null && number != ""){
    params = {"PhoneNumber" : number};
    Twilio.Device.connect(params);
  }
}


$(function(){
  //Twilio.Device.setup("<%#= @token %>", {debug : true});
  if($("#get-token").data("token") != ""){
    Twilio.Device.setup($("#get-token").data("token"), {debug : true});

    /* Let us know when the client is ready. */
    Twilio.Device.ready(function (device) {
      $("#call-status").text("Ready");
    });

    /* Report any errors on the screen */
    Twilio.Device.error(function (error) {
      $("#call-status").text("Error: " + error.message);
    });

    Twilio.Device.connect(function (conn) {
      $("#call-status").text("Connected:");
      $("#call-contact-modal").modal();
    });

    /* Log a message when a call disconnects. */
    Twilio.Device.disconnect(function (conn) {
      $("#call-status").text("Call ended");

      $("#call-contact-modal").modal("hide");
    });

    $("#select-call").click(function(){
      var phone_number = $(".customer-phone").text();
      $("#call-number").text(phone_number);
      $("#call-contact").text($(".organization-name").text());

      call_number(phone_number);

      $(".call-status-bar").show();
    });
    

    $("#hang_up").click(function(){
        hangup();
    });

    // Cilck on the phone from the left side
    $(".show-phone").click(function(){
      var phone_number = $(".customer-phone").text();
      $("#call-number").text(phone_number);
      $("#call-contact").text($(".organization-name").text());

      call_number(phone_number);
      return false;
    });
  }
});
