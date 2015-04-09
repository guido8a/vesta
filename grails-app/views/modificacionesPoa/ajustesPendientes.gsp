<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 08/04/15
  Time: 12:15 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Lista de ajustes pendientes</title>
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

        <div id="divTabla">

        </div>

        <script type="text/javascript">
            function reload() {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'listaAjustes_ajax')}",
                    data    : {
                        search_persona : "${usu.id}",
                        firma          : "${usu.id}"
                    },
                    success : function (msg) {
                        $("#divTabla").html(msg);
                    }
                });
            }
            $(function () {
                reload();
            });
        </script>

    </body>
</html>