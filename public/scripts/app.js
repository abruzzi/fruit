$(function(){
    $('.submit').click(function() {
        $.ajax({
            type: "POST",
            url: "/",
            data: $("#message").val(),
            success: function(data) {
                alert(data);
            },
            dataType: "text"
        });
    });

});