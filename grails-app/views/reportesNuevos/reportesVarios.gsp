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
                </ul>
            </div>
        </div>
    </div>



<script type="text/javascript">
    $(function () {
        $("#avales").click(function () {
//            console.log("entrof")
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'reportesNuevos', action:'form_avales_ajax')}",
                data    : '',
                success : function (msg) {

                    var b = bootbox.dialog({
                        id      : "dlgAvales",
                        title   : "Reporte de Avales",
                        message : msg,
                        buttons : {
                        pdf  : {
                            id        : "btnPdf",
                            label     : "<i class='fa fa-file-pdf-o'></i> Reporte Pdf",
                            className : "btn-success",
                            callback  : function () {
                                var fnt = $("#fuente").val();

                            } //callback
                        }, //guardar
                        excel  : {
                            id        : "btnExcel",
                            label     : "<i class='fa fa-file-excel-o'></i> Reporte Excel",
                            className : "btn-success",
                            callback  : function () {
                                var fnt = $("#fuente").val();
                                location.href = "${createLink(controller: 'reportesNuevos', action: 'reporteAvalesExcel')}?fnt=" + fnt;
                                return false;
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
                    setTimeout(function () {
                        b.find(".form-control").first().focus()
                    }, 500);
                } //success
            }); //ajax
        });

        $("reformas").click(function () {

        });

    });
</script>

</body>
</html>