$(function(){
    $('.submit').click(function() {
        $.ajax({
            type: "POST",
            url: "/",
            data: {"message":$("#message").val()},
            success: function(data) {
                $("#message").val("");
            },
            dataType: "json"
        });
    });

});