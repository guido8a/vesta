<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Aprobar gastos e inversiones</title>
    </head>

    <body>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
        <elm:container tipo="horizontal" titulo="Aprobar P.O.A" color="black">
            <div class="row">
                <div class="col-md-2">
                    <label for="anios">
                        Seleccione un año:
                    </label>
                </div>

                <div class="col-md-2">
                    <g:select from="${anios}" name="anios" optionKey="id" optionValue="anio" noSelection="[0: 'Seleccione']" id="anio" class="form-control input-sm"/>
                </div>

                <div class="col-md-2">
                    <g:link controller="reportes6" action="aprobarProyectoXlsx" class="btn btn-sm btn-default btnExcel">
                        <i class="fa fa-file-excel-o text-success"></i> Exportar a Excel
                    </g:link>
                </div>
            </div>

        </elm:container>
        <elm:container tipo="vertical" titulo="Detalle" style="min-height: 250px">
            <div id="detalle" class="ui-corner-all">

            </div>
        </elm:container>

        <script type="text/javascript">
            $(function () {
                var $anio = $("#anio");
                var $btnExcel = $(".btnExcel");
                if ($anio.val() == "0") {
                    $btnExcel.addClass("disabled");
                }

                $btnExcel.click(function () {
                    var url = $(this).attr("href");
                    var anio = $anio.val();
                    if (parseInt(anio) > 0) {
                        url += "/" + anio;
                    }
                    location.href = url;
                    return false;
                });

                $anio.change(function () {
                    if ($(this).val() != "0") {
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller:'anio', action:'detalleAnio')}",
                            data    : "anio=" + $(this).val(),
                            success : function (msg) {
                                $("#detalle").html(msg);
                                $("#detalle").show("slide")
                            }
                        });
                        $btnExcel.removeClass("disabled");
                    } else {
                        $btnExcel.addClass("disabled");
                    }
                });
            });

        </script>
    </body>
</html>