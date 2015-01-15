<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/08/14
  Time: 01:25 PM
--%>

<%@ page import="vesta.contratacion.DetalleMontoSolicitud; vesta.seguridad.Prfl; vesta.proyectos.Proyecto" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Ver detalles de la solicitud</title>
</head>

<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="dialog">


        <div class="btn-toolbar toolbar">
           <div class="btn-group">

        <g:link class="btn btn-default button list" action="list">
            <i class="fa fa-list"></i> Lista de solicitudes
        </g:link>
<g:if test="${session.perfil.codigo == 'RQ'}">
        <g:link class="btn btn-default button btnCrear" action="ingreso">
            <i class="fa fa-file-o"></i> Nueva solicitud
        </g:link>
</g:if>
        <a href="#" id="btnPrint" class="btn btn-default button" style="float: right;">
            <i class="fa fa-print"></i> Imprimir</a>
        </div>
                <g:if test="${solicitud.estado == 'P'}">
                    <g:if test="${session.perfil.codigo == 'RQ' || session.perfil.codigo == 'DRRQ'}">
                        <g:link class="button btn btn-info edit btnCrearSol" action="ingreso" id="${solicitud?.id}">
                            <i class="fa fa-pencil"></i> Editar
                        </g:link>
                    </g:if>
                </g:if>
        </div>



    <div class="body">
        <g:if test="${flash.message}">
            <div class="message ui-state-highlight ui-corner-all">${flash.message}</div>
        </g:if>
          <table class="table table-condensed table-bordered table-striped">
            <thead>
            <tr class="info">
                <td style="font-weight: bold; text-align: center">
                    Detalles de la Solicitud
                </td>
            </tr>
            </thead>
            <tbody>
            <g:if test="${solicitud}">
                <tr>
                    <td colspan="4" style="font-size: larger; font-weight: bold;">
                        <g:if test="${vesta.contratacion.DetalleMontoSolicitud.countBySolicitud(solicitud) == 0}">
                            <div class="alert alert-danger" style="padding: 10px 10px 10px 10px; ">
                                No ha detallado los montos anuales de la solicitud
                            </div>
                        </g:if>
                        <g:else>
                            <g:if test="${solicitud.incluirReunion == 'S'}">
                                <div style="padding: 10px 10px 5px 10px; " class="alert alert-success">
                                    Se incluirá en la próxima reunión de aprobación
                                </div>
                            </g:if>
                            <g:else>
                                <div style="padding: 10px 10px 5px 10px; " class="alert alert-danger">
                                    No se incluirá en la próxima reunión de aprobación
                                </div>
                            </g:else>
                        </g:else>
                    </td>
                </tr>
                <tr class="info">
                    <td>
                        <slc:showSolicitud solicitud="${solicitud}" perfil="${session.perfil}"/>
                    </td>
                </tr>
            </g:if>
            </tbody>
            %{--<tfoot>--}%
            %{--<tr>--}%
                %{--<td colspan="4" class="buttons" style="text-align: right;">--}%
                    %{--<g:if test="${solicitud.estado == 'P'}">--}%
                        %{--<g:if test="${session.perfil.codigo == 'RQ' || session.perfil.codigo == 'DRRQ'}">--}%
                            %{--<g:link class="button btn btn-info edit btnCrear" action="ingreso" id="${solicitud?.id}">--}%
                                %{--Actualizar--}%
                            %{--</g:link>--}%
                        %{--</g:if>--}%
                    %{--</g:if>--}%
                %{--</td>--}%
            %{--</tr>--}%
            %{--</tfoot>--}%
        </table>
    </div> <!-- body -->
</div> <!-- dialog -->

<script type="text/javascript">
    $(function () {
        $("#btnPrint").button("option", "icons", {primary : 'ui-icon-print'}).click(function () {
            var url = "${createLink(controller: 'reporteSolicitud', action: 'imprimirSolicitud')}/?id=${solicitud.id}";
//                    console.log(url);
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf";
            return false;
        });

        $(".button").button();
        $(".home").button("option", "icons", {primary : 'ui-icon-home'});
        $(".list").button("option", "icons", {primary : 'ui-icon-clipboard'});
        $(".create").button("option", "icons", {primary : 'ui-icon-document'});

        $(".edit").button("option", "icons", {primary : 'ui-icon-pencil'});
        $(".revision").button("option", "icons", {primary : 'ui-icon-check'});
    });

    var id = null;
    function submitForm() {
        var $form = $("#frmSolicitud");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Solicitud");
            var formData = new FormData($form[0]);
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data        : formData,
                async       : false,
                cache       : false,
                contentType : false,
                processData : false,
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            location.reload(true);
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
                }
            });
        } else {
            //error
//            console.log("e", $('.modal-contenido'),$(".has-error")[0]/*,$(".has-error")[0].offset().top*/);
//            $('.modal-contenido').scrollTop($($(".has-error")[0]).offset().top);
            $('.modal-contenido').animate({
                scrollTop: $($(".has-error")[0]).offset().top-100
            }, 1000);
            return false;
        } //else
    }

    $(".btnCrearSol").click(function() {
        createEditRow(${solicitud?.id});
        return false;
    });

    $(".btnCrear").click(function() {
        createEditRow();
        return false;
    });

    function createEditRow(id) {
        console.log("id " + id)
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            %{--url     : "${createLink(action:'form_ajax')}",--}%
            url     : "${createLink(action:'ingreso')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Solicitud",

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
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createE

</script>
</body>
</html>