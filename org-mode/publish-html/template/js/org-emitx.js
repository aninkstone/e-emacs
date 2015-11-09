//do stuff when page loaded
$(document).ready (function () {
    $("div", $(".todo").parent().parent ()).hide ();
    $("div", $(".done").parent().parent ()).hide ();

    $(".todo").click (function () {
        if ($("div", $(this).parent().parent()).is(":visible")) {
            $("div", $(this).parent().parent()).hide ();
        }
        else {
            $("div", $(this).parent().parent()).show ();
        }
    });
    $(".done").click (function () {
        if ($("div", $(this).parent().parent()).is(":visible")) {
            $("div", $(this).parent().parent()).hide ();
        }
        else {
            $("div", $(this).parent().parent()).show ();
        }
    });
})
