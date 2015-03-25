<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/08/14
  Time: 04:23 PM
--%>

<%@ page import="vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Imprimir acta</title>
    <rep:estilos orientacion="p" pagTitle="Solicitud de Aval de POA"/>
    <style type="text/css">

    .tbl {
        border-collapse : collapse;
    }

    .tbl, .tbl th, .tbl td {
        border: solid 1px #555;
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
        width: 50%;
        border-collapse: collapse;
    }
    .tbl2, .tbl2 th, .tbl2 td {
        border: solid 1px transparent;
    }
    </style>
</head>

<body>
<rep:headerFooter title="Solicitud de Aval de POA" unidad="${solicitud.fecha.format('yyyy')}-${solicitud.unidad?.codigo}"
                  numero="${elm.imprimeNumero(solicitud: solicitud.id)}"/>

<p>
    Con el propósito de ejecutar las actividades programadas en la planificación operativa institucional
    ${solicitud.proceso.fechaInicio?.format("yyyy")}, la ${solicitud.usuario.unidad}
    solicita emitir el Aval de POA correspondiente al proceso que se detalla a continuación:
</p>

<div class="tabla" style="margin-top: 10px">
    <table width="100%" border="1" class="tbl">
        <tr>
            <th>
                UNIDAD REQUIRENTE:
            </th>
            <td>
                ${solicitud.usuario.unidad}
            </td>
        </tr>

        <tr>
            <th>
                PROYECTO:
            </th>
            <td>
                ${solicitud.proceso.proyecto.nombre}
            </td>
        </tr>
        <tr>
            <th>
                PROCESO:
            </th>
            <td>
                ${solicitud.proceso.nombre}
            </td>
        </tr>
        <tr>
            <th>
                FECHA DE INICIO: ${solicitud?.proceso?.fechaInicio?.format("dd-MM-yyyy")}
            </th>
            <td>
                FECHA DE FIN: ${solicitud?.proceso?.fechaFin?.format("dd-MM-yyyy")}
            </td>
        </tr>
        <tr>
            <th>
                MONTO TOTAL SOLICITADO:
            </th>
            <td>
                <g:formatNumber number="${solicitud.monto}" type="currency" currencySymbol=""/>
            </td>
        </tr>
    </table>

%{--<g:each in="${ProcesoAsignacion.findAllByProceso(solicitud.proceso)}" var="pa">--}%
%{--<table width="100%" border="1" class="tbl" style="margin-top: 15px">--}%
%{--<tr>--}%
%{--<td style="font-weight: bold">COMPONENTE</td>--}%
%{--<td>${pa.asignacion.marcoLogico.marcoLogico.toStringCompleto()}</td>--}%
%{--</tr>--}%
%{--<tr>--}%
%{--<td style="font-weight: bold">ACTIVIDAD</td>--}%
%{--<td>${pa.asignacion.marcoLogico.numero} - ${pa.asignacion.marcoLogico?.toStringCompleto()}</td>--}%
%{--</tr>--}%
%{--<tr>--}%
%{--<td style="font-weight: bold">CÓDIGO</td>--}%
%{--<td>${pa.asignacion.marcoLogico.marcoLogico.proyecto.codigo} - ${pa.asignacion.marcoLogico.marcoLogico.numeroComp} - ${pa.asignacion.presupuesto.numero}</td>--}%
%{--</tr>--}%


%{--<tr>--}%

%{--</tr>--}%

%{--</table>--}%
%{--</g:each>--}%

    <g:each in="${arr}" var="primero">

        <table width="100%" border="1" class="tbl" style="margin-top: 15px">
            <tr>
                <td style="width:150px; font-weight: bold">COMPONENTE</td>
                <td>${primero?.key?.marcoLogico}</td>
            </tr>
            <tr>
                <td style="font-weight: bold">ACTIVIDAD</td>
                <td> ${primero?.key?.numero} - ${primero?.key?.objeto}</td>
            </tr>
            <tr>
                <td style="font-weight: bold">CÓDIGO</td>
                <td>${primero?.key?.marcoLogico?.proyecto?.codigo} - ${primero?.key?.marcoLogico?.numeroComp} - ${primero?.key.numero}</td>
            </tr>

            <g:set var="total" value="${0}"/>

            <g:each in="${primero.value}" var="segundo">
                <g:set var="total2" value="${0}"/>
                <tr>
                    <td style="font-weight: bold">
                        ${segundo.key}
                    </td>
                    <td>
                        <table class="tbl2">
                            <g:each in="${segundo.value}" var="tercero">
                                <tr>
                                    <g:set var="total2" value="${total2+(tercero.monto?:0)}"/>
                                    <g:set var="total" value="${total+(tercero.monto?:0)}"/>
                                    <td width="35%"><strong>Fuente ${tercero.asignacion?.fuente?.codigo}:</strong></td>
                                    <td style="text-align: right;"><g:formatNumber number="${tercero.monto?:0}" type="currency" /></td>
                                </tr>
                            </g:each>
                            <tr>
                                <td><strong>Total</strong></td>
                                <td style="text-align: right; font-weight: bold"><g:formatNumber number="${total2}" type="currency" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </g:each>
            <tr>
                <td style="font-weight: bold">MONTO TOTAL AVALADO</td>
                <td><g:formatNumber number="${total}" type="currency" /></td>
            </tr>
        </table>

    </g:each>

</div>

<div class="texto">
    <p>
        <strong>Nota Técnica:</strong> El monto solicitado incluye el Impuesto al Valor Agegado IVA 12%.
    </p>

    <p>
        <strong>FECHA: ${solicitud.fecha.format("dd-MM-yyyy")}</strong>
    </p>
</div>

<div class="no-break">
    <div class="texto">
        Elaborado por: ${solicitud?.usuario?.sigla}
    </div>
    <g:if test="${solicitud.firma?.estado == 'F'}">
        <table width="100%" style="margin-top: 1.5cm;">
            <tr>
                <td width="33%" style=" text-align: center;">
                    <img src="${resource(dir: 'firmas', file: solicitud.firma.path)}" style="width: 150px;"/><br/>
                    ${solicitud.firma.usuario.nombre} ${solicitud.firma.usuario.apellido}<br/>
                    ${solicitud.firma.usuario.cargoPersonal}<br/>
                    ${solicitud.firma.fecha.format("dd-MM-yyyy hh:mm")}
                </td>
                <td width="33%" style=" text-align: center;"></td>
                <td width="33%" style=" text-align: center;"></td>
            </tr>
        </table>
    </g:if>
</div>

</body>
</html>