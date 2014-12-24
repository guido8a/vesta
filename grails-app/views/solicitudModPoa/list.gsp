
<%@ page import="vesta.modificaciones.SolicitudModPoa" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de SolicitudModPoa</title>
    </head>
    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

    <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <a href="#" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Crear
                </a>
            </div>
            <div class="btn-group pull-right col-md-3">
                <div class="input-group">
                    <input type="text" class="form-control input-sm input-search" placeholder="Buscar" value="${params.search}">
                    <span class="input-group-btn">
                        <g:link controller="solicitudmodpoa" action="list" class="btn btn-default btn-search">
                            <i class="fa fa-search"></i>&nbsp;
                        </g:link>
                    </span>
                </div><!-- /input-group -->
            </div>
        </div>

        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    
                    <g:sortableColumn property="fechaRevision" title="Fecha Revision" />
                    
                    <th>Origen</th>
                    
                    <th>Destino</th>
                    
                    <th>Anio</th>
                    
                    <th>Fuente</th>
                    
                    <th>Marco Logico</th>
                    
                    <th>Presupuesto</th>
                    
                    <g:sortableColumn property="valor" title="Valor" />
                    
                    <g:sortableColumn property="concepto" title="Concepto" />
                    
                    <g:sortableColumn property="estado" title="Estado" />
                    
                </tr>
            </thead>
            <tbody>
                <g:if test="${solicitudModPoaInstanceCount > 0}">
                    <g:each in="${solicitudModPoaInstanceList}" status="i" var="solicitudModPoaInstance">
                        <tr data-id="${solicitudModPoaInstance.id}">
                            
                            <td>${solicitudModPoaInstance.fechaRevision}</td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="origen"/></elm:textoBusqueda></td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="destino"/></elm:textoBusqueda></td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="anio"/></elm:textoBusqueda></td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="fuente"/></elm:textoBusqueda></td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="marcoLogico"/></elm:textoBusqueda></td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="presupuesto"/></elm:textoBusqueda></td>
                            
                            <td><g:fieldValue bean="${solicitudModPoaInstance}" field="valor"/></td>
                            
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${solicitudModPoaInstance}" field="concepto"/></elm:textoBusqueda></td>
                            
                            <td><g:fieldValue bean="${solicitudModPoaInstance}" field="estado"/></td>
                            
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr class="danger">
                        <td class="text-center" colspan="25">
                            <g:if test="${params.search && params.search!= ''}">
                                No se encontraron resultados para su búsqueda
                            </g:if>
                            <g:else>
                                No se econtraron registros que mostrar
                            </g:else>
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>

        <elm:pagination total="${solicitudModPoaInstanceCount}" params="${params}"/>

        <script type="text/javascript">
            var id = null;
            function submitForm() {
                var $form = $("#frmSolicitudModPoa");
                var $btn = $("#dlgCreateEdit").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando SolicitudModPoa");
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
                              "¿Está seguro que desea eliminar el SolicitudModPoa seleccionado? Esta acción no se puede deshacer.</p>",
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
                                openLoader("Eliminando SolicitudModPoa");
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
                            title   : title + " SolicitudModPoa",
                            
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
                            b.find(".form-control input-sm").first().focus()
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
                            label  : "Ver",
                            icon   : "fa fa-search",
                            action : function ($element) {
                                var id = $element.data("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'show_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        bootbox.dialog({
                                            title   : "Ver SolicitudModPoa",
                                            message : msg,
                                            buttons : {
                                                ok : {
                                                    label     : "Aceptar",
                                                    className : "btn-primary",
                                                    callback  : function () {
                                                    }
                                                }
                                            }
                                        });
                                    }
                                });
                            }
                        },
                        editar   : {
                            label  : "Editar",
                            icon   : "fa fa-pencil",
                            action : function ($element) {
                                var id = $element.data("id");
                                createEditRow(id);
                            }
                        },
                        eliminar : {
                            label            : "Eliminar",
                            icon             : "fa fa-trash-o",
                            separator_before : true,
                            action           : function ($element) {
                                var id = $element.data("id");
                                deleteRow(id);
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
