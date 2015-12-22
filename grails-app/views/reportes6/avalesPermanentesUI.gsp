<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/12/15
  Time: 10:34 AM
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Reporte de Avales Permanentes</title>
</head>

<body>
<fieldset>
    <legend>Reporte de Avales Permanentes</legend>

    <div class="alert alert-primary padding-sm">
        Seleccione el formato de reporte ha ser impreso
    </div>

    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group" role="group">
            %{--<a href="#" class="btn btn-default" id="btnPrint">--}%
                %{--<i class="fa fa-file-pdf-o text-danger"></i> Exportar a PDF--}%
            %{--</a>--}%
            <a href="#" class="btn btn-default" id="btnXls">
                <i class="fa fa-file-excel-o text-success"></i> Exportar a Excel
            </a>
        </div>

    </div>
</fieldset>


<script type="text/javascript">

    %{--$("#btnPrint").click(function () {--}%
        %{--var urlPdf = "${g.createLink(controller: 'reportesNuevos',action: 'reportePdfAvales')}";--}%
        %{--location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + urlPdf--}%
    %{--});--}%

    $("#btnXls").click(function () {

        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'reportes6', action: 'fechasAvales_ajax')}",
            success: function (msg){
                var b = bootbox.dialog({
                  id: "dlgFechas",
                    title: '<h3 class="text-info">Actividad de Destino</h3>',
//                    class: "modal-lg",
                    message: msg,
                    buttons: {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Aceptar",
                            className : "btn-success",
                            callback  : function () {
                                if($("#fechas").valid()){
                                    location.href = "${createLink(controller: 'reportes6', action: 'reportesAvalesPermanentes')}?ini=" + $("#inicio").val() + "&fin=" + $("#fin").val();
                                }else{
                                    return false
                                }
                            }
                        }
                    }
                })
            }
        });
    });


</script>
</body>
</html>