<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Solicitudes de la unidad ${unidad}</title>

    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="fila">

        </div>

        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="reforma" action="reformas" class="btn btn-default button"><i class="fa fa-gavel"></i> Solicitar</g:link>
            </div>
        </div>

        <div id="historial" style="width: 1030px;">
            <table class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                    <tr>
                        <th># Sol.</th>
                        <th>Unidad</th>
                        <th>Proyecto</th>
                        <th>Concepto</th>
                        <th>Estado</th>
                        <th>Solicitud</th>
                        <th>Matriz</th>
                        <th>Reforma</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${sols}" var="p">
                        <tr data-id="${p.id}">
                            <td>${p.id}</td>
                            <td>${p.usuario.unidad}</td>
                            <td title="${p.origen.marcoLogico.proyecto.toStringCompleto()}">${p.origen.marcoLogico.proyecto}</td>
                            <td>${p.concepto}</td>
                            %{--<td style="text-align: right"> <g:formatNumber number="${p.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>--}%
                            <td style="text-align: center" class="${(p.estado == 0 || p.estado == 4) ? 'solicitado' : (p.estado == 1 || p.estado == 3 || p.estado == 5) ? 'aprobado' : 'negado'}">
                                <g:if test="${p.estado == 0}">
                                    Solicitado
                                </g:if>
                                <g:if test="${p.estado == 4}">
                                    Solicitado sin firmas
                                </g:if>
                                <g:if test="${p.estado == 1 || p.estado == 3}">
                                    Aprobado
                                </g:if>
                                <g:if test="${p.estado == 2}">
                                    Negado
                                </g:if>
                                <g:if test="${p.estado == 5}">
                                    Aprobado sin firmas
                                </g:if>
                            </td>
                            <td style="text-align: center">
                                <a href="#" class="btn imprimiSolicitud btn-sm btn-info" iden="${p.id}"><i class="fa fa-print"></i> Ver
                                </a>
                            </td>
                            <td style="text-align: center">
                                <a href="#" class="btn matriz btn-sm btn-info" iden="${p.id}"><i class="fa fa-print"></i>Ver
                                </a>
                            </td>
                            <td style="text-align: center">
                                <g:if test="${p.estado == 3 || p.estado == 5}">
                                    <a href="#" class="btn reforma btn-info btn-sm" iden="${p.id}"><i class="fa fa-print"></i> Ver
                                    </a>
                                </g:if>
                            </td>
                        </tr>
                    </g:each>

                </tbody>
            </table>
        </div>


        <script>
            %{--$("#buscar").button().click(function(){--}%
            %{--cargarHistorial($("#anio").val(),$("#numero").val(),$("#descProceso").val())--}%
            %{--})--}%
            %{--$(".descRespaldo").click(function(){--}%
            %{--location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/"+$(this).attr("iden")--}%

            %{--});--}%
            $(".reforma").click(function () {
                var url = "${g.createLink(controller: 'reporteReformaPoa',action: 'reformaPoa')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=matriz.pdf"
            });
            $(".matriz").click(function () {
                var url = "${g.createLink(controller: 'reporteReformaPoa',action: 'solicitudReformaPoa')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=matriz.pdf"
            });
            $(".imprimiSolicitud").click(function () {
                var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudReformaPdf')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Solicitud.pdf"
            });

            $("tbody>tr").contextMenu({
                items  : {
                    header : {
                        label  : "Acciones",
                        header : true
                    },
                    editar : {
                        label  : "Editar",
                        icon   : "fa fa-pencil",
                        action : function ($element) {
                            var id = $element.data("id");
                            location.href = "${createLink(controller: 'modificacionesPoa', action:'modificar')}/" + id;
                        }
                    }
                },
                onShow : function ($element) {
                    $element.addClass("success");
                },
                onHide : function ($element) {
                    $(".success").removeClass("success");
                }
            });


        </script>
    </body>
</html>