
<%@ page import="vesta.contratacion.DetalleMontoSolicitud; vesta.contratacion.Solicitud" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <g:set var="entityName"
               value="${message(code: 'solicitud.label', default: 'Año')}"/>
        <title>Lista de Solicitudes</title>
    </head>
    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

    <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
            <g:if test="${session.perfil.codigo == 'RQ'}">
                <a href="#" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Nueva Solicitud
                </a>
            </g:if>
                <a href="#" class="btn btn-default button print">
                    PDF
                </a>
                <g:link controller="reporteSolicitud" action="solicitudesXls" class="btn btn-default button xls">
                    XLS
                </g:link>

                <g:if test="${session.perfil.codigo == 'GP'}">
                    <g:link class="button aprobacion" controller="aprobacion" action="list">
                        Reuniones de aprobación
                    </g:link>
                </g:if>
            </div>
            <div class="btn-group pull-right col-md-3">
                <div class="input-group">
                    <input type="text" class="form-control input-sm input-search" placeholder="Buscar" value="${params.search}">
                    <span class="input-group-btn">
                        <g:link controller="solicitud" action="list" class="btn btn-default btn-search">
                            <i class="fa fa-search"></i>&nbsp;
                        </g:link>
                    </span>
                </div><!-- /input-group -->
            </div>
        </div>

        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    
                    %{--<g:sortableColumn property="observaciones" title="Observaciones" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="revisadoAdministrativaFinanciera" title="Revisado Administrativa Financiera" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="revisadoJuridica" title="Revisado Juridica" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="revisadoDireccionProyectos" title="Revisado Direccion Proyectos" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="observacionesAdministrativaFinanciera" title="Observaciones Administrativa Financiera" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="observacionesJuridica" title="Observaciones Juridica" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="observacionesDireccionProyectos" title="Observaciones Direccion Proyectos" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="pathPdfTdr" title="Path Pdf Tdr" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="estado" title="Estado" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="pathOferta1" title="Path Oferta1" />--}%

                    <g:sortableColumn property="unidadEjecutora" title="Unidad Ejecutora" />
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
                        <g:if test="${session.perfil.codigo != 'GP' || (session.perfil.codigo == 'GP' && vesta.contratacion.DetalleMontoSolicitud.countBySolicitud(solicitudInstance) > 0)}">

                            <tr data-id="${solicitudInstance.id}">

                                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="unidadEjecutora.nombre"/></elm:textoBusqueda></td>
                                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="actividad.objeto"/></elm:textoBusqueda></td>
                                <td><g:formatDate date="${solicitudInstance.fecha}" format="dd-MM-yyyy" /></td>
                                <td style="text-align: right"><g:formatNumber number="${solicitudInstance.montoSolicitado}" type="currency"/></td>
                                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="tipoContrato.descripcion"/></elm:textoBusqueda></td>
                                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="nombreProceso"/></elm:textoBusqueda></td>
                                <td><g:formatNumber number="${solicitudInstance.plazoEjecucion}" maxFractionDigits="0"/> días</td>

                            %{--<td>${solicitudInstance.observaciones}</td>--}%
                            %{--<td><g:formatDate date="${solicitudInstance.revisadoAdministrativaFinanciera}" format="dd-MM-yyyy" /></td>--}%
                            %{--<td><g:formatDate date="${solicitudInstance.revisadoJuridica}" format="dd-MM-yyyy" /></td>--}%
                            %{--<td><g:formatDate date="${solicitudInstance.revisadoDireccionProyectos}" format="dd-MM-yyyy" /></td>--}%
                            %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="observacionesAdministrativaFinanciera"/></elm:textoBusqueda></td>--}%
                            %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="observacionesJuridica"/></elm:textoBusqueda></td>--}%
                            %{----}%
                            %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="observacionesDireccionProyectos"/></elm:textoBusqueda></td>--}%
                            %{----}%
                            %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="pathPdfTdr"/></elm:textoBusqueda></td>--}%
                            %{----}%
                            %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="estado"/></elm:textoBusqueda></td>--}%
                            %{----}%
                            %{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudInstance}" field="pathOferta1"/></elm:textoBusqueda></td>--}%
                            %{----}%
                        </tr>
                    </g:if>
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
            function deleteRow(itemId) {
                bootbox.dialog({
                    title   : "Alerta",
                    message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
                              "¿Está seguro que desea eliminar el Solicitud seleccionado? Esta acción no se puede deshacer.</p>",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        eliminar : {
                            label     : "<i class='fa fa-trash-o'></i> Eliminar",
                            className : "btn-danger",
                            callback  : function () {
                                openLoader("Eliminando Solicitud");
                                $.ajax({
                                    type    : "POST",
                                    url     : '${createLink(action:'delete_ajax')}',
                                    data    : {
                                        id : itemId
                                    },
                                    success : function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                        if (parts[0] == "SUCCESS") {
                                            setTimeout(function() {
                                                location.reload(true);
                                            }, 1000);
                                        } else {
                                            closeLoader();
                                        }
                                    }
                                });
                            }
                        }
                    }
                });
            }
            function createEditRow(id) {
                var title = id ? "Editar" : "Crear";
                var data = id ? { id: id } : {};
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'form_ajax')}",
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
                            label  : "Ver Solicitud",
                            icon   : "fa fa-search",
                            action : function ($element) {
                                var id = $element.data("id");
                                location.href = "${createLink(action: 'show')}?id=" + id;

                                %{--$.ajax({--}%
                                    %{--type    : "POST",--}%
                                    %{--url     : "${createLink(action:'show_ajax')}",--}%
                                    %{--data    : {--}%
                                        %{--id : id--}%
                                    %{--},--}%
                                    %{--success : function (msg) {--}%
                                    %{--}--}%
                                %{--});--}%
                            }
                        }
//                        editar   : {
//                            label  : "Editar",
//                            icon   : "fa fa-pencil",
//                            action : function ($element) {
//                                var id = $element.data("id");
//                                createEditRow(id);
//                            }
//                        },
//                        eliminar : {
//                            label            : "Eliminar",
//                            icon             : "fa fa-trash-o",
//                            separator_before : true,
//                            action           : function ($element) {
//                                var id = $element.data("id");
//                                deleteRow(id);
//                            }
//                        }
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
