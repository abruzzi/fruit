$(function(){
    $('.submit').click(function() {
        $.ajax({
            type: "POST",
            url: "/",
            data: {"message":$("#message").val(),
                    "isEleven": $("#eleven").is(":checked"),
                    "isFifteen": $("#fifteen").is(":checked")},
            success: function(data) {
                $("#message").val("");
            },
            dataType: "json"
        });
    });

});