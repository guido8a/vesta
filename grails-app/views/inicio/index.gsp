<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 18/12/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Pantalla de inicio</title>
        <style type="text/css">
        .img-responsive {
            height : 150px;
        }

        </style>
    </head>

    <body>

        <div class="well inicio2">
            <g:link controller="proyecto" action="list">
                <div class="row">
                    <div class="col-md-8">
                        <h3>Gestión de Proyectos</h3>
                        Marco lógico, metas, indicadores,
                        cronograma de inversión, fuentes de financiamiento, programación de inversiones plurianual.
                    </div>

                    <div class="col-md-4">
                        <img class="img-responsive" src="${resource(dir: 'images/inicio', file: 'gestion_proyectos.png')}"/>
                    </div>
                </div>
            </g:link>

            <g:link controller="entidad" action="arbol_asg">
                <div class="row no-margin-top">
                    <div class="col-md-8">
                        <h3>Gestión de Planificación</h3>
                        Marco lógico, metas, indicadores,
                        cronograma de inversión, fuentes de financiamiento, programación de inversiones plurianual.
                    </div>

                    <div class="col-md-4">
                        <img class="img-responsive" src="${resource(dir: 'images/inicio', file: 'gestion_planificacion.png')}"/>
                    </div>
                </div>
            </g:link>

            <g:link controller="avales" action="listaProcesos">
                <div class="row no-margin-top">
                    <div class="col-md-8">
                        <h3>Gestión de Seguimiento y Evaluación</h3>
                        Marco lógico, metas, indicadores,
                        cronograma de inversión, fuentes de financiamiento, programación de inversiones plurianual.
                    </div>

                    <div class="col-md-4">
                        <img class="img-responsive" src="${resource(dir: 'images/inicio', file: 'gestion_seguimiento.png')}"/>
                    </div>
                </div>
            </g:link>
        </div>

        %{--<div class="well inicio">--}%
        %{--<div class="row">--}%
        %{--<g:link controller="proyecto" action="list">--}%
        %{--<div class="col-md-4">--}%
        %{--<h3>Gestión de Proyectos</h3>--}%
        %{--Marco lógico, metas, indicadores,--}%
        %{--cronograma de inversión, fuentes de financiamiento, programación de inversiones plurianual.--}%
        %{--</div>--}%

        %{--<div class="col-md-2">--}%
        %{--<img src="${resource(dir: 'images/inicio', file: 'proyecto.jpg')}"/>--}%
        %{--</div>--}%
        %{--</g:link>--}%
        %{--<g:link controller="revisionAval" action="listaAvales" id="${session.unidad?.id}">--}%
        %{--<div class="col-md-4">--}%
        %{--<h3>Administración del POA</h3>--}%
        %{--Gestión de avales, reformas, reprogramaciones y documentación de respaldo.--}%
        %{--</div>--}%

        %{--<div class="col-md-2">--}%
        %{--<img src="${resource(dir: 'images/inicio', file: 'administracion.jpg')}"/>--}%
        %{--</div>--}%
        %{--</g:link>--}%
        %{--</div>--}%

        %{--<div class="row">--}%
        %{--<g:link controller="solicitud" action="list" id="${session.unidad?.id}">--}%
        %{--<div class="col-md-4">--}%
        %{--<h3>Contrataciones</h3>--}%
        %{--Sistematización del proceso de aprobación de contrataciones ligado al POA--}%
        %{--</div>--}%

        %{--<div class="col-md-2">--}%
        %{--<img src="${resource(dir: 'images/inicio', file: 'contratos.jpg')}"/>--}%
        %{--</div>--}%
        %{--</g:link>--}%
        %{--<g:link controller="documento" action="list">--}%
        %{--<div class="col-md-4">--}%
        %{--<h3>Seguimiento</h3>--}%
        %{--Seguimiento y evaluación del POA, detalle de subactividades, control de avales, anvances físico y económico--}%
        %{--</div>--}%

        %{--<div class="col-md-2">--}%
        %{--<img src="${resource(dir: 'images/inicio', file: 'seguimiento.jpg')}"/>--}%
        %{--</div>--}%
        %{--</g:link>--}%
        %{--</div>--}%
        %{--</div>--}%

        <div class="row">
            <div class="col-md-2 col-md-offset-10 text-right">
                Versión 1.0
            </div>
        </div>

    </body>
</html>