$(function(){

    var compiled = _.template($("#dropdown").html());
    
    $("#message").on("input", function(e) {
        var text = $(this).val();
        if(text.endsWith("@")) {
            var offset = $(this).offset();
            var top = offset.top + 40;
            var left = offset.left + ($(this).caret() * 10) + 1;
            $.get('/regions').done(function(data){
                $("#regions").html(compiled({"regions": data})).css({
                    top: top,
                    left: left
                }).show();
            }).error(function(error){
                console.log("fetch regions failed");
            });
        }
    });

    $("#regions").on('click', ".item", function(e) {
        var region = $(this).text().trim();
        if(region) {
            var text = $("#message").val();
            $("#message").val(text + region + " ").focus();

        }
        
        $("#regions").hide();
    });

    $('.submit').click(function() {
        var message = $("#message").val();
        if(!message) {
            alert("请输入要广播的内容，比如：杨栋，前台有你的快递！");
            return false;
        }

        $.ajax({
            type: "POST",
            url: "/broadcast",
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