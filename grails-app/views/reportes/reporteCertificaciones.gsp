<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Certficaciones en el año ${anio}</title>

    <style type="text/css">
    @page {
        size   : 21cm 29.7cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width : 620px;
    }

    .titulo {
        width : 620px;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height      : 24.7cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 12pt;
    }

    .titulo {
        height        : 40px;
        font-size     : 12pt;
        font-weight   : bold;
        text-align    : center;
        margin-bottom : 5px;
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
    th {
        background : #cccccc;
    }

    tbody tr:nth-child(2n+1) {
        background : none repeat scroll 0 0 #E1F1F7;
    }

    tbody tr:nth-child(2n) {
        background : none repeat scroll 0 0 #F5F5F5;
    }
    </style>

</head>

<body>
<div class="hoja">
    <div class="titulo" style=";margin-right: 10px;">
        Reporte de certificaciones para el ${actual}
    </div>
    <g:set var="total" value="${0}"></g:set>
    <g:if test="${mapa}">
        <g:each in="${mapa}" var="m">
            <g:set var="totalUnidad" value="${0}"></g:set>
            <span style="font-size: 12px;font-weight: bold;">${m.key}</span>
            <fieldset class="ui-corner-all" style="border:1px solid #70B8D6;margin-top:10px;font-weight: bold;width: 600px;font-size: 11px">

                <table style="border-bottom: 10px;width: 600px;font-weight: 200;">
                    <thead>
                    <th>Fecha</th>
                    <th style="width: 120px;">Solicitante</th>
                    <th style="width: 180px;">Concepto</th>
                    <th>Partida</th>
                    <th>Memorando</th>
                    <th>Monto</th>
                    </thead>
                    <tbody>
                    <g:each in="${m.value}" var="cer" status="i">
                        <tr style='background: #${(i%2==0)?"E1F1F7":"F5F5F5"}'>
                            <td>${cer.fechaRevision.format("dd/MM/yyyy")}</td>
                            <td style="width: 120px;">${cer.usuario.persona.nombre+" "+cer.usuario.persona.apellido}</td>
                            <td style="width: 180px;">${cer.concepto}</td>
                            <td style="text-align: center">${cer.asignacion.presupuesto.numero}</td>
                            <td style="text-align: center;width: 150px" >${cer.memorandoCertificado}</td>
                            <td style="text-align: right"><g:formatNumber number="${cer.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <g:set var="totalUnidad" value="${totalUnidad.toDouble()+cer.monto}"></g:set>
                            <g:set var="total" value="${total.toDouble()+cer.monto}"></g:set>
                        </tr>
                    </g:each>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td style="font-weight: bold;">TOTAL</td>
                        <td><g:formatNumber number="${totalUnidad}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    </tr>
                    </tbody>
                </table>
            </fieldset>

        </g:each>
        <span style="font-size: 18px;font-weight: bold;margin-top: 10px;">Total certificado: <g:formatNumber number="${total}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></span>
    </g:if>
    <g:else>
        No hay certificaciones aprobadas para el ${acutal}
    </g:else>

</div>

</body>
</html>