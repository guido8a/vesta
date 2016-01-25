<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 08/04/15
  Time: 03:50 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Ajuste del POA</title>
        <rep:estilos orientacion="l" pagTitle="Reforma al POA"/>

        <style type="text/css">
        .table {
            width           : 100%;
            border-collapse : collapse;
        }

        .table, .table th, .table td {
            border : solid 1px #000;
        }

        .table th {
            text-align : center;
            background : #B8CCE4;
        }

        .table td, .table th {
            padding : 5px;
        }

        .table tfoot th {
            background : #008080;
            color      : #fff;
        }

        .firmas {
            width           : 100%;
            margin-top      : 0.5cm;
            border-collapse : collapse;
        }

        .firmas, .firmas th, .firmas td {
            border     : solid 1px transparent;
            text-align : center;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter title="AJUSTE INTERNO DE POA" unidad="${anio}-GPE-AJUSTE" form="GPE-DPI No. 005"
                          numero="${ajuste.numero ?: 0}" estilo="right"/>

        <g:set var="firma1" value="${ajuste.firma1.estado == 'F'}"/>
        <g:set var="firma2" value="${ajuste.firma2.estado == 'F'}"/>

        <g:set var="origenAnterior" value="${ajuste.desde.priorizado}"/>
        <g:set var="destinoAnterior" value="${ajuste.recibe.priorizado}"/>
        <g:set var="origenNuevo" value="${ajuste.desde.priorizado - ajuste.valor}"/>
        <g:set var="destinoNuevo" value="${ajuste.recibe.priorizado + ajuste.valor}"/>

        <g:set var="estado" value="info"/>
        <g:if test="${firma1 && firma2}">
            <g:set var="estado" value="success"/>

            <g:set var="origenNuevo" value="${ajuste.desde.priorizado}"/>
            <g:set var="destinonuevo" value="${ajuste.recibe.priorizado}"/>
            <g:set var="origenAnterior" value="${ajuste.desde.priorizado + ajuste.valor}"/>
            <g:set var="destinoAnterior" value="${ajuste.recibe.priorizado - ajuste.valor}"/>
        </g:if>

        <div style="margin-top: 1cm;">
            <p>
                ${ajuste.textoPdf}
            </p>

            <p>
                Con el propósito de optimizar la ejecución de la Planificación Operativa institucional, agradeceré a la Gerencia Administrativa Financiera efectuar
                los siguientes ajustes presupuestarios sobre el monto priorizado:
            </p>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th>Proyecto</th>
                    <th>Componente</th>
                    <th>Número de la<br/>actividad del<br/>POA</th>
                    <th>Nombre de la actividad</th>
                    <th>Monto<br/>inicial USD</th>
                    <th>Disminución<br/>USD</th>
                    <th>Incremento<br/>USD</th>
                    <th>Monto final<br/>aprobado<br/>USD</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        ${ajuste.desde.marcoLogico.proyecto.toStringCompleto()}
                    </td>
                    <td>
                        ${ajuste.desde.marcoLogico.marcoLogico.numeroComp} - ${ajuste.desde.marcoLogico.marcoLogico}
                    </td>
                    <td>
                        ${ajuste.desde.marcoLogico.numero}
                    </td>
                    <td>
                        ${ajuste.desde.marcoLogico}
                    </td>
                    <td style="text-align: right">
                        <g:formatNumber number="${origenAnterior}" type="currency" currencySymbol=""/>
                    </td>
                    <td style="text-align: right">
                        <g:formatNumber number="${ajuste.valor}" type="currency" currencySymbol=""/>
                    </td>
                    <td></td>
                    <td style="text-align: right">
                        <g:formatNumber number="${origenNuevo}" type="currency" currencySymbol=""/>
                    </td>
                </tr>
                <tr>
                    <td>
                        ${ajuste.recibe.marcoLogico.proyecto.toStringCompleto()}
                    </td>
                    <td>
                        ${ajuste.recibe.marcoLogico.marcoLogico.numeroComp} - ${ajuste.recibe.marcoLogico.marcoLogico}
                    </td>
                    <td>
                        ${ajuste.recibe.marcoLogico.numero}
                    </td>
                    <td>
                        ${ajuste.recibe.marcoLogico}
                    </td>
                    <td style="text-align: right">
                        <g:formatNumber number="${destinoAnterior}" type="currency" currencySymbol=""/>
                    </td>
                    <td></td>
                    <td style="text-align: right">
                        <g:formatNumber number="${ajuste.valor}" type="currency" currencySymbol=""/>
                    </td>
                    <td style="text-align: right">
                        <g:formatNumber number="${destinoNuevo}" type="currency" currencySymbol=""/>
                    </td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4" style="text-align: right">TOTAL</th>
                    <th style="text-align: right">
                        <g:formatNumber number="${origenAnterior + destinoAnterior}" type="currency" currencySymbol=""/>
                    </th>
                    <th style="text-align: right">
                        <g:formatNumber number="${ajuste.valor}" type="currency" currencySymbol=""/>
                    </th>
                    <th style="text-align: right">
                        <g:formatNumber number="${ajuste.valor}" type="currency" currencySymbol=""/>
                    </th>
                    <th style="text-align: right">
                        <g:formatNumber number="${origenNuevo + destinoNuevo}" type="currency" currencySymbol=""/>
                    </th>
                </tr>
            </tfoot>
        </table>

        <p>
            <strong>Observación.-</strong>
        </p>

        <p>
            Es importante señalar que la Gerencia Administrativa Financiera en el marco de sus competencias verificará la disponibilidad presupuestaria.
        </p>

        <table width="100%">
            <tr>
                <td width="50%">
                    <strong>Elaborado por:</strong>
                    ${ajuste.usuario.sigla}
                </td>
                <td width="50%" style="text-align: right">
                    <strong>FECHA:</strong>
                    ${ajuste.fecha.format("dd-MM-yyyy")}
                </td>
            </tr>
        </table>

        <div class="no-break">
            <table class="firmas">
                <tr>
                    <th width="25%"></th>
                    <th width="25%">
                        <g:if test="${firma1}">
                            Revisado por
                        </g:if>
                    </th>
                    <th width="25%">
                        <g:if test="${firma2}">
                            Aprobado por
                        </g:if>
                    </th>
                    <th width="25%"></th>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <g:if test="${firma1}">
                            <img src="${resource(dir: 'firmas', file: ajuste.firma1.path)}" style="width: 150px;"/>
                        </g:if>
                    </td>
                    <td>
                        <g:if test="${firma2}">
                            <img src="${resource(dir: 'firmas', file: ajuste.firma2.path)}" style="width: 150px;"/>
                        </g:if>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <g:if test="${firma1}">
                            ${ajuste.firma1.usuario.nombre} ${ajuste.firma1.usuario.apellido}
                        </g:if>
                    </td>
                    <td>
                        <g:if test="${firma2}">
                            ${ajuste.firma2.usuario.nombre} ${ajuste.firma2.usuario.apellido}
                        </g:if>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <g:if test="${firma1}">
                            %{--${ajuste.firma1.usuario.cargoPersonal?.descripcion}--}%
                            ${ajuste.firma1.usuario.cargo}
                        </g:if>
                    </td>
                    <td>
                        <g:if test="${firma2}">
                            %{--${ajuste.firma2.usuario.cargoPersonal?.descripcion}--}%
                            ${ajuste.firma2.usuario.cargo}
                        </g:if>
                    </td>
                    <td></td>
                </tr>
            </table>
        </div>

    </body>
</html>