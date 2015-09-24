<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 08:50 AM
--%>

<%@ page import="vesta.seguridad.Persona" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de reformas</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="reformas" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Solicitar reforma
                </g:link>
                <g:link action="lista" class="btn btn-success">
                    <i class="fa fa-refresh"></i> Actualizar
                </g:link>

            </div>
        </div>


    <table class="table table-bordered table-hover table-condensed">
        <thead>
        <tr style="width: 1120px">
            <th style="width: 380px;">Solicita</th>
            <th style="width: 85px;">Fecha</th>
            <th style="width: 260px;">Justificación</th>
            <th style="width: 200px">Tipo</th>
            <th style="width: 105px;">Estado</th>
            <th style="width: 90px;">Acciones</th>
        </tr>
        </thead>
    </table>

        <div class="row-fluid"  style="width: 99.7%;height: 600px;overflow-y: auto;float: right;">
        <div class="span12">


    <div style="width: 1130px; height: 600px;">
        <table class="table table-bordered table-hover table-condensed">
            <thead>
                %{--<tr>--}%
                    %{--<th>Solicita</th>--}%
                    %{--<th style="width: 85px;">Fecha</th>--}%
                    %{--<th>Justificación</th>--}%
                    %{--<th>Tipo</th>--}%
                    %{--<th>Estado</th>--}%
                    %{--<th>Acciones</th>--}%
                %{--</tr>--}%
            </thead>


            <tbody>
                <g:each in="${reformas}" var="reforma">
                    <tr>
                        <td style="width: 380px;">${reforma.persona.unidad} - ${reforma.persona}</td>
                        <td style="width: 85px;">${reforma.fecha.format("dd-MM-yyyy")}</td>
                        <td style="width: 260px;">${reforma.concepto}</td>
                        <td style="width: 200px">
                            <elm:tipoReforma reforma="${reforma}"/>
                        </td>
                        <td style="width: 105px" class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                        <td style="text-align: center;width: 90px">
                            <div class="btn-group btn-group-xs" role="group">
                                %{--<elm:linkPdfReforma reforma="${reforma}" solicitud="s"/>--}%
                                <elm:linkPdfReforma reforma="${reforma}"/>
                            </div>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
     </div>
      </div>
     </div>
    </body>
</html>