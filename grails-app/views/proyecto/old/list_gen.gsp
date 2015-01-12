
<%@ page import="yachay.proyectos.Proyecto" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName"
               value="${message(code: 'proyecto.label', default: 'Proyecto')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>

    <body>

        <div class="dialog" title="${title}">


            <div class="body">
                <g:if test="${flash.message}">
                    <div class="message">${flash.message}</div>
                </g:if>
                <div class="list" style="width: 600px;">
                    <div class="fg-toolbar ui-toolbar ui-widget-header ui-corner-top ui-helper-clearfix">
                        %{--<div id="example_length" class="dataTables_length">--}%
                            %{--<g:message code="show" default="Show" />&nbsp;--}%
                            %{--<g:select from="${[10,20,30,40,50,60,70,80,90,100]}" name="max" value="${params.max}" />&nbsp;--}%
                            %{--<g:message code="entries" default="entries" />--}%


                            %{--<g:select--}%
                                %{--from="['asc':message(code:'asc', default:'Ascendente'), 'desc':message(code:'desc', default:'Descendente')]"--}%
                                %{--name="order"--}%
                                %{--optionKey="key"--}%
                                %{--optionValue="value"--}%
                                %{--value="${params.order}"--}%
                                %{--class="ui-widget-content ui-corner-all"/>--}%
                        %{--</div>--}%
                    </div>
                    <table style="width: 600px;">
                        <thead>
                            <tr>
                                
                                <tdn:sortableColumn property="id" class="ui-state-default"
                                                  title="${message(code: 'proyecto.id.label', default: 'Id')}" />
                                
                                <th class="ui-state-default"><g:message code="proyecto.unidadEjecutora.label"
                                               default="Unidad Ejecutora" /></th>
                                
                                <th class="ui-state-default"><g:message code="proyecto.etapa.label"
                                               default="Etapa" /></th>
                                
                                <th class="ui-state-default"><g:message code="proyecto.fase.label"
                                               default="Fase" /></th>
                                
                                <th class="ui-state-default"><g:message code="proyecto.tipoProducto.label"
                                               default="Tipo Producto" /></th>
                                
                                <th class="ui-state-default"><g:message code="proyecto.estadoProyecto.label"
                                               default="Estado Proyecto" /></th>
                                
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${proyectoInstanceList}" status="i" var="proyectoInstance">
                                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                    
                                    <td><g:link action="show"
                                                id="${proyectoInstance.id}">${fieldValue(bean: proyectoInstance, field: "id")}</g:link></td>
                                    
                                    <td>${fieldValue(bean: proyectoInstance, field: "unidadEjecutora")}</td>
                                    
                                    <td>${fieldValue(bean: proyectoInstance, field: "etapa")}</td>
                                    
                                    <td>${fieldValue(bean: proyectoInstance, field: "fase")}</td>
                                    
                                    <td>${fieldValue(bean: proyectoInstance, field: "tipoProducto")}</td>
                                    
                                    <td>${fieldValue(bean: proyectoInstance, field: "estadoProyecto")}</td>
                                    
                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>

                <div class="fg-toolbar ui-toolbar ui-widget-header ui-corner-bottom ui-helper-clearfix paginateButtons">
                    <tdn:paginate total="${proyectoInstanceTotal}" />
                </div>
            </div> <!-- body -->
        </div> <!-- dialog -->

        <script type="text/javascript">
            $(function() {
                $(".button").button();
                $(".home").button("option", "icons", {primary:'ui-icon-home'});
                $(".create").button("option", "icons", {primary:'ui-icon-document'});

                $(".edit").button("option", "icons", {primary:'ui-icon-pencil'});
                $(".delete").button("option", "icons", {primary:'ui-icon-trash'}).click(function() {
                    if(confirm("${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}")) {
                        return true;
                    }
                    return false;
                });
            });
        </script>

    </body>
</html>
