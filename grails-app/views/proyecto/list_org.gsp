
<%@ page import="yachay.proyectos.Proyecto" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'proyecto.label', default: 'Proyecto')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'proyecto.id.label', default: 'Id')}" />
                        
                            <th><g:message code="proyecto.unidadEjecutora.label" default="Unidad Ejecutora" /></th>
                        
                            <th><g:message code="proyecto.etapa.label" default="Etapa" /></th>
                        
                            <th><g:message code="proyecto.fase.label" default="Fase" /></th>
                        
                            <th><g:message code="proyecto.tipoProducto.label" default="Tipo Producto" /></th>
                        
                            <th><g:message code="proyecto.estadoProyecto.label" default="Estado Proyecto" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${proyectoInstanceList}" status="i" var="proyectoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${proyectoInstance.id}">${fieldValue(bean: proyectoInstance, field: "id")}</g:link></td>
                        
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
            <div class="paginateButtons">
                <g:paginate total="${proyectoInstanceTotal}" />
            </div>
        </div>
    </body>

</html>
