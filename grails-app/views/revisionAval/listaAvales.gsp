<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/01/15
  Time: 12:15 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Historial de avales</title>
    </head>

    <body>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


        <div class="form-group keeptogether alert alert-success">
            <div class="col-md-3">
                <span class="grupo">
                    <label class="col-md-2 control-label">Año:
                    </label>

                    <div class="col-md-5">
                        <g:select name="anioName" from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" class="form-control input-sm" value="${actual.id}" optionKey="id" optionValue="anio" id="anio"/>
                    </div>
                </span>
            </div>

            <div class="col-md-4">
                <span class="grupo">
                    <label class="col-md-6 control-label">Número: ${actual.anio}-GP N°
                    </label>

                    <div class="col-md-6">
                        <g:textField class="form-control input-sm number" name="numeroName" title="Número" id="numero"/>
                    </div>
                </span>
            </div>

            <div class="col-md-4">
                <span class="grupo">
                    <label class="col-md-4 control-label">Proceso:
                    </label>

                    <div class="col-md-6">
                        <g:textField class="form-control input-sm" style="width: 250px" name="descProcesoName" title="Proceso" id="descProceso"/>
                    </div>
                </span>
            </div>

            <div class="btn-group">
                <a href="#" class="btn btn-default btn-sm" id="buscar">
                    <i class="fa fa-search-plus"></i> Buscar
                </a>
            </div>
        </div>

        <div id="detalle" style="width: 100%;height: 500px;overflow: auto"></div>
        <script>
            function cargarHistorial(anio, numero, proceso) {

                $.ajax({
                    type    : "POST", url : "${createLink(action:'historialAvales', controller: 'revisionAval')}",
                    data    : {
                        anio    : anio,
                        numero  : numero,
                        proceso : proceso
                    },
                    success : function (msg) {
                        $("#detalle").html(msg)

                    }
                });

            }
            function cargarHistorialSort(anio, numero, proceso, sort, order) {
                $.ajax({
                    type    : "POST", url : "${createLink(action:'historialAvales', controller: 'revisionAval')}",
                    data    : {
                        anio    : anio,
                        numero  : numero,
                        proceso : proceso,
                        sort    : sort,
                        order   : order
                    },
                    success : function (msg) {
                        $("#detalle").html(msg)

                    }
                });

            }
            $("#buscar").button().click(function () {
                cargarHistorial($("#anio").val(), $("#numero").val(), $("#descProceso").val())
            })
        </script>
    </body>
</html>