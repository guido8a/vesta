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
                                                <g:if test="${session.perfil.codigo == 'RQ' && !vesta.modificaciones.DetalleReforma.findAllByReforma(vesta.modificaciones.Reforma.get(reforma?.id))}">
                                                    <a href="#"  class="btn btn-danger borrar"  reforma="${reforma?.id}" title="Eliminar reforma">
                                                        <i class="fa fa-close"></i>
                                                    </a>
                                                </g:if>
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

            $(".borrar").click(function () {
                var id = $(this).attr('reforma');
                bootbox.confirm("¿Está seguro de querer eliminar esta reforma?", function (res) {
                    if(res){
                        openLoader('Eliminando reforma');
                        $.ajax({
                            type    : "POST",
                            data : {
                                id: id
                            },
                            url     : "${createLink(action:'borrarReforma_ajax')}",
                            success : function (msg) {
                                if (msg != "ok") {
                                    closeLoader();
                                    bootbox.alert({
                                                message : "Error al eliminar la reforma",
                                                title   : "Error",
                                                class   : "modal-error"
                                            }
                                    );
                                }else{
                                    closeLoader();
                                    log("Reforma eliminada correctamente", "success");
                                    setTimeout(function () {
                                        location.reload(true)
                                    }, 2000);

                                }
                            }
                        });
                    }
                });
            });


        </script>
    </body>
</html>