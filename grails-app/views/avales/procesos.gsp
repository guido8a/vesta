<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/01/15
  Time: 12:39 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Procesos ${(proyecto)?' del proyecto '+proyecto:''}</title>
</head>

<body>
<div class="breadCrumbHolder module">
    <div id="breadCrumb" class="breadCrumb module">
        <ul>

        </ul>
    </div>
</div>
<div style="width: 100%;height: 35px">
    <b>Proyecto: </b>
    <g:select from="${vesta.proyectos.Proyecto.list([sort:'nombre'])}" optionKey="id" optionValue="nombre" name="proyecto" id="proyecto" style="width:450px;" class="form-control input-sm"/>
</div>
</body>
</html>