<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/01/15
  Time: 11:24 AM
--%>

<%@ page import="vesta.contratacion.Solicitud" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName"
           value="${message(code: 'solicitud.label', default: 'Año')}"/>
    <title>Lista de Solicitudes para aprobación</title>
</head>
<body>


<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:if test="${session.perfil.codigo == 'RQ'}">
            <a href="#" class="btn btn-default btnCrear">
                <i class="fa fa-file-o"></i> Nueva Solicitud
            </a>
        </g:if>
    </div> <!-- toolbar -->
</div>

        <table class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                <tr>
                    <g:sortableColumn property="unidadEjecutora" title="Área de gestión" />
                    <g:sortableColumn property="actividad" title="Actividad" />
                    <g:sortableColumn property="fecha" title="Fecha" />
                    <g:sortableColumn property="montoSolicitado" title="Monto Solicitado" />
                    <g:sortableColumn property="tipoContrato" title="Modalidad de Contratación" />
                    <g:sortableColumn property="nombreProceso" title="Nombre del Proceso" />
                    <g:sortableColumn property="plazoEjecución" title="Plazo de Ejecución" />
                  </tr>
                </thead>
                <tbody>
                <g:if test="${solicitudInstanceCount > 0}">
                <g:each in="${solicitudInstanceList}" status="i" var="solicitudInstance">
                    <tr data-id="${solicitudInstance.id}">
                        <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="unidadEjecutora.nombre"/></elm:textoBusqueda></td>
                        <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="actividad.objeto"/></elm:textoBusqueda></td>
                        <td><g:formatDate date="${solicitudInstance.fecha}" format="dd-MM-yyyy" /></td>
                        <td style="text-align: right"><g:formatNumber number="${solicitudInstance.montoSolicitado}" type="currency" currencySymbol=""/></td>
                        <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="tipoContrato.descripcion"/></elm:textoBusqueda></td>
                        <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="nombreProceso"/></elm:textoBusqueda></td>
                        <td><g:formatNumber number="${solicitudInstance.plazoEjecucion}" maxFractionDigits="0"/> días</td>
                    </tr>
                </g:each>
                </g:if>
                <g:else>
                    <tr class="danger">
                        <td class="text-center" colspan="39">
                            <g:if test="${params.search && params.search!= ''}">
                                No se encontraron resultados para su búsqueda
                            </g:if>
                            <g:else>
                                No se encontraron registros que mostrar
                            </g:else>
                        </td>
                    </tr>
                </g:else>
                </tbody>
            </table>

<elm:pagination total="${solicitudInstanceCount}" params="${params}"/>

<script type="text/javascript">
    %{--$(function () {--}%
        %{--$(".button").button();--}%
        %{--$(".home").button("option", "icons", {primary : 'ui-icon-home'});--}%
        %{--$(".create").button("option", "icons", {primary : 'ui-icon-document'});--}%

        %{--$(".edit").button("option", "icons", {primary : 'ui-icon-pencil'});--}%
        %{--$(".delete").button("option", "icons", {primary : 'ui-icon-trash'}).click(function () {--}%
            %{--if (confirm("${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}")) {--}%
                %{--return true;--}%
            %{--}--}%
            %{--return false;--}%
        %{--});--}%
    %{--});--}%

    var id = null;
    function submitForm() {
        var $form = $("#frmSolicitud");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Solicitud");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
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
            return false;
        } //else
    }

    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            %{--url     : "${createLink(action:'form_ajax')}",--}%
            url     : "${createLink(action:'ingreso_ajax')}",
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
    } //createEdit

    function showSolicitud(id) {
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'show_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgVer",
                    title   : "Detalles de la Solicitud",

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
    } //createEdit


    $(function () {

        $(".btnCrear").click(function() {
            createEditRow();
            return false;
        });

        $("tbody>tr").contextMenu({
            items  : {
                header   : {
                    label  : "Acciones",
                    header : true
                },
                ver      : {
                    label  : "Ver Solicitud aprobada",
                    icon   : "fa fa-search",
                    action : function ($element) {
                        var id = $element.data("id");
                       showSolicitud(id);
                    }
                }
            },
            onShow : function ($element) {
                $element.addClass("success");
            },
            onHide : function ($element) {
                $(".success").removeClass("success");
            }
        });
    });


</script>

</body>
</html>
