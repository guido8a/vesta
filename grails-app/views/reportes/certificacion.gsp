<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.avales.Aval; vesta.modificaciones.Reforma; vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Aval</title>

        <rep:estilos orientacion="p" pagTitle="Aval de POA"/>

        <style type="text/css">

        .tbl {
            border-collapse : collapse;
        }

        .tbl, .tbl th, .tbl td {
            border : solid 1px #555;
        }

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

        .bold {
            font-weight : bold;
        }

        .tbl2 {
            width           : 60%;
            border-collapse : collapse;
        }

        .tbl2, .tbl2 th, .tbl2 td {
            border : solid 1px transparent;
        }

        .pequena {
            /*font-size: 8px !important;*/
            font-size : 8pt !important;
        }

        .letra {
            font-size: 0.5em !important;
        }

        .ttl {
            font-size       : 9pt;
            font-weight     : bold;
            text-decoration : underline;

        }

        .tbl3 {
            border : solid 1px #ff1e19;
            border-collapse : collapse;
        }


        </style>

    </head>

    <body>
        <div class="hoja">
            <rep:headerFooter title="Aval de POA" unidad="${sol.unidad}"
                              numero="${elm.imprimeNumero(aval: aval?.id)}" anio="${anio}" estilo="right"/>




            <div style="text-align: justify;float: left;font-size: 8pt;">

                <g:if test="${aval?.estado?.codigo == 'E05'}">
                <div style="margin-left: 240px; margin-top: 20px;">
                    <table width="100%" class="tbl3">
                        <tbody>
                        <tr style="border-bottom: transparent; text-align: center">
                            <td>Aval de POA <strong>liberado</strong> mediante solicitud de:</td>
                        </tr>
                        <tr style="border-bottom: hidden; text-align: center">
                            <td>${aval?.contrato}  de ${aval?.fechaLiberacion?.format("dd-MM-yyyy")}.</td>
                        </tr>
                        <tr style="text-align: center">
                            <td>El monto actualizado del Aval POA se determina en USD. <strong>
                                ${vesta.avales.ProcesoAsignacion.findAllByProceso(aval?.proceso).liberado.sum()}</strong></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                </g:if>




                <p>
                    %{--Con solicitud de aval de POA ${anio}-${ua.codigo}  Nro. ${elm.imprimeNumero(solicitud: sol.id)}, de fecha ${sol.fecha.format("dd-MM-yyyy")},--}%
                    Con solicitud de aval de POA ${anio}-${ua.codigo}  Nro. ${elm.imprimeNumero(solicitud: sol.id)}, de fecha ${sol?.firma?.fecha?.format("dd-MM-yyyy")},
                    la ${ua.nombre} solicita emitir el aval de POA para realizar el proceso "${sol.proceso.nombre}",
                    por un monto total de <g:formatNumber number="${sol.monto}" type="currency" currencySymbol="USD "/>
                    (${transf.capitalize()}), con base en cual informo lo siguiente:
                </p>

                <p>
                    Luego de revisar el Plan Operativo Anual ${anio}, la Gerencia de Planificación Estratégica emite el aval a la actividad conforme el siguiente detalle:
                </p>

                <div class="tabla" style="margin-top: 10px">

                    <table width="100%" border="1" class="tbl">
                        <tr>
                            <th style="width: 200px">
                                UNIDAD RESPONSABLE
                            </th>
                            <td>
                                ${ua}
                            </td>
                        </tr>
                        <tr>
                            <th>
                                PROYECTO
                            </th>
                            <td>
                                ${sol.proceso.proyecto.nombre}
                            </td>
                        </tr>
                        <tr>
                            <th>
                                MONTO TOTAL PARA PROCESO
                            </th>
                            <td>
                                <g:formatNumber number="${sol?.monto + devengado}" type="currency" currencySymbol="USD "/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                MONTO TOTAL DEL AVAL
                            </th>
                            <td>
                                <g:formatNumber number="${sol?.monto}" type="currency" currencySymbol="USD "/>
                            </td>
                        </tr>
                    </table>

                    <g:each in="${arr}" var="primero">
                        <table width="100%" border="1" class="tbl" style="margin-top: 15px">
                            <tr>
                                <td style="width:200px; font-weight: bold">COMPONENTE</td>
                                <td>${primero?.key?.marcoLogico}</td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold">ACTIVIDAD</td>
                                <td>${anio} - ${primero?.key?.numero} - ${primero?.key?.objeto}</td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold">CÓDIGO</td>
                                <td>${primero?.key?.marcoLogico?.proyecto?.codigoEsigef} ${primero?.key?.marcoLogico?.numeroComp} ${primero?.key?.numero}</td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold">SUBTOTAL</td>
                                <td><g:formatNumber number="${primero.value.total}" type="currency" currencySymbol="USD "/></td>
                            </tr>
                            <g:if test="${primero.value.devengado != 0 }">
                                <tr>
                                    <td style="font-weight: bold">EJERCICIO ANTERIOR</td>
                                    <td><g:formatNumber number="${primero.value.devengado}" type="currency" currencySymbol="USD "/></td>
                                </tr>
                            </g:if>

                            <g:set var="total" value="${0}"/>

                            <g:each in="${primero.value}" var="segundo">
                                <g:if test="${segundo.key.size() == 4}">
                                    <g:set var="total2" value="${0}"/>
                                    <tr>
                                        <td style="font-weight: bold">
                                            Monto de Aval ${segundo.key}
                                        </td>
                                        <td>
                                            <table class="tbl2">
                                                <g:each in="${segundo.value.asignaciones}" var="tercero">
                                                    <tr>
                                                        <td><strong>Fuente ${tercero.asignacion?.fuente?.codigo},Partida ${tercero?.asignacion?.presupuesto?.numero}:</strong></td>
                                                        <td style="text-align: right;">
                                                            <g:formatNumber number="${tercero.monto ?: 0}" type="currency" currencySymbol="USD "/>
                                                        </td>
                                                    </tr>
                                                </g:each>
                                                <tr>
                                                    <td><strong>Total</strong></td>
                                                    <td style="text-align: right; font-weight: bold">
                                                        <g:formatNumber number="${segundo.value.total}" type="currency" currencySymbol="USD "/>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </g:if>
                            </g:each>
                        </table>
                    </g:each>
                </div>

                <div class="texto">
                    <p>
                        <strong>Nota Técnica:</strong> ${sol?.notaTecnica}
                    </p>
                </div>


                <div %{--class="observaciones"--}%>
                    <span class="ttl">OBSERVACIONES:</span>
                    <p class="letra">
                        ${sol?.observacionesPdf?.replaceAll('&ndash','-')}
                    </p>

                </div>

                <p>
                    Es importante señalar que la Gerencia Administrativa Financiera en el marco de sus competencias verificará la disponibilidad presupuestaria.
                </p>

                <p>
                    <strong>Elaborado por:</strong> ${sol.analista ?
                        (sol.analista.sigla ?: sol.analista.nombre + ' ' + sol.analista.apellido) :
                        (sol.usuario.sigla ?: sol.usuario.nombre + ' ' + sol.usuario.apellido)
                }
                    <span style="float: right"><strong>FECHA:</strong> ${vesta.avales.Aval.get(sol?.aval?.id)?.fechaAprobacion?.format("dd-MM-yyyy")}</span>
                </p>

                %{--<p style="float: right">--}%
                    %{--<strong>FECHA:</strong> ${sol.fecha.format("dd-MM-yyyy")}--}%
                    %{--<strong>FECHA:</strong> ${vesta.avales.Aval.get(sol?.aval?.id)?.fechaAprobacion?.format("dd-MM-yyyy")   ?:   sol.fecha.format("dd-MM-yyyy")}--}%
                %{--</p>--}%

            </div>

            <div style="text-align: justify;float: left;font-size: 10pt;width: 100%">
                <g:if test="${aval}">

                    <table width="100%" style="margin-top: 1.5cm; border: none" border="none">
                        <tr>
                            <g:if test="${aval.firma1?.estado == 'F' && aval.firma2?.estado == 'F'}">
                                <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>

                            <g:if test="${aval.firma1?.estado == 'F' && aval.firma2?.estado != 'F'}">
                                <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                            <g:if test="${aval.firma2?.estado == 'F' && aval.firma1?.estado != 'F'}">
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                        </tr>
                    </table>


                    <table width="100%" style="margin-top: 1.5cm; border: none" border="none">
                        <tr>
                            <td width="50%" style=" text-align: center;border: none">
                                <g:if test="${aval.firma1?.estado == 'F'}">
                                    <img src="${resource(dir: 'firmas', file: aval.firma1.path)}" style="width: 150px;"/><br/>
                                    ${aval.firma1.usuario.nombre} ${aval.firma1.usuario.apellido}<br/>
                                    %{--<b>${aval.firma1.usuario.cargoPersonal}<br/></b>--}%
                                    <b>${aval.firma1.usuario.cargo}<br/></b>
                                </g:if>
                            </td>
                            <td width="50%" style=" text-align: center;;border: none">
                                <g:if test="${aval.firma2?.estado == 'F'}">
                                    <img src="${resource(dir: 'firmas', file: aval.firma2.path)}" style="width: 150px"/><br/>
                                    ${aval.firma2.usuario.nombre} ${aval.firma2.usuario.apellido}<br/>
                                    %{--<b>${aval.firma2.usuario.cargoPersonal}<br/></b>--}%
                                    <b>${aval.firma2.usuario.cargo}<br/></b>
                                </g:if>
                            </td>
                        </tr>
                    </table>
                </g:if>
            </div>
        </div>

    </body>
</html>