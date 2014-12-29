<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/11/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Reporte de Asignaciones del Proyecto</title>
    <style type="text/css">
    @page {
        size   : 29.7cm 21cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width : 23.7cm;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        /*height      : 24.7cm; *//*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 9pt;
    }

    table {
        font-size : 9pt;
    }

    .titulo {
        min-height    : 20px;
        font-size     : 16pt;
        /*font-weight   : bold;*/
        text-align    : left;
        margin-bottom : 5px;
        width         : 100%;
        /*border-bottom : solid 1px #000000;*/
    }

    .titulo2 {
        min-height    : 20px;
        font-size     : 12pt;
        /*font-weight   : bold;*/
        text-align    : left;
        margin-bottom : 5px;
        width         : 100%;
        /*border-bottom : solid 1px #000000;*/
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

    /*.odd {*/
        /*background : none repeat scroll 0 0 #E1F1F7;*/
    /*}*/

    /*.even {*/
        /*background : none repeat scroll 0 0 #F5F5F5;*/
    /*}*/

    ol {
        counter-reset : item;
        padding       : 0;
    }

    ol li {
        display       : block;
        margin-bottom : 15px;
    }

    ol li:before {
        content           : counter(item) ". ";
        counter-increment : item;
        font-weight       : bold;
    }

    .table {
        /*border-collapse : collapse;*/
    }

    .center {
        text-align : center;
    }

    .right {
        text-align : right;
    }

    .justificacion {
        border     : solid 1px #000000;
        margin-top : 5px;
        padding    : 10px;
    }

    .firma {
        margin-left : 4cm;
        float       : left;
    }

    .negro {
        background : #000000;
        color      : #f5f5f5;
    }

    .numeracion {
        height : 35px;
    }

    .fright {
        float : right;
    }

    .firmas {
        margin-top  : 2cm;
        width      : 100%;
        height     : 3cm;
    }
    .valor{
        text-align: right;
    }

    td {
        text-align: center;
    }
    </style>
</head>

<body>

<slc:headerReporte title="Reporte de Asignaciones del Proyecto" codigo="FR-PLA-AVAL-02"/>
<div class="titulo2">Año: ${actual?.anio}</div>

<table>
    <thead>
    <tr>
        <th>Proyecto</th>
        <th>Componente</th>
        <th style="text-align: center">#</th>
        <th>Actividad</th>
        <th>Responsable</th>
        <th>Fecha Inicio / Fecha Fin</th>
        <th>Partida</th>
        <th>Presupuesto</th>
        <th>Priorización</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${asignaciones}" var="asg" status="i">
        <g:if test="${asg.planificado>0}">
            <g:if test="${actual?.estado==0}">
                <g:set var="total" value="${total.toDouble()+asg.getValorReal()}"></g:set>
            </g:if>
            <g:else>
                <g:set var="total" value="${total.toDouble()+asg.priorizado}"></g:set>
            </g:else>
        </g:if>
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}"  style='${(asg.reubicada=='S')?"background: #d5f0d4":""}'>
            <td class="dscr" style="width: 150px; text-align: left">
                ${asg.marcoLogico.proyecto}
            </td>
            <td class="dscr" style="width: 170px; text-align: left"
                title="${asg.marcoLogico.marcoLogico.toStringCompleto()}">${asg.marcoLogico.marcoLogico}
            </td>
            <td style="width: 20px">
                ${asg.marcoLogico.numero}
            </td>
            <td class="dscr" style="width: 180px;text-align: left" title="${asg.marcoLogico.toStringCompleto()}">
                 ${asg.marcoLogico}
            </td>
            <td style="text-align: left">
                ${asg.unidad}
            </td>
            <td style="width: 80px; text-align: left">
                ${asg.marcoLogico.fechaInicio.format("dd-MM-yyyy")} / ${asg.marcoLogico.fechaFin.format("dd-MM-yyyy")}
            </td>
            <td>
                ${asg.presupuesto.numero}
            </td>
            <td class="valor" style="text-align: right">
                <g:formatNumber number="${asg.getValorReal()}" format="###,##0" minFractionDigits="2"
                                maxFractionDigits="2"/>
            </td>
            <g:if test="${actual.estado==1}">
                <g:if test="${proyecto.aprobadoPoa!='S'}">
                    <td class="valor" style="text-align: right">
                        <div style="width: 150px">
                            <input type="text" style="width: 100px;text-align: right;display: inline-block" id="prio_${asg.id}" value="${asg.priorizado}">
                            %{--<a href="#" style="width: 30px;display: inline-block" class="savePrio" iden="${asg.id}">Guardar</a>--}%
                        </div>
                    </td>
                </g:if><g:else>
                <td class="valor" style="text-align: right">
                    <div style="width: 150px">
                        <g:formatNumber number="${asg.priorizado}" format="###,##0" minFractionDigits="2"
                                        maxFractionDigits="2"/>

                    </div>
                </td>
            </g:else>
            </g:if>
            <td class="agr" style="text-align: right">
                <g:formatNumber number="${asg.priorizado}" format="###,##0" minFractionDigits="2"
                                maxFractionDigits="2"/>
            </td>
        </tr>
    </g:each>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><b>TOTAL</b></td>
        <td class="valor" style="text-align: right; font-weight: bold; border-top : solid 1px #000000;">
            <g:formatNumber number="${total}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
        </td>
    </tr>
    </tbody>

</table>
</body>
</html>