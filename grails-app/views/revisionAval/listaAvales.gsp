<%@ page import="vesta.parametros.UnidadEjecutora; vesta.parametros.poaPac.Anio; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Historial de avales</title>
    </head>

    <body>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


        <div class="form-group keeptogether alert alert-success">
            <form class="form-inline">
                <div class="form-group">
                    <label for="anio">Año:</label>
                    <g:select from="${Anio.list([sort: 'anio'])}" id="anio" name="anio"
                              optionKey="id" optionValue="anio" value="${actual.id}" class="form-control input-sm"/>
                </div>

                <div class="form-group">
                    <label for="numero">Número:</label>
                    ${actual.anio}-GP No.<input type="text" id="numero" class="form-control input-sm"/>
                </div>

                <div class="form-group">
                    <label for="descProceso">Requirente:</label>
                    <g:select name="requirente" from="${unidades}" noSelection="['': '- TODOS -']"
                              class="form-control input-sm" style="width: 200px;" optionKey="id" id="requirenteId"/>
                </div>

                <div class="form-group">
                    <label for="descProceso">Proceso:</label>
                    <input type="text" id="descProceso" class="form-control input-sm" style="width: 200px;"/>
                </div>
                <a href="#" class="btn btn-info btn-sm" id="buscar">
                    <i class="fa fa-search-plus"></i> Buscar
                </a>
            </form>
        </div>

        <div id="detalle" style="width: 100%;height: 500px;overflow: auto"></div>

        <script>
            function cargarHistorial(anio, numero, proceso, requirente) {

                $.ajax({
                    type    : "POST", url : "${createLink(action:'historialAvales', controller: 'revisionAval')}",
                    data    : {
                        anio       : anio,
                        numero     : numero,
                        proceso    : proceso,
                        requirente : requirente
                    },
                    success : function (msg) {
                        $("#detalle").html(msg)

                    }
                });

            }
            function cargarHistorialSort(anio, numero, proceso, requirente, sort, order) {
                $.ajax({
                    type    : "POST", url : "${createLink(action:'historialAvales', controller: 'revisionAval')}",
                    data    : {
                        anio       : anio,
                        numero     : numero,
                        proceso    : proceso,
                        sort       : sort,
                        order      : order,
                        requirente : requirente
                    },
                    success : function (msg) {
                        $("#detalle").html(msg)

                    }
                });

            }
            $("#buscar").button().click(function () {
//                cargarHistorial($("#anio").val(), $("#numero").val(), $("#descProceso").val(), $("#requirente").val())
                cargarHistorialSort($("#anio").val(), $("#numero").val(), $("#descProceso").val(), $("#requirenteId").val())
            })
        </script>
    </body>
</html>