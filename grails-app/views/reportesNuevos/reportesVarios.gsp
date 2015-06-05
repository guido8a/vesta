<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/06/15
  Time: 10:55 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Reportes Varios</title>
    </head>

    <body>

        <div class="row">
            <div class="col-md-8">

                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Reportes</h3>
                    </div>
                </div>

                <div class="panel-body">
                    <ul class="fa-ul">
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="proformaEgresos">
                                Proforma de egresos no permanentes
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="egresos">
                                Proforma de egresos no permanentes - Grupo de gastos
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="recursos">
                                Proforma presupuestaria de recursos no permanentes
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="avales">
                                Reporte Avales
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="reformas">
                                Reporte de reformas y ajustes
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>

                            <a href="#" id="poaGrupoGasto">
                                POA: resumen por grupo de gasto
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="poaUnidadEjecutora">
                                POA: resumen por unidad ejecutora
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="poaProyecto">
                                POA: resumen por proyecto
                            </a>
                        </li>
                        <li>
                            <i class="fa-li fa fa-print text-info"></i>
                            <a href="#" id="poaFuente">
                                POA: resumen por fuente de financiamiento
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <script type="text/javascript">

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

            function dialogXlsPdf(title, message, urlExcel, urlPdf, pdfFileName) {
                bootbox.dialog({
                    id      : "dlgEgresos1",
                    title   : title ? title : "Reporte",
                    message : message ? message : "Reporte",
                    buttons : {
                        pdf      : {
                            id        : "btnPdf",
                            label     : "<i class='fa fa-file-pdf-o'></i> Reporte Pdf",
                            className : "btn-success",
                            callback  : function () {
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + urlPdf + "&filename=" + pdfFileName;
                            } //callback
                        }, //guardar
                        excel    : {
                            id        : "btnExcel",
                            label     : "<i class='fa fa-file-excel-o'></i> Reporte Excel",
                            className : "btn-success",
                            callback  : function () {
                                location.href = urlExcel;
//                            return false;
                            } //callback
                        }, //guardar
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }

            $(function () {
                $("#egresos").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevos', action: 'reporteEgresosGastosExcel')}";
                    var urlPdf = "${createLink(controller: 'reportesNuevos', action: 'reporteEgresosGastosPdf')}";
                    var pdfFileName = "filename=egresos_gastos.pdf";
                    dialogXlsPdf("Reporte de egresos", "Reporte de Egresos permanentes - grupo de gastos", urlExcel, urlPdf, pdfFileName);
                });

                $("#avales").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevos', action: 'reporteAvalesExcel')}";
                    var urlPdf = "${g.createLink(controller: 'reportesNuevos',action: 'reportePdfAvales')}";
                    var pdfFileName = "avales.pdf";
                    dialogXlsPdfFuente("Reporte de Avales", urlExcel, urlPdf, pdfFileName);
                });

                $("#reformas").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevos', action: 'reporteReformasExcel')}";
                    var urlPdf = "";
                    var pdfFileName = "";
                    dialogXlsPdfFuente("Reporte de Avales", urlExcel, urlPdf, pdfFileName);
                });

                $("#poaGrupoGasto").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevosExcel', action: 'poaGrupoGastoXls')}";
                    var urlPdf = "${createLink(controller: 'reportesNuevos', action: 'poaGrupoGastoPdf')}";
                    var pdfFileName = "POA_grupo_gasto.pdf";
                    dialogXlsPdfFuente("Reporte POA por grupo de gasto", urlExcel, urlPdf, pdfFileName);
                });

                $("#poaUnidadEjecutora").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevosExcel', action: 'poaAreaGestionXls')}";
                    var urlPdf = "${createLink(controller: 'reportesNuevos', action: 'poaAreaGestionPdf')}";
                    var pdfFileName = "POA_unidad_ejecutora.pdf";
                    dialogXlsPdf("Reporte POA por unidad ejecutora", "Reporte POA por unidad ejecutora", urlExcel, urlPdf, pdfFileName);
                });

                $("#poaProyecto").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevosExcel', action: 'poaProyectoXls')}";
                    var urlPdf = "${createLink(controller: 'reportesNuevos', action: 'poaProyectoPdf')}";
                    var pdfFileName = "POA_proyecto.pdf";
                    dialogXlsPdf("Reporte POA por proyecto", "Reporte POA por proyecto", urlExcel, urlPdf, pdfFileName);
                });

                $("#poaFuente").click(function () {
                    var urlExcel = "${createLink(controller: 'reportesNuevosExcel', action: 'poaFuenteXls')}";
                    var urlPdf = "${createLink(controller: 'reportesNuevos', action: 'poaFuentePdf')}";
                    var pdfFileName = "POA_fuente.pdf";
                    dialogXlsPdf("Reporte POA por fuente de financiamiento", "Reporte POA por fuente de financiamiento", urlExcel, urlPdf, pdfFileName);
                });

                $("#recursos").click(function () {
                    var urlExcel = "${createLink(controller: 'reportes5', action: 'reporteRecursosExcel')}";
                    var urlPdf = "${createLink(controller: 'reportes5', action: 'reporteRecursosPdf')}";
                    var pdfFileName = "POA_fuente.pdf";
                    dialogXlsPdf("Proforma presupuestaria de recursos no permanentes", "Proforma presupuestaria de recursos no permanentes", urlExcel, urlPdf, pdfFileName);
                });

                $("#proformaEgresos").click(function () {
                    var urlExcel = "${createLink(controller: 'reportes4', action: 'proformaEgresosNoPermanentesXlsx')}";
                    var urlPdf = null;
                    var pdfFileName = null;
                    dialogXlsPdfFuente("Reporte POA por grupo de gasto", urlExcel, urlPdf, pdfFileName);
                });

            });
        </script>

    </body>
</html>