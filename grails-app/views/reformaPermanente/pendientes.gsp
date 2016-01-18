<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Reformas pendientes</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>


    <div class="btn-toolbar toolbar">
        <div class="btn-group">
            <g:link action="pendientes" class="btn btn-success">
                <i class="fa fa-refresh"></i> Actualizar
            </g:link>
        </div>
    </div>

        <div role="tabpanel" style="margin-top: 15px;">

            <!-- Nav tabs -->
            <g:if test="${session.perfil.codigo != 'ASPL'}">
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active">
                    <a href="#pendientes" aria-controls="home" role="tab" data-toggle="pill">
                        Reformas pendientes
                    </a>
                </li>
                <li role="presentation">
                    <a href="#historial" aria-controls="profile" role="tab" data-toggle="pill">
                        Historial de reformas
                    </a>
                </li>
            </ul>
            </g:if>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="pendientes" style="margin-top: 20px;">
                    <g:if test="${reformas.size() > 0}">
                        <table class="table table-bordered table-hover table-condensed">
                            <thead>
                                <tr>
                                    <th>Gerencia</th>
                                    <th>Sol. No.</th>
                                    <th>Fecha</th>
                                    <th>Justificación</th>
                                    <th>Monto</th>
                                    <th>Tipo</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${reformas}" var="reforma" status="j">
                                    <tr>
                                        %{--<td>${reforma.persona}</td>--}%
                                        <td>${gerencias[j].codigo}</td>
                                        <td>${reforma?.numero}</td>
                                        <td>${reforma.fecha.format("dd-MM-yyyy")}</td>
                                        <td>${reforma.concepto}</td>
                                        <td>${totales[reforma.id]}</td>
                                        <td>
                                            <elm:tipoReforma reforma="${reforma}"/>
                                        </td>
                                        <td class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                                        <td>
                                            <div class="btn-group btn-group-xs" role="group">
                                                <elm:linkPdfReforma reforma="${reforma}"/>
                                                <elm:linkEditarReforma reforma="${reforma}" perfil="${session.perfil}"/>
                                            </div>
                                        </td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </g:if>
                    <g:else>
                        <div class="alert alert-info" style="width: 450px;margin-top: 20px">No existen solicitudes pendientes</div>
                    </g:else>
                </div>

                <div role="tabpanel" class="tab-pane" id="historial" style="margin-top: 20px">

                    <div id="detalle">

                    </div>
                </div>
            </div>

        </div>

        <script type="text/javascript">

            function buscar() {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'historial_ajax')}",
                    success : function (msg) {
                        $("#detalle").html(msg);
                    }
                });
            }

            $(function () {
                buscar();
            });

            %{--$("#btnActualizar").click(function () {--}%
                %{--console.log("entrofff")--}%
                %{--location.href = "${createLink(controller: 'reforma', action: 'pendientes')}"--}%
            %{--});--}%
        </script>
    </body>
</html>