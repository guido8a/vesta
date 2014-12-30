<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/08/14
  Time: 12:17 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Subir archivo Excel</title>

    <style type="text/css">
    .colorf {
       color: #ff162a;
    }
    </style>

</head>

<body>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>

</g:if>
<div style="width: 800px; margin-bottom:5px; margin-top:10px; padding: 4px;" class="ui-corner-all ui-widget-content">
    <g:form name="frmUpload" enctype="multipart/form-data" method="post" action="subirExcel">
        <div class="container ui-corner-all" style="min-height: 100px; width: 800px;">
           Archivo Excel: <input type="file" class="ui-corner-all" name="file" id="file" size="70"/>
        </div>
        <div>
            <a href="#" id="btnUpload">Cargar archivo excel</a>
        </div>
    </g:form>
</div>
<div class="colorf">

    * El archivo a cargar solo puede ser de tipo XLS
</div>

<script type="text/javascript">
    $(function () {
        $("#btnUpload").button().click(function () {
            $("#frmUpload").submit();
        });
    });
</script>

</body>
</html>