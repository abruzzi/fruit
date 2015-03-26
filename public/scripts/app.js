$(function(){
    $('.submit').click(function() {
        var message = $("#message").val();
        if(!message) {
            alert("请输入要广播的内容");
            return false;
        }

        var region = message.split('@')[1];

        $.ajax({
            type: "POST",
            url: "/broadcast/" + region,
            dataType: "json",
            data: {"message": message},
            success: function(data) {
                $("#message").val("");
            },
            error: function(data) {
                console.log("sent message failed");
            }
        });
    });

});