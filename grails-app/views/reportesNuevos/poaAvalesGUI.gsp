<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 16/07/15
  Time: 11:02 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Reporte de Avales</title>
</head>

<body>
<fieldset>
    <legend>Reporte de Avales</legend>

    <div class="alert alert-primary padding-sm">
        Seleccione el formato de reporte ha ser impreso
    </div>

    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group" role="group">
            <a href="#" class="btn btn-default" id="btnPrint">
                <i class="fa fa-file-pdf-o text-danger"></i> Imprimir
            </a>
            %{--<a href="#" class="btn btn-default" id="btnXls">--}%
                %{--<i class="fa fa-file-excel-o text-success"></i> Exportar a Excel--}%
            %{--</a>--}%
        </div>

    </div>
</fieldset>


<script type="text/javascript">

    %{--$("#btnPrint").click(function () {--}%
        %{--var urlPdf = "${g.createLink(controller: 'reportesNuevos',action: 'reportePdfAvales')}";--}%
        %{--location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + urlPdf--}%
    %{--});--}%

    %{--$("#btnXls").click(function () {--}%
       %{--location.href =   "${createLink(controller: 'reportesNuevos', action: 'reporteAvalesExcel')}";--}%
    %{--});--}%

    $("#btnPrint").click(function () {
        var urlExcel = "${createLink(controller: 'reportesNuevos', action: 'reporteAvalesExcel')}";
        var urlPdf = "${g.createLink(controller: 'reportesNuevos',action: 'reportePdfAvales')}";
        var pdfFileName = "";
        dialogFechas("Reporte de Avales", urlExcel, urlPdf, pdfFileName);
    });


    function dialogFechas(title, urlExcel, urlPdf, pdfFileName) {
        var buttons = {};
        if (urlPdf) {
            buttons.pdf = {
                id        : "btnPdf",
                label     : "<i class='fa fa-file-pdf-o'></i> Reporte Pdf",
                className : "btn-success",
                callback  : function () {
                    var url = urlPdf + "Wini=" + $("#fchaInicio").val() + "Wfin=" + $("#fchaFin").val();
                    if(!$("#fchaInicio").val() || !$("#fchaFin").val()){
                        bootbox.alert("Ingrese las fechas para realizar la búsqueda!");
                        return false;
                    }else{
                        if($("#fchaInicio").val() > $("#fchaFin").val()){
                            bootbox.alert("La fecha de inicio debe ser menor a la fecha de fin!");

                        }else{
                            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "Wfilename=" + pdfFileName;
                        }

                    }
                } //callback
            };
        }
        if (urlExcel) {
            buttons.excel = {
                id        : "btnExcel",
                label     : "<i class='fa fa-file-excel-o'></i> Reporte Excel",
                className : "btn-success",
                callback  : function () {
                    var url = urlExcel + "?ini=" + $("#fchaInicio").val() + "&fin=" + $("#fchaFin").val() + "&fuente=" + $("#fuente").val();
                    location.href = url
                } //callback
            };
        }
        buttons.cancelar = {
            label     : "Cancelar",
            className : "btn-primary",
            callback  : function () {
            }
        };
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'reportesNuevos', action:'fuente_y_fechas_ajax')}",
            data    : '',
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgAvales",
                    title   : title ? title : "Reporte",
                    message : msg,
                    buttons : buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    }




</script>
</body>
</html>