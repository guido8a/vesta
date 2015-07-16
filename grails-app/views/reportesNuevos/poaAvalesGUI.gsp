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
                <i class="fa fa-file-pdf-o text-danger"></i> Exportar a PDF
            </a>
            <a href="#" class="btn btn-default" id="btnXls">
                <i class="fa fa-file-excel-o text-success"></i> Exportar a Excel
            </a>
        </div>

    </div>
</fieldset>


<script type="text/javascript">

    $("#btnPrint").click(function () {
        var urlPdf = "${g.createLink(controller: 'reportesNuevos',action: 'reportePdfAvales')}";
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + urlPdf
    });

    $("#btnXls").click(function () {
       location.href =   "${createLink(controller: 'reportesNuevos', action: 'reporteAvalesExcel')}";
    });


</script>
</body>
</html>