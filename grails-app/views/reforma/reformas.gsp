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
%{--
        <g:link controller="reformaPermanente" action="nuevaReformaCorriente" class="btn btn-default bgNuevaReformaCorriente"  style="width: 370px; text-align: left;
            font-size: large; font-weight: bolder; margin-bottom: 10px; margin-left: 300px"
                title="Nueva Reforma de gasto corriente">
            7.- Nueva Reforma Corriente
        </g:link>
--}%


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