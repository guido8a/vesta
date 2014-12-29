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
    <title>Modificaciones al P.A.C unidad: ${unidad}, año:${actual}</title>

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
        Reporte de modificaciones al P.A.C. de la unidad: ${unidad}, año:${actual}
    </div>
    <g:set var="total" value="${0}"></g:set>
    <g:if test="${res}">
        <g:each in="${res}" var="pac">
            <g:set var="totalObra" value="${0}"></g:set>
            <g:set var="mod" value="${yachay.proyectos.ModificacionV2.findAllByDominioAndId_remoto('Obra',pac.id.toInteger())}"></g:set>
            <g:if test="${mod}">
                <table style="margin-top: 40px;" width="600px">
                    <thead>


                    <th width="155" style="font-size: 10px">Descripción</th>
                    <th width="60" style="font-size: 10px">Unidad</th>
                    <th width="60" style="font-size: 10px">Codigo CPC</th>
                    <th width="50" style="font-size: 10px">Tipo</th>
                    <th width="50" style="font-size: 10px">Cant.</th>
                    <th width="78" style="font-size: 10px">Costo</th>
                    <th width="22" style="font-size: 10px">C1</th>
                    <th width="22" style="font-size: 10px">C2</th>
                    <th width="22" style="font-size: 10px">C3</th>
                    </thead>
                    <tbody>


                    <tr class="even">


                        <td style="font-size: 10px">
                            ${pac.asignacion.actividad} (${pac.asignacion.presupuesto.numero})
                        </td>


                        <td class="unidad" style="font-size: 10px">
                            ${pac.unidad}

                        </td>

                        <td class="cp" style="font-size: 10px">
                            ${pac.codigoComprasPublicas.numero}
                        </td>

                        <td class="tipo" style="font-size: 10px">
                            ${pac.tipoCompra}
                        </td>

                        <td class="cantidad" style="width: 35px;text-align: right">
                            ${g.formatNumber(number: pac.cantidad, format: '###,##0', maxFractionDigits: 2, minFractionDigits: 2)}
                        </td>

                        <td class="costo" style="text-align: right">

                                   ${g.formatNumber(number: pac.costo, format: '###,##0', maxFractionDigits: 2, minFractionDigits: 2)}
                        </td>

                        <td class="ctr1">
                           ${(pac.cuatrimestre1 == "1") ? "Si" : "No"}
                        </td>

                        <td class="ctr2">
                            ${(pac.cuatrimestre2 == "1") ? "Si" : "No"}
                        </td>

                        <td class="ctr3">
                             ${(pac.cuatrimestre3 == "1") ? "Si" : "No"}
                        </td>


                    </tr>


                    </tbody>
                </table>
                <fieldset class="ui-corner-all" style="border:1px solid #70B8D6;margin-top:10px;font-weight: bold;width: 600px;font-size: 11px">

                    <table style="border-bottom: 10px;width: 600px;font-weight: 200;font-size: 11px">
                        <thead>
                        <th>Fecha</th>
                        <th>Usuario</th>
                        <th style="width: 120px;">Campo</th>
                        <th style="width: 180px;">Valor original</th>
                        <th>Valor nuevo</th>
                        </thead>
                        <tbody>

                        <g:each in="${mod}" var="m">
                            <tr>
                                <td style="text-align: center">${m.fecha.format("dd/MM/yyyy")}</td>
                                <td>${m.usuario.persona.nombre+" "+m.usuario.persona.apellido}</td>
                                <td style="text-align: center">${m.campo}</td>
                                <td style="text-align: right"><tdn:mostrarCampoModificacion id="${m.id}" campo="oldValue"></tdn:mostrarCampoModificacion></td>
                                <td style="text-align: right"><tdn:mostrarCampoModificacion id="${m.id}" campo="newValue"></tdn:mostrarCampoModificacion></td>
                            </tr>
                        </g:each>

                        </tbody>
                    </table>
                </fieldset>
            </g:if>
        </g:each>
    </g:if>
    <g:else>
        No hay modificaciones para este periodo
    </g:else>

</div>

</body>
</html>