<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 11:39 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Procesos de avales Gasto Permanente</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="fila">
            <g:if test="${params.aval != 'no'}">
                <g:link action="nuevaSolicitud" class="btn btn-default">
                    <i class="fa fa-file-o"></i> Nuevo proceso para solicitud de aval
                </g:link>
            </g:if>
        </div>




    <table class="table table-bordered table-hover table-striped table-condensed" style="margin-top: 25px;">
        <thead>
        <tr>
            <th style="width: 270px">Solicita</th>
            <th style="width: 220px">Nombre del proceso</th>
            <th style="width: 210px">Justificación</th>
            <th style="width: 110px">Estado</th>
            <th style="width: 85px">Fecha</th>
            <th style="width: 85px">Inicio</th>
            <th style="width: 85px">Fin</th>
            <th style="width: 85px">Monto</th>
        </tr>
        </thead>
    </table>

    <div class="row-fluid"  style="width: 99.7%;height: 600px;overflow-y: auto;float: right;">
        <div class="span12">
    <div style="width: 1120px; height: 600px;">
        <table class="table table-bordered table-hover table-striped table-condensed">
            %{--<thead>--}%
                %{--<tr>--}%
                    %{--<th>Solicita</th>--}%
                    %{--<th>Nombre del proceso</th>--}%
                    %{--<th>Justificación</th>--}%
                    %{--<th>Estado</th>--}%
                    %{--<th style="width: 85px">Fecha</th>--}%
                    %{--<th style="width: 85px">Inicio</th>--}%
                    %{--<th style="width: 85px">Fin</th>--}%
                    %{--<th>Monto</th>--}%
                %{--</tr>--}%
            %{--</thead>--}%
            <tbody>
                <g:if test="${procesos.size() > 0}">
                    <g:each in="${procesos}" var="proc">
                        <tr data-id="${proc.id}" data-estado="${proc.estado.codigo}">
                            <td>${proc.usuario.unidad} - ${proc.usuario}</td>
                            <td>${proc.nombreProceso}</td>
                            <td>${proc.concepto}</td>
                            <td class="${proc.estado.codigo}">${proc.estado.descripcion}</td>
                            <td>${proc.fechaSolicitud.format("dd-MM-yyyy")}</td>
                            <td>${proc.fechaInicioProceso.format("dd-MM-yyyy")}</td>
                            <td>${proc.fechaFinProceso.format("dd-MM-yyyy")}</td>
                            <td class="text-right"><g:formatNumber number="${proc.monto}" type="currency" currencySymbol=""/></td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr class="info text-info text-center text-shadow">
                        <td colspan="7">
                            <i class="fa icon-ghost"></i> No se encontraron resultados
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>
     </div>
      </div>
        </div>

        <script type="text/javascript">
            function createContextMenu(node) {
                var $tr = $(node);

                var id = $tr.data("id");
                var estado = $tr.data("estado");
                var estaAprobado = estado == "E02";

                var items = {
                    header    : {
                        label  : "Acciones",
                        header : true
                    },
/*
                    fecha :{
                        label  : "Cambio de fechas",
                        icon   : "fa fa-clock-o",
                        action : function ($element) {
                            var id = $element.data("id");
                            cambiarFecha(id);
                        }
                    },
*/

                    solicitud : {
                        label  : "Solicitud",
                        icon   : "fa fa-print",
                        action : function ($element) {
                            var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudAvalCorriente')}/" + id;
                            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_aval_corriente.pdf";
                        }
                    }

                };

                <g:if test="${session.perfil.codigo in ["GAF", "DA", "DF", "ASAF"]}">
                items.fecha = {
                    label  : "Cambio de fechas",
                            icon   : "fa fa-clock-o",
                            action : function ($element) {
                        var id = $element.data("id");
                        cambiarFecha(id);
                    }
                };
                </g:if>


    if (estaAprobado) {
        items.aval = {
            label  : "Aval",
            icon   : "fa fa-print",
            action : function ($element) {
                var url = "${g.createLink(controller: 'reporteSolicitud',action: 'avalCorriente')}/" + id;
                            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval_corriente.pdf";
                        }
                    };
                }

                if(estado == 'E02' && ${perfil == 'ASAF'}){
                    items.liberar = {
                        label  : "Liberar",
                        icon   : "fa fa-unlink",
                        action : function ($element) {
                            var id = $element.data("id");
                            liberarAvalPermanente(id, 'no')
                            return false
                        }
                    };
                }


                if(estado == 'E05'){
                    items.aval = {
                        label  : "Aval",
                        icon   : "fa fa-print",
                        action : function ($element) {
                            var url = "${g.createLink(controller: 'reporteSolicitud',action: 'avalCorriente')}/" + id;
                            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval_corriente.pdf";
                        }
                    };

                    items.verLiberado = {
                        label  : "Ver Liberado",
                        icon   : "fa fa-print",
                        action : function ($element) {
                            var id = $element.data("id");
                            liberarAvalPermanente(id, 'si')
                            return false
                        }
                    };
                }
                return items;
            }
            $(function () {
                $("tbody>tr").contextMenu({
                    items  : createContextMenu,
                    onShow : function ($element) {
                        $element.addClass("success");
                    },
                    onHide : function ($element) {
                        $(".success").removeClass("success");
                    }
                });
            });

            function liberarAvalPermanente(id, estado) {
                var data = id ? {id : id} : {};
                if(estado == 'no'){
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'liberarAvalCorriente')}",
                        data    : {
                                    id: id,
                                    edi: estado
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgLiberarCorriente",
                                title   : "Liberar Aval Permanente",
                                class   : "modal-lg",
                                message : msg,
                                buttons : {

                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },

                                    guardar  : {
                                        id        : "btnSave",
                                        label     : "<i class='fa fa-save'></i> Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                            return submitForm();
                                            closeLoader();

                                        } //callback
                                    } //guardar
                                } //buttons
                            }); //dialog
                            setTimeout(function () {
                                b.find(".form-control").first().focus()
                            }, 500);
                        } //success
                    }); //ajax
                }else{
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'liberarAvalCorriente')}",
                        data    : {
                                    id: id,
                                    edi: estado
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgLiberarCorriente",
                                title   : "Liberar Aval Permanente",
                                class   : "modal-lg",
                                message : msg,
                                buttons : {

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
                }
            } //crea

            function submitForm() {
                var $form = $("#frmLiberar");
                var $btn = $("#dlgLiberar").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Liberando Aval");
                    var formData = new FormData($form[0]);
                    $.ajax({
                        type        : "POST",
                        url         : $form.attr("action"),
                        data        : formData,
                        async       : false,
                        cache       : false,
                        contentType : false,
                        processData : false,
                        success     : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.reload(true);
                                    closeLoader();
                                } else {
                                    closeLoader();
                                    spinner.replaceWith($btn);
                                    return false;

                                }
                            }, 1000);
                        }
                    });
                } else {
                    $('.modal-contenido').animate({
                        scrollTop : $($(".has-error")[0]).offset().top - 100
                    }, 1000);
                    return false;
                } //else
            }

            function submitFechas () {
                var $form = $("#frmFechas");
                var $btn = $("#dlgCambioFechas").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Cambiando fechas");
                    var formData = new FormData($form[0]);
                    $.ajax({
                        type        : "POST",
                        url         : $form.attr("action"),
                        data        : formData,
                        async       : false,
                        cache       : false,
                        contentType : false,
                        processData : false,
                        success     : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.reload(true);
                                    closeLoader();
                                } else {
                                    closeLoader();
                                    spinner.replaceWith($btn);
                                    return false;

                                }
                            }, 1000);
                        }
                    });
                } else {
                    $('.modal-contenido').animate({
                        scrollTop : $($(".has-error")[0]).offset().top - 100
                    }, 1000);
                    return false;
                } //else
            }


            function cambiarFecha(id) {

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'cambiarFechas')}",
                        data    : {
                            id: id
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgCambioFechas",
                                title   : "Cambiar Fechas",
//                                class   : "modal-sm",
                                message : msg,
                                buttons : {

                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },
                                    guardar  : {
                                        id        : "btnSave",
                                        label     : "<i class='fa fa-save'></i> Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                                submitFechas();
                                            closeLoader();
                                        } //callback
                                    } //guardar
                                } //buttons
                            }); //dialog
                            setTimeout(function () {
                                b.find(".form-control").first().focus()
                            }, 500);
                        } //success
                    }); //ajax
            } //crea


        </script>

    </body>
</html>