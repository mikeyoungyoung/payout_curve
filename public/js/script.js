$(document).ready(function(){
            $("#btn3").click(function(){
                        $("#test3").val( // "Dolly Duck"
                                        function(){
                                        $("#curves option:selected").text();
                                        });
                             });
            $("select").change(function () {
                                     var str = "";
                                     $("select option:selected").each(function () {
                                                                      str += $(this).text() + " ";
                                                                      });
                                     $("#test3").text(str);
                                     })
                  .trigger('change');
});