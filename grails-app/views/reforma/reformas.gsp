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
        <title>Reformas</title>
        <link href="${resource(dir: 'css', file: 'reformas-ajustes.css')}" rel="stylesheet">
    </head>

    <body>
        %{--<elm:container tipo="horizontal" titulo="Reformas">--}%
            %{--<p>--}%
                %{--Existen 5 tipos de reformas:--}%
                %{--asignaciones existentes, partida nueva, actividad nueva financiada con recursos del área, actividad nueva sin financiamiento de recursos del área e incrementos--}%
            %{--</p>--}%

            %{--<div class="list-group">--}%
                %{--<g:link action="existente" class="list-group-item bgExistentes">--}%
                    %{--<h4 class="list-group-item-heading"><span class="icon"></span>--}%
                        %{--<elm:tipoReformaStr tipo="Reforma" tipoSolicitud="E"/>--}%
                    %{--</h4>--}%

                    %{--<p class="list-group-item-text">--}%
                        %{--se selecciona asignación o asignaciones de origen, asignación o asignaciones de destino y el valor--}%
                    %{--</p>--}%
                %{--</g:link>--}%
                %{--<g:link action="partida" class="list-group-item bgPartidas">--}%
                    %{--<h4 class="list-group-item-heading"><span class="icon"></span>--}%
                        %{--<elm:tipoReformaStr tipo="Reforma" tipoSolicitud="P"/>--}%
                    %{--</h4>--}%

                    %{--<p class="list-group-item-text">--}%
                        %{--se parte del valor actual de la asignación de origen a la--}%
                        %{--cual se añaden partidas, repartiendo el valor de la asignación en nuevas partidas--}%
                    %{--</p>--}%
                %{--</g:link>--}%
                %{--<g:link action="actividad" class="list-group-item bgActividades">--}%
                    %{--<h4 class="list-group-item-heading"><span class="icon"></span>--}%
                        %{--<elm:tipoReformaStr tipo="Reforma" tipoSolicitud="A"/>--}%
                    %{--</h4>--}%

                    %{--<p class="list-group-item-text">--}%
                        %{--se crea nuevas actividades con asignación de origen, valor, actividad nueva (con fecha de incio, fecha de fin, justificación, valor y componente)--}%
                    %{--</p>--}%
                %{--</g:link>--}%
                %{--<g:link action="incrementoActividad" class="list-group-item bgActividades2">--}%
                    %{--<h4 class="list-group-item-heading"><span class="icon"></span>--}%
                        %{--<elm:tipoReformaStr tipo="Reforma" tipoSolicitud="C"/>--}%
                    %{--</h4>--}%

                    %{--<p class="list-group-item-text">--}%
                        %{--se crea nuevas actividades sin asignación de origen, valor, actividad nueva (con fecha de incio, fecha de fin, justificación, valor y componente)--}%
                    %{--</p>--}%
                %{--</g:link>--}%
                %{--<g:link action="incremento" class="list-group-item bgIncremento">--}%
                    %{--<h4 class="list-group-item-heading"><span class="icon"></span>--}%
                        %{--<elm:tipoReformaStr tipo="Reforma" tipoSolicitud="I"/>--}%
                    %{--</h4>--}%

                    %{--<p class="list-group-item-text">--}%
                        %{--se requiere de un incremento de asignación existente, no se sabe las fuentes. Usa una asignación de destino y un valor.--}%
                        %{--En el proceso de aprobación se debe definir la o las asignaciones de origen, repartiendo el valor en nuevas asignaciones hasta que el saldo sea 0--}%
                    %{--</p>--}%
                %{--</g:link>--}%
            %{--</div>--}%
        %{--</elm:container>--}%

        <elm:container tipo="horizontal" titulo="Reformas">
        <div class="btn-group" role="group">
        <g:link action="existente" class="btn btn-default bgExistentes" style="width: 370px; text-align: left; font-size: large;
            font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
            title="Traspaso de recursos del área  entre actividades y partidas presupuestarias existentes">
            1.- Reasignación de recursos existentes
        </g:link> <br>
        <g:link action="partida" class="btn btn-default bgPartidas" style="width: 370px; text-align: left; font-size: large;
            font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
            title="Modificación en la distribución de los recursos de la actividad hacia nuevas partidas presupuestarias ">
            2.- Inclusión de nuevas partidas presupuestarias
        </g:link> <br>
        <g:link action="incremento" class="btn btn-default bgIncremento"  style="width: 370px; text-align: left;
            font-size: large; font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
                    title="Creación de una nueva actividad para la que se requiere asignación de recursos ">
            3.- Actividad del área sin financiamiento
        </g:link> <br>
        <g:link action="actividad" class="btn btn-default bgActividades2"   style="width: 370px;
            text-align: left;  font-size: large; font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
            title="Creación de una nueva actividad con asignación de recursos de otra actividad del área">
            4.- Creación de una nueva actividad
        </g:link> <br>
        <g:link action="incrementoActividad" class="btn btn-default bgActividades"  style="width: 370px; text-align: left;
            font-size: large; font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
                    title="Selección de actividad dentro del área para la que se requiere asignación o incremento de recursos">
            5.- Creación de una nueva actividad sin financiamiento
        </g:link>
        <g:link action="nuevaReforma" class="btn btn-default bgNuevaReforma"  style="width: 370px; text-align: left;
            font-size: large; font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
                title="Nueva Reforma">
            6.- Nueva Reforma
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