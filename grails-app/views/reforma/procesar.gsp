<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 12:30 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Procesar solicitud de reforma</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'ckeditor.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'adapters/jquery.js')}"></script>

        <style type="text/css">
        .horizontal-container {
            border-bottom : none;
        }
        </style>
    </head>

    <body>

        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <elm:container tipo="horizontal" titulo="Solicitud de reforma a procesar">
            <div class="row">
                <div class="col-md-1 show-label">
                    POA Año
                </div>

                <div class="col-md-1">
                    ${reforma.anio.anio}
                </div>

                <div class="col-md-1 show-label">
                    Total
                </div>

                <div class="col-md-2">
                    <g:formatNumber number="${total}" type="currency"/>
                </div>

                <div class="col-md-1 show-label">
                    Fecha
                </div>

                <div class="col-md-2">
                    <g:formatDate date="${reforma.fecha}" format="dd-MM-yyyy"/>
                </div>
            </div>

            <table class="table table-bordered table-hover table-condensed">
                <thead>
                    <tr>
                        <th>Proyecto</th>
                        <th>Componente</th>
                        <th>Actividad</th>
                        <th>Asignación</th>
                        <th>Valor inicial</th>
                        <th>Disminución</th>
                        <th>Aumento</th>
                        <th>Valor final</th>
                    </tr>
                </thead>
                <tbody>
                    <g:set var="totalInicial" value="${0}"/>
                    <g:set var="totalDisminucion" value="${0}"/>
                    <g:set var="totalAumento" value="${0}"/>
                    <g:set var="totalFinal" value="${0}"/>
                    <g:each in="${detalles}" var="detalle">
                        <g:set var="totalInicial" value="${totalInicial + (detalle.asignacionOrigen.priorizado + detalle.asignacionDestino.priorizado)}"/>
                        <g:set var="totalDisminucion" value="${totalDisminucion + detalle.valor}"/>
                        <g:set var="totalAumento" value="${totalAumento + detalle.valor}"/>
                        <g:set var="totalFinal" value="${totalFinal + ((detalle.asignacionOrigen.priorizado - detalle.valor) + (detalle.asignacionDestino.priorizado + detalle.valor))}"/>
                        <tr class="info">
                            <td>
                                ${detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionOrigen.marcoLogico.numero} - ${detalle.asignacionOrigen.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionOrigen}
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionOrigen.priorizado}" type="currency" currencySymbol=""/>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                            <td></td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionOrigen.priorizado - detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                        <tr class="success">
                            <td>
                                ${detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionDestino.marcoLogico.numero} - ${detalle.asignacionDestino.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionDestino}
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionDestino.priorizado}" type="currency" currencySymbol=""/>
                            </td>
                            <td></td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionDestino.priorizado + detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th class="text-right" colspan="4">TOTAL</th>
                        <th class="text-right">
                            <g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="text-right">
                            <g:formatNumber number="${totalDisminucion}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="text-right">
                            <g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="text-right">
                            <g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>
                        </th>
                    </tr>
                </tfoot>
            </table>
        </elm:container>

        <elm:container tipo="horizontal" titulo="Datos para la generación del documento">
            <div class="row">
                <div class="col-md-1 show-label">Observaciones</div>

                <div class="col-md-11">
                    <g:textArea name="richText" value=""/>
                </div>
            </div>
        </elm:container>

        <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas">
            <div class="row">
                <div class="col-md-3">
                    <g:select from="${personas}" optionKey="id" optionValue="${{
                        it.nombre + ' ' + it.apellido
                    }}" noSelection="['': '- Seleccione -']" name="firma1" class="form-control required input-sm"/>
                </div>

                <div class="col-md-3">

                    <g:select from="${gerentes}" optionKey="id" optionValue="${{
                        it.nombre + ' ' + it.apellido
                    }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
                </div>
            </div>
        </elm:container>

        <script type="text/javascript">
            $(function () {
                $('#richText').ckeditor(function () { /* callback code */
                        },
                        {
                            customConfig : '${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'config_bullets_only.js')}'
                        });
            });
        </script>

    </body>
</html>