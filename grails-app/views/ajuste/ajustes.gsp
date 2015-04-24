<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 14/04/15
  Time: 03:31 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Ajustes</title>
    </head>

    <body>
        <elm:container tipo="horizontal" titulo="Ajustes">
            <p>
                Existen 3 tipos de ajustes posibles:
                asignaciones existentes, actividad nueva, partida nueva
            </p>

            <div class="list-group">
                <g:link action="existente" class="list-group-item">
                    <h4 class="list-group-item-heading"><span class="icon"></span> Asignaciones Existentes</h4>

                    <p class="list-group-item-text">
                        se selecciona asignación o asignaciones de origen, asignación o asignaciones de destino y valor
                    </p>
                </g:link>
                <g:link action="partida" class="list-group-item">
                    <h4 class="list-group-item-heading"><span class="icon"></span> Nuevas Partidas</h4>

                    <p class="list-group-item-text">
                        se parte del valor actual de la asignación de origen a la
                        cual se añaden partidas, repartiendo el valor de la asignación en nuevas partidas
                    </p>
                </g:link>
                <g:link action="actividad" class="list-group-item">
                    <h4 class="list-group-item-heading"><span class="icon"></span> Nuevas actividades</h4>

                    <p class="list-group-item-text">
                        se crea nuevas actividades con asignación de origen, valor, actividad nueva (con fecha de incio, fecha de fin, justificación, valor y componente)
                    </p>
                </g:link>
            </div>
        </elm:container>

        <script type="text/javascript">
            $(function () {
                $(".list-group-item").hover(function () {
                    $(this).find(".icon").html('<i class="fa fa-arrow-right"></i>');
                }, function () {
                    $(this).find(".icon").html('');
                });
            });
        </script>

    </body>
</html>