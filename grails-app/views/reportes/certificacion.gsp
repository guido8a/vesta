<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Aval</title>

        <rep:estilos orientacion="p" pagTitle="Aval de POA"/>

        <style type="text/css">

        .tbl th {
            /*background  : #bbb;*/
            font-weight : bold;
            text-align  : left;
            width       : 5cm;
        }

        .tbl td, .tbl th {
            padding-left  : 5px;
            padding-right : 5px;
        }
        </style>

    </head>

    <body>
        <div class="hoja">
            <rep:headerFooter title="Aval de POA" unidad="${anio}-GP"
                              numero="${elm.imprimeNumero(solicitud: sol.id)}"/>

            <div style="text-align: justify;float: left;font-size: 10pt;">
                <p>
                    Con solicitud de aval de POA Nro. ${sol.memo}, con fecha ${sol.fecha.format("dd-MM-yyyy")}, la Gerencia de Planificación solicita un aval para realizar la actividad "${sol.proceso.nombre}",
                    por un monto total de <g:formatNumber number="${sol.monto}" type="currency" currencySymbol=" "/>$, con base en cual informo lo siguiente:
                </p>

                <p>
                    Luego de revisar el Plan Operativo Anual ${anio}, la Gerencia de Planificación emite el aval a la actividad conforme el siguiente detalle:
                </p>
                <table style="width: 100%">
                    <tbody>
                        <tr>
                            <td></td>
                            <td style="font-weight: bold;text-align: center">DETALLE</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;width: 160px !important;">Proyecto</td>
                            <td>${sol.proceso.proyecto}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold">Proceso</td>
                            <td>${sol.proceso.nombre}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold">Monto Total</td>
                            <td>
                                <g:formatNumber number="${sol.monto + ((anterior) ? anterior?.monto : 0)}" type="currency" currencySymbol=" "/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <g:each in="${ProcesoAsignacion.findAllByProceso(sol.proceso)}" var="pa">
                    <table style="width: 100%;margin-top: 15px">
                        <tr>
                            <td style="font-weight: bold;width: 160px !important;">Unidad responsable</td>
                            <td>${pa.asignacion.unidad}</td>
                        </tr>

                        <tr>
                            <td style="font-weight: bold">Componente</td>
                            <td>${pa.asignacion.marcoLogico.marcoLogico}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold">Año</td>
                            <td>${pa.asignacion.anio.anio}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold">Número de la actividad</td>
                            <td>${pa.asignacion.marcoLogico.numero} (${anio})</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold">Código</td>
                            <td>${pa.proceso.proyecto.codigoEsigef} ${pa.asignacion.marcoLogico.marcoLogico.numero} ${pa.asignacion.presupuesto.numero}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold">Actividad</td>
                            <td>${pa.asignacion.marcoLogico}</td>
                        </tr>

                        <tr>
                            <td style="font-weight: bold">Monto solicitado</td>
                            <td><g:formatNumber number="${pa.monto}" type="currency" currencySymbol=" "/></td>
                        </tr>
                    </table>
                </g:each>

                <p style="border: 1px solid black;padding: 5px;font-size: 8px;text-align: left;page-break-inside : avoid;">
                    <b style="text-decoration: underline">OBSERVACIONES:</b><br/>
                    ${sol.observaciones}
                </p>

                <p>
                    Es importante señalar que la Gerencia Administrativa Financiera en el marco de sus competencias verificará la disponibilidad presupuestaria.
                </p>
            </div>

            <div style="text-align: justify;float: left;font-size: 10pt;width: 100%">
                <g:if test="${aval}">

                    <table width="100%" style="margin-top: 1.5cm; border: none" border="none">
                        <tr>
                            <td width="33%" style=" text-align: center;border: none">
                                <g:if test="${aval.firma1?.estado == 'F'}">

                                    <img src="${resource(dir: 'firmas', file: aval.firma1.path)}"/><br/>
                                    ${aval.firma1.usuario.nombre} ${aval.firma1.usuario.apellido}<br/>
                                    ${aval.firma1.usuario.cargoPersonal}<br/>
                                    ${aval.firma1.fecha.format("dd-MM-yyyy hh:mm")}
                                </g:if>
                            </td>
                            <td width="33%" style=" text-align: center;;border: none">
                                <g:if test="${aval.firma2?.estado == 'F'}">

                                    <img src="${resource(dir: 'firmas', file: aval.firma2.path)}"/><br/>
                                    ${aval.firma2.usuario.nombre} ${aval.firma2.usuario.apellido}<br/>
                                    ${aval.firma2.usuario.cargoPersonal}<br/>
                                    ${aval.firma2.fecha.format("dd-MM-yyyy hh:mm")}
                                </g:if>
                            </td>
                            <td width="33%" style=" text-align: center;border: none"></td>
                        </tr>
                    </table>
                </g:if>
            </div>


            %{--<div style="width:6cm; margin-top: 100px;float: left;font-size: 10pt;text-align: center; border-top: solid, 1px #000000;">--}%
            %{--<p>${sol.firma2.persona.nombre} ${sol.firma2.persona.apellido}</p>--}%

            %{--<p>--}%
            %{--<b>Director de Planificación</b>--}%
            %{--</p>--}%
            %{--</div>--}%

            %{--<div style="width:6cm;margin-top: 100px;float: left;font-size: 10pt;margin-left: 3cm;text-align: center;border-top: solid, 1px #000000;">--}%
            %{--<p>${sol.firma3.persona.nombre} ${sol.firma3.persona.apellido}</p>--}%

            %{--<p>--}%
            %{--<b>Gerente de Planificación</b>--}%
            %{--</p>--}%
            %{--</div>--}%

        </div>

    </body>
</html>