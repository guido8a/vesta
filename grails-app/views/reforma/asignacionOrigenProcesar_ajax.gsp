

   <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto_name" id="proyecto" class="form-control input-sm required requiredCombo"
                      noSelection="['-1': 'Seleccione...']"/>


<script>

    $("#proyecto").change(function () {
        $("#divComp").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
            data    : {
                id   : $("#proyecto").val(),
//                anio : $("#anio").val()
                anio : ${anio?.id}
            },
            success : function (msg) {
                $("#divComp").html(msg);
                $("#divAct").html("");
                $("#divAsg").html("");
            }
        });
    });

    function getMaximo(asg) {
        if ($("#asignacion").val() != "-1") {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'getMaximoAsg', controller: 'avales')}",
                data    : {
                    id : asg
                },
                success : function (msg) {
                    var valor = parseFloat(msg);
                    var tot = 0;
                    $(".tableReformaNueva").each(function () {
                        var d = $(this).children().children().data("cod")
                        var parId = $(this).children().children().data("par")
                        var valorP = $(this).children().children().data("val")
                    });
                    var ok = valor - tot;
                    $("#max").html("$" + number_format(ok, 2, ".", ","))
                            .attr("valor", ok);
                    $("#monto").attr("tdnMax", ok);
                }
            });
        }
    }

</script>