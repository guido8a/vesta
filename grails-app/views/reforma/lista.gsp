<%@ page import="vesta.parametros.UnidadEjecutora; vesta.parametros.poaPac.Anio; vesta.seguridad.Persona" contentType="text/html;charset=UTF-8" %><html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de reformas</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:if test="${session.perfil.codigo != 'OBS'}">
                    <g:link action="reformas" class="btn btn-default btnCrear">
                        <i class="fa fa-file-o"></i> Solicitar reforma
                    </g:link>
                </g:if>
                <g:link action="lista" class="btn btn-success">
                    <i class="fa fa-refresh"></i> Actualizar
                </g:link>

            </div>
        </div>


    <div class="form-group  alert alert-success">
        <form action="lista" class="form-inline">
            <div class="form-group">
                <label for="anio">Año:</label>
                <g:select from="${Anio.list([sort: 'anio'])}" id="anio" name="anio"
                          optionKey="id" optionValue="anio" value="${params.actual}" class="form-control input-sm"/>
            </div>

            <div class="form-group" style="margin-left: 30px;">
                <label for="numero">Número:</label>
                ${Anio.get(params.actual.toInteger()).anio}-GP No.
                <input type="text" id="numero" name="numero" class="form-control input-sm" value="${params.numero}"/>
            </div>

            <div class="form-group" style="margin-left: 30px;">
                <label for="requirente">Requirente:</label>
                <g:select name="requirente" from="${unidades}" noSelection="['': '- Todos -']"
                          class="form-control input-sm" style="width: 400px;" optionKey="id" value="${params.requirente}"/>
            </div>

            <a href="#" class="btn btn-info btn-sm" id="buscar">
                <i class="fa fa-search-plus"></i> Buscar
            </a>
        </form>
    </div>

    <table class="table table-bordered table-hover table-condensed">
        <thead>
        <tr style="width: 1120px">
            <th style="width: 200px;">Solicita</th>
            <th style="width: 65px;">No. Sol.</th>
            <th style="width: 85px;">Fecha</th>
            <th style="width: 360px;">Justificación</th>
            <th style="width: 80px;">Monto</th>
            <th style="width: 200px">Tipo</th>
            <th style="width: 65px">No. Ref.</th>
            <th style="width: 105px;">Estado</th>
            <th style="width: 90px;">Documentos</th>
        </tr>
        </thead>
    </table>

        <div class="row-fluid"  style="width: 99.7%;height: 600px;overflow-y: auto;float: right;">
        <div class="span12">


    <div style="width: 1130px; height: 600px;">
        <table class="table table-bordered table-hover table-condensed">
            <tbody>
                <g:each in="${reformas}" var="reforma">
                    <g:if test="${session.perfil.codigo =='ASPL'}">
                        <g:if test="${reforma.estado.codigo == 'E02'}">
                    <tr>
                        %{--<td style="width: 380px;">${reforma.persona.unidad} - ${reforma.persona}</td>--}%
                        <td style="width: 200px;">${reforma.persona.unidad}</td>
                        <td style="width: 65px;"><elm:numeroRef numero="${reforma?.numero}"/></td>
                        <td style="width: 85px;">${reforma.fecha.format("dd-MM-yyyy")}</td>
                        <td style="width: 360px;">${reforma.concepto}</td>
                        <td style="width: 80px;">${totales[reforma.id]}</td>
                        <td style="width: 200px"><elm:tipoReforma reforma="${reforma}"/></td>
                        <td style="width: 65px"><elm:numeroRef numero="${reforma?.numeroReforma}"/></td>
                        <td style="width: 105px" class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                        <td style="text-align: center;width: 90px">
                            <div class="btn-group btn-group-xs" role="group">
                                <elm:linkPdfReforma reforma="${reforma}"/>
                            </div>
                        </td>
                    </tr>
                    </g:if>
                    </g:if>
                    <g:else>
                        <tr>
                        <td style="width: 200px;">${reforma.persona.unidad}</td>
                        <td style="width: 65px;"><elm:numeroRef numero="${reforma?.numero}"/></td>
                        <td style="width: 85px;">${reforma.fecha.format("dd-MM-yyyy")}</td>
                        <td style="width: 360px;">${reforma.concepto}</td>
                        <td style="width: 80px;">${totales[reforma.id]}</td>
                        <td style="width: 200px"><elm:tipoReforma reforma="${reforma}"/></td>
                        <td style="width: 65px"><elm:numeroRef numero="${reforma?.numeroReforma}"/></td>
                        <td style="width: 105px" class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                        <td style="text-align: center;width: 90px">
                            <div class="btn-group btn-group-xs" role="group">
                                <elm:linkPdfReforma reforma="${reforma}"/>
                            </div>
                        </td>
                    </g:else>
                </g:each>
            </tbody>
        </table>
     </div>
      </div>
     </div>
    <script>
        $("#buscar").button().click(function () {
            $('form')[0].submit();
        })
    </script>
    </body>
</html>