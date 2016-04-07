<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Ajustes POA gasto permanente pendientes</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <div role="tabpanel" style="margin-top: 15px;">

            <!-- Nav tabs -->
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active">
                    <a href="#pendientes" aria-controls="home" role="tab" data-toggle="pill">
                        Solicitudes pendientes
                    </a>
                </li>
                <li role="presentation">
                    <a href="#historial" aria-controls="profile" role="tab" data-toggle="pill">
                        Historial solicitudes
                    </a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="pendientes" style="margin-top: 20px;">
                    <g:if test="${reformas.size() > 0}">
                        <table class="table table-bordered table-hover table-condensed">
                            <thead>
                                <tr>
                                    <th>Solicita</th>
                                    <th>Fecha</th>
                                    <th>Concepto</th>
                                    <th>Tipo</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${reformas}" var="reforma">
                                    <tr>
                                        <td>${reforma.persona}</td>
                                        <td>${reforma.fecha.format("dd-MM-yyyy")}</td>
                                        <td>${reforma.concepto}</td>
                                        <td>
                                            <elm:tipoReforma reforma="${reforma}"/>
                                        </td>
                                        <td class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                                        <td>
                                            <div class="btn-group btn-group-xs" role="group">
                                                <elm:linkPdfReforma reforma="${reforma}"/>
                                                <elm:linkEditarReforma reforma="${reforma}" perfil="${session.perfil}"/>
                                                <g:if test="${reforma?.estado?.codigo == 'P01' && (unidad == 'DF' || unidad == 'DA' || unidad == 'GAF')}">
                                                    <a href="#" id="btnEditar" class="btn btn-success edit" data-ref="${reforma?.id}" title="Editar"><i class="fa fa-pencil"></i></a>
                                                </g:if>
                                                <g:if test="${session.perfil.codigo == 'ASAF' && !vesta.modificaciones.DetalleReforma.findAllByReforma(vesta.modificaciones.Reforma.get(reforma?.id))}">
                                                    <a href="#"  class="btn btn-danger borrar"  reforma="${reforma?.id}" title="Eliminar ajuste">
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

            $(".edit").click(function () {
                var idf = $(this).data("ref");
                location.href = "${createLink(controller: 'ajusteCorriente', action: 'nuevoAjusteCorriente')}?id=" + idf;
            });


        </script>
    </body>
</html>