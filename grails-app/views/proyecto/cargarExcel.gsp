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
    <div class="message" style="margin-top: 15px;color: red">${flash.message}</div>
</g:if>
<elm:container tipo="horizontal" titulo="Cargar proyectos desde un arcvhio Excel">
    <g:form name="frmUpload" enctype="multipart/form-data" method="post" action="subirExcel">
        <div class="row">
            <div class="col-md-1" style="width: 120px">
                <label>
                    Archivo Excel:
                </label>
            </div>
            <div class="col-md-4" style="height: 30px">
                <input type="file"  name="file" id="file" size="70" style="height: 25px;"/>
            </div>
            <div class="col-md-1">
                <a href="#" id="btnUpload" class="btn btn-info btn-sm">
                    <i class="fa fa-disk"></i>
                    Procesar
                </a>
            </div>
            <div class="col-md-4" style="color:red; width: 510px">
                * El archivo a cargar sólo puede ser del tipo "XLS" (formato WORD 97 - 2003)
            </div>
        </div>
    </g:form>
</elm:container>
<elm:container tipo="horizontal" titulo="Estructura del archivo">
    <div class="row">
        <div class="col-md-6">
            <label> El orden de las columnas debe ser el siguiente:</label>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <img src="${g.resource(dir: 'images',file: 'ejemploExcel.PNG')}" width="100%">
        </div>
    </div>
</elm:container>
<script type="text/javascript">
    $(function () {
        $("#btnUpload").click(function () {
            if($("#file").val()!=""){
                $("#frmUpload").submit();
            }
        });
    });
</script>

</body>
</html>