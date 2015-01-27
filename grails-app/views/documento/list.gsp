<%@ page import="vesta.proyectos.Documento" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Biblioteca de Documentos</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            %{--<div class="btn-group">--}%
            %{--<a href="#" class="btn btn-default btnCrear">--}%
            %{--<i class="fa fa-file-o"></i> Crear--}%
            %{--</a>--}%
            %{--</div>--}%

            <div class="btn-group pull-right col-md-3">
                <div class="input-group">
                    <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
                    <span class="input-group-btn">
                        <g:link controller="documento" action="list" class="btn btn-default btn-search">
                            <i class="fa fa-search"></i>&nbsp;
                        </g:link>
                    </span>
                </div><!-- /input-group -->
            </div>
        </div>

        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th>CUP</th>
                    <g:sortableColumn property="proyecto" title="Proyecto"/>
                    <g:sortableColumn property="grupoProcesos" title="Grupo de procesos"/>
                    <g:sortableColumn property="descripcion" title="Descripción"/>
                    <g:sortableColumn property="clave" title="Palabras Clave"/>
                    <g:sortableColumn property="resumen" title="Resumen"/>
                </tr>
            </thead>
            <tbody>
                <g:if test="${documentoInstanceCount > 0}">
                    <g:each in="${documentoInstanceList}" status="i" var="documentoInstance">
                        <tr data-id="${documentoInstance.id}">
                            <td>
                                <elm:textoBusqueda busca="${params.search}">
                                    ${documentoInstance?.proyecto?.codigoProyecto}
                                </elm:textoBusqueda>
                            </td>
                            <td>
                                <elm:textoBusqueda busca="${params.search}">
                                    ${documentoInstance.proyecto?.nombre}
                                </elm:textoBusqueda>
                            </td>
                            <td>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documentoInstance}" field="grupoProcesos"/>
                                </elm:textoBusqueda>
                            </td>
                            <td>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documentoInstance}" field="descripcion"/>
                                </elm:textoBusqueda>
                            </td>
                            <td>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documentoInstance}" field="clave"/>
                                </elm:textoBusqueda>
                            </td>
                            <td>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documentoInstance}" field="resumen"/>
                                </elm:textoBusqueda>
                            </td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr class="danger">
                        <td class="text-center" colspan="7">
                            <g:if test="${params.search && params.search != ''}">
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

        <elm:pagination total="${documentoInstanceCount}" params="${params}"/>

        <script type="text/javascript">

            function downloadDocumento(id) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'documento', action:'existeDoc_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        if (msg == "OK") {
                            location.href = "${createLink(controller: 'documento', action: 'downloadDoc')}/" + id;
                        } else {
                            log("El documento solicitado no se encontró en el servidor", "error"); // log(msg, type, title, hide)
                        }
                    }
                });
            }

            $(function () {

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
                                    url     : "${createLink(controller:'documento', action:'show_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        bootbox.dialog({
                                            title   : "Ver Documento",
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
                        download : {
                            label  : "Descargar",
                            icon   : "fa fa-download",
                            action : function ($element) {
                                var id = $element.data("id");
                                downloadDocumento(id);
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
