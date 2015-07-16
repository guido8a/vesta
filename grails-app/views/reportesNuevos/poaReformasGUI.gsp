<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 16/07/15
  Time: 11:34 AM
--%>

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
    <title>Reporte de Reformas</title>
</head>

<body>
<fieldset>
    <legend>Reporte de Reformas</legend>
    <div class="alert alert-primary padding-sm">
        Seleccione el formato de reporte ha ser impreso
    </div>

    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group" role="group">
            <a href="#" class="btn btn-default" id="btnPrint">
                <i class="fa fa-file-pdf-o text-danger"></i> Exportar a PDF
            </a>
            <a href="#" class="btn btn-default" id="btnXls">
                <i class="fa fa-file-excel-o text-success"></i> Exportar a Excel
            </a>
        </div>

    </div>
</fieldset>


<script type="text/javascript">

    $("#btnXls").click(function () {
        var urlExcel = "${createLink(controller: 'reportesNuevos', action: 'reporteReformasExcel')}";
        var urlPdf = null;
        var pdfFileName = "";
        dialogXlsPdfFuente("Reporte de Reformas y Ajustes", urlExcel, urlPdf, pdfFileName);
    });

    $("#btnPrint").click(function () {
        var urlPdf = "${createLink(controller: 'reportes5', action: 'reporteReformasPdf')}";
        var urlExcel = null;
        var pdfFileName = "";
        dialogXlsPdfFuente("Reporte de Reformas y Ajustes", urlExcel, urlPdf, pdfFileName);
    });

    function dialogXlsPdfFuente(title, urlExcel, urlPdf, pdfFileName) {
        var buttons = {};
        if (urlPdf) {
            buttons.pdf = {
                id        : "btnPdf",
                label     : "<i class='fa fa-file-pdf-o'></i> Reporte Pdf",
                className : "btn-success",
                callback  : function () {
                    var fnt = $("#fuente").val();
                    var url = urlPdf + "?fnt=" + fnt;
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=" + pdfFileName;
                } //callback
            };
        }
        if (urlExcel) {
            buttons.excel = {
                id        : "btnExcel",
                label     : "<i class='fa fa-file-excel-o'></i> Reporte Excel",
                className : "btn-success",
                callback  : function () {
                    var fnt = $("#fuente").val();
                    location.href = urlExcel + "?fnt=" + fnt;
                    return false;
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
            url     : "${createLink(controller:'reportesNuevos', action:'form_avales_ajax')}",
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