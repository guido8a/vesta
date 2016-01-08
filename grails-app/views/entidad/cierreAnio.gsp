<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Cierre del Año</title>
    <meta name="layout" content="main">
</head>

<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<g:if test="${anios.size() > 0}">

<elm:container tipo="horizontal" titulo="Cierre del Año:">
    <g:form action="cerrarAnio">
    <div class="row" style="padding: 10px; background: #DDD; border-radius: 5px; width: 80%; margin-left: 10%">
        <label for="anio" class="col-md-3">Seleccione el año a cerrar:</label>
        <g:select from="${anios}" value="${actual.anio}" optionKey="id" optionValue="anio" name="anio"
                  class="col-md-2 required requiredCombo"/>
        <span class="col-md-3"></span>
        <input type="submit" class="col-md-2 btn btn-lg btn-default" id="cerrar" title="Cerrar año seleccionado" value="Cerrar Año">
        %{--<input type="close" class="col-md-2 btn btn-lg btn-default" id="cancelar" title="Cancelar proceso de cierre" value="Cancelar">--}%
        <a href="${createLink(controller: 'inicio', action: 'inicio')}" class="col-md-2 btn btn-lg btn-default" title="Salir del proceso de cierre" value="Cancelar">Salir</a>
     </div>
    </g:form>
</elm:container>
</g:if>
<g:else>
    <a href="${createLink(controller: 'inicio', action: 'inicio')}" class="col-md-2 btn btn-lg btn-default" title="Salir del proceso de cierre" value="Cancelar">Salir</a>
</g:else>
</body>
</html>