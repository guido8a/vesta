<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/10/11
  Time: 3:50 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.proyectos.ModificacionAsignacion; vesta.poa.Asignacion; vesta.avales.DistribucionAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>
        Reporte de distribuciones
    </title>

    <style type="text/css">
    @page {
        size   : 29.7cm 21cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width : 25.7cm;
    }

    .titulo {
        width : 25.7cm;
        text-align: center;
        font-size: 14px;
        font-weight: bold;
        height: 30px;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height      : 17cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 10pt;
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
<div class="hoja" style="font-size: 12px">

    <div class="titulo" style="margin-bottom: 5px;">Reporte de distribuciones de la unidad ${unidad}</div>

    <div style="width: 955px;height: 40px;border: 1px solid black;margin-top: 5px;line-height: 30px;padding-left: 10px;padding-bottom: 5px;margin-bottom: 10px;margin-top: 5px;">
        <div style="background: #E1F1F7;width: 30px;height: 30px;margin-top: 5px;display: inline-block;border:1px solid #000000"></div> Asignación de origen
        <div style="background: #b9e24b;width: 30px;height: 30px;margin-top: 5px;display: inline-block;border:1px solid #000000;margin-left: 10px"></div> Distribución
        <div style="background: #F5F5F5;width: 30px;height: 30px;margin-top: 5px;display: inline-block;border:1px solid #000000;margin-left: 10px"></div> Asignación dividida
        <div style="background: #eabcb6;width: 30px;height: 30px;margin-top: 5px;display: inline-block;border:1px solid #000000;margin-left: 10px"></div> Asignación con modificaciones
    </div>

    <span style="color: red">Nota:</span> si una asignación ha sido modificada puede alterar el resultado de los totales

    <g:each in="${asgs}" var="asg" status="i">

        <g:set var="dist" value="${DistribucionAsignacion.findAllByAsignacion(asg)}"></g:set>
        <g:if test="${dist}">
            <fieldset style="margin-top: 5px;font-size: 12px;">
                <legend>Asignación #${i+1}</legend>
                <table style="margin-bottom: 15px;font-size: 12px;">
                    <thead>
                    <th class="ui-state-default">ID</th>
                    <th class="ui-state-default">Unidad</th>
                    <th class="ui-state-default">Programa</th>
                    <th class="ui-state-default">Componente</th>
                    <th class="ui-state-default">Actividad</th>
                    <th class="ui-state-default">Partida</th>
                    <th class="ui-state-default">Presupuesto</th>
                    </thead>
                    <tr>
                        <td>${asg.id}</td>
                        <td>${asg.unidad}</td>
                        <td>${(asg.marcoLogico)?asg.marcoLogico.proyecto.programaPresupuestario:asg.programa}</td>
                        <td>${(asg.marcoLogico)?asg.marcoLogico.marcoLogico.objeto:asg.componente}</td>
                        <td>${(asg.marcoLogico)?asg.marcoLogico.objeto:asg.actividad}</td>
                        <td>${asg.presupuesto}</td>
                        <td style="text-align: right">
                            <g:formatNumber number="${asg.getValorReal()}"
                                            format="###,##0"
                                            minFractionDigits="2" maxFractionDigits="2"/>
                        </td>
                    </tr>
                </table>

                <h3>Distribuciones</h3>

                <table style="margin-bottom: 15px;font-size: 12px;">
                    <g:each in="${dist}" var="d">
                        <g:set var="totDist" value="${0}"></g:set>
                        <tr style="background-color: #b9e24b;">
                            <td colspan="6">${d.unidadEjecutora}</td>
                            <td style="text-align: right">
                                <g:formatNumber number="${d.valor}"
                                                format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                        </tr>
                        <g:each in="${Asignacion.findAllByPadreAndUnidadNotEqual(asg,unidad)}" var="hija">
                            <g:set var="mods" value="${ModificacionAsignacion.findAllByDesdeOrRecibe(hija,hija)}"></g:set>
                            <tr style="${(mods)?'background: #eabcb6':'background: #F5F5F5'}">
                                <td>${hija.id}</td>
                                <td>${hija.unidad}</td>
                                <td>${(hija.marcoLogico)?hija.marcoLogico.proyecto.programaPresupuestario:hija.programa}</td>
                                <td>${(hija.marcoLogico)?hija.marcoLogico.marcoLogico.objeto:hija.componente}</td>
                                <td>${(hija.marcoLogico)?hija.marcoLogico.objeto:hija.actividad}</td>
                                <td>${hija.presupuesto}</td>
                                <td style="text-align: right">
                                    <g:formatNumber number="${hija.getValorReal()}"
                                                    format="###,##0"
                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                    <g:set var="totDist" value="${totDist.toDouble()+hija.getValorReal()}"></g:set>
                                </td>
                            </tr>
                            <g:each in="${Asignacion.findAllByPadreAndUnidadNotEqual(hija,unidad)}" var="hija2">
                                <g:set var="mods2" value="${ModificacionAsignacion.findAllByDesdeOrRecibe(hija2,hija2)}"></g:set>
                                <tr style="${(mods)?'background: #eabcb6':'background: #F5F5F5'}">
                                    <td>${hija2.id}</td>
                                    <td>${hija2.unidad}</td>
                                    <td>${(hija2.marcoLogico)?hija2.marcoLogico.proyecto.programaPresupuestario:hija2.programa}</td>
                                    <td>${(hija2.marcoLogico)?hija2.marcoLogico.marcoLogico.objeto:hija2.componente}</td>
                                    <td>${(hija2.marcoLogico)?hija2.marcoLogico.objeto:hija2.actividad}</td>
                                    <td>${hija2.presupuesto}</td>
                                    <td style="text-align: right">
                                        <g:formatNumber number="${hija2.getValorReal()}"
                                                        format="###,##0"
                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                        <g:set var="totDist" value="${totDist.toDouble()+hija2.getValorReal()}"></g:set>
                                    </td>
                                </tr>
                                <g:each in="${Asignacion.findAllByPadreAndUnidadNotEqual(hija2,unidad)}" var="hija3">
                                    <g:set var="mods3" value="${ModificacionAsignacion.findAllByDesdeOrRecibe(hija3,hija3)}"></g:set>
                                    <tr style="${(mods)?'background: #eabcb6':'background: #F5F5F5'}">
                                        <td>${hija3.id}</td>
                                        <td>${hija3.unidad}</td>
                                        <td>${(hija3.marcoLogico)?hija3.marcoLogico.proyecto.programaPresupuestario:hija3.programa}</td>
                                        <td>${(hija3.marcoLogico)?hija3.marcoLogico.marcoLogico.objeto:hija3.componente}</td>
                                        <td>${(hija3.marcoLogico)?hija3.marcoLogico.objeto:hija3.actividad}</td>
                                        <td>${hija3.presupuesto}</td>
                                        <td style="text-align: right">
                                            <g:formatNumber number="${hija3.getValorReal()}"
                                                            format="###,##0"
                                                            minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="totDist" value="${totDist.toDouble()+hija3.getValorReal()}"></g:set>
                                        </td>
                                    </tr>
                                </g:each>
                            </g:each>
                        </g:each>
                        <tr style="font-weight: bold;background: #E1F1F7">
                            <td></td>
                            <td>Distribuido:</td>
                            <td style="text-align: right">
                                <g:formatNumber number="${d.valor}"
                                                format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            <td>Usado</td>
                            <td style="text-align: right">
                                <g:formatNumber number="${totDist}"
                                                format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            <td>Saldo</td>
                            <td style="text-align: right">
                                <g:formatNumber number="${d.valor-totDist}"
                                                format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                        </tr>
                    </g:each>
                </table>

            </fieldset>
        </g:if>
    </g:each>

</div>
</body>
</html>