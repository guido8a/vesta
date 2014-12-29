<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/08/14
  Time: 04:23 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Imprimir acta</title>
    <style type="text/css">
    @page {
        size   : 21cm 29.7cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width     : 15cm;
        font-size : 12pt;
    }

    .titulo {
        width : 15.5cm;
    }

    .hoja {
        /*background  : #fedcba;*/
        height      : 24.7cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 10pt;
    }

    .titulo {
        height        : 130px;
        font-size     : 12pt;
        /*font-weight   : bold;*/
        text-align    : center;
        margin-bottom : 5px;
        width         : 95%;
    }

    .totales {
        font-weight : bold;
    }

    .num {
        text-align : right;
    }

    .header {
        background : #333333 !important;
        color      : #AAAAAA;
    }

    .total {
        background : #000000 !important;
        color      : #FFFFFF !important;
    }

    .label {
        font-weight : bold;
    }

    .ui-widget-header {
        font-weight : bold;
    }

    .ttl {
        text-align  : center;
        font-weight : bold;
    }

    .numeracion {
        float   : right;
        /*background : #bbb;*/
        padding : 7px;
    }

    .tbl {
        border-collapse : collapse;
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
    </style>
</head>

<body>
<div class="hoja">
    <slc:headerReporte title="Solicitud de Aval de POA"/>

    <div style="width: 100%; height: 1.5cm;">
        <div class="numeracion">
            Numeración: ${solicitud.unidad?.codigo}-${solicitud.numero}
        </div>
    </div>

    <div class="texto">
        Con el propósito de ejecutar las actividades programadas en la planificación operativa institucional
        ${solicitud.proceso.fechaInicio?.format("yyyy")}, la Gerencia de "${solicitud.usuario.unidad}"
        solicita emitir el Aval de POA correspondiente al proceso que se detalla a continuación:
    </div>

    <div class="tabla" style="margin-top: 10px">
        <table width="100%" border="1" class="tbl">
            <tr>
                <th>
                    Unidad requirente: (Gerencia - Dirección)
                </th>
                <td colspan="2">
                    ${solicitud.usuario.unidad}
                </td>
            </tr>

            <tr>
                <th>
                    Proyecto:
                </th>
                <td colspan="2">
                    ${solicitud.proceso.proyecto.nombre}
                </td>
            </tr>
            <tr>
                <th>
                    Nombre del proceso:
                </th>
                <td colspan="2">
                    ${solicitud.proceso.nombre}
                </td>
            </tr>
            <tr>
                <th>
                    Valor total del proceso:
                </th>
                <td colspan="2">
                    $ <g:formatNumber number="${solicitud.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber>
                </td>
            </tr>
        </table>

        <g:each in="${yachay.avales.ProcesoAsignacion.findAllByProceso(solicitud.proceso)}" var="pa">
        %{--<tr>--}%
        %{--<td style="font-weight: bold">Unidad responsable</td>--}%
        %{--<td>${pa.asignacion.unidad}</td>--}%
        %{--</tr>--}%
            <table  width="100%" border="1" class="tbl" style="margin-top: 15px">
                <tr>
                    <td style="font-weight: bold">Componente</td>
                    <td colspan="2">${pa.asignacion.marcoLogico.marcoLogico}</td>
                </tr>
                %{--<tr>--}%
                %{--<td style="font-weight: bold">Número de la actividad</td>--}%
                %{--<td>${pa.asignacion.marcoLogico.numero} (${anio})</td>--}%
                %{--</tr>--}%
                <tr>
                    <td style="font-weight: bold">Actividad</td>
                    <td colspan="2">${pa.asignacion.marcoLogico.numero} - ${pa.asignacion.marcoLogico}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">Partida</td>
                    <td colspan="2">${pa.asignacion.presupuesto.numero}</td>
                </tr>
                <tr>
                    <th>

                    </th>
                    <td class="bold" colspan="2" style="text-align: center">
                        Total Plurianual
                    </td>
                </tr>
                <tr>
                    <th>
                        Año:
                    </th>
                    <td>
                        ${solicitud.proceso.fechaInicio?.format("yyyy")}
                    </td>
                    <td>
                        $<g:formatNumber number="${pa.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber>
                    </td>
                </tr>
                <tr>
                    <th>
                        Fecha de inicio:
                    </th>
                    <td colspan="2">
                        ${pa.asignacion.marcoLogico.fechaInicio?.format("dd-MM-yyyy")}
                    </td>

                </tr>
                <tr>
                    <th>
                        Fecha fin actividad:
                    </th>
                    <td colspan="2">
                        ${pa.asignacion.marcoLogico.fechaFin?.format("dd-MM-yyyy")}
                    </td>

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
    <div class="texto">
        Elaborado por: ${solicitud?.usuario?.sigla}
    </div>
    <g:if test="${solicitud.firma.estado=='F'}">
        <table width="100%" style="margin-top: 1.5cm;">
            <td width="33%" style=" text-align: center;">
                <img src="${resource(dir: 'firmas',file: solicitud.firma.path)}"/><br/>
                ${solicitud.firma.usuario.persona.nombre} ${solicitud.firma.usuario.persona.apellido}<br/>
                ${solicitud.firma.usuario.cargoPersonal}<br/>
                ${solicitud.firma.fecha.format("dd-MM-yyyy hh:mm")}
            </td>
            <td width="33%" style=" text-align: center;"></td>
            <td width="33%" style=" text-align: center;"></td>
        </table>
    </g:if>
</div>
</body>
</html>