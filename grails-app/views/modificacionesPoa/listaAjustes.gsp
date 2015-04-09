<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 08/04/15
  Time: 10:53 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Lista de ajustes</title>

        <style type="text/css">

        .panel .table td, .panel .table th, .panel .asignacion {
            font-size : 9pt;
        }

        .panel td.titulo {
            color     : #3A5DAA;
            font-size : 12pt;
            border    : none;
        }

        .panel .titulo-azul {
            font-size : 12pt;
        }
        </style>

    </head>

    <body>

        <div class="btn-toolbar toolbar bg-info corner-all"
             id="divBuscar" style="padding: 5px">
            <div class="btn-group col-md-2 noPadding">
                <elm:datepicker name="search_desde" placeholder="Desde" class="form-control datepicker"/>
            </div>

            <div class="btn-group col-md-2 noPadding">
                <elm:datepicker name="search_hasta" placeholder="Hasta" class="form-control datepicker"/>
            </div>

            <div class="btn-group col-md-2 noPadding">
                <g:select name="search_estado" from="[P: 'Pendiente', A: 'Aprobado']" class="form-control" noSelection="['': '- Estado -']"
                          optionKey="key" optionValue="value"/>
            </div><!-- /input-group -->

            <div class="btn-group">
                <g:link controller="modificacionesPoa" action="listaAjustes_ajax" class="btn btn-sm btn-default btnSearch">
                    <i class="fa fa-search"></i> Buscar
                </g:link>
                <g:link controller="modificacionesPoa" action="listaAjustes_ajax" class="btn btn-sm btn-default btnReset">
                    <i class="fa fa-close"></i> Borrar búsqueda
                </g:link>
            </div><!-- /input-group -->
        </div>

        <div id="divTabla">

        </div>

        <script type="text/javascript">
            function reload(params) {

                var data = {};

                if (params) {
                    data.search_desde = $("#search_desde_input").val();
                    data.search_hasta = $("#search_hasta_input").val();
                    data.search_estado = $("#search_estado").val();
                }

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'listaAjustes_ajax')}",
                    data    : data,
                    success : function (msg) {
                        $("#divTabla").html(msg);
                    }
                });
            }
            $(function () {
                reload(false);

                $(".btnSearch").click(function () {
                    reload(true);
                    return false;
                });

                $(".btnReset").click(function () {
                    $("#search_desde_input").val("");
                    $("#search_hasta_input").val("");
                    $("#search_estado").val("");
                    reload(false);
                    return false;
                });

            });
        </script>

    </body>
</html>