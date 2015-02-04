<%@ page import="vesta.proyectos.MetaBuenVivirProyecto; vesta.proyectos.PoliticasAgendaProyecto" %>

<div class="titulo">
    Resumen del proyecto
</div>

<g:each in="${proyectos}" var="proyecto">
    <g:set var="proy" value="${proyecto.proyecto}"/>
    <div class="proyecto">
        <table border="0" width="100%" class="tabla">
            <tr>
                <th colspan="4" class="nombreArea">
                    Datos Generales del proyecto
                </th>
            </tr>
            <tr>
                <th width="15%" class="etiqueta">Nombre</th>
                <td width="85%" colspan="3" class="cont">${proy.nombre}</td>
            </tr>

            <tr>
                <th class="etiqueta">CUP</th>
                <td class="cont" width="250">${proy.codigoProyecto}</td>

                <th class="etiqueta">Aprobado</th>
                <td class="cont">${(proy.aprobado == "a") ? "Si" : "No"}</td>
            </tr>

            <tr>
                <th class="etiqueta">Unidad Ejecutora</th>
                <td class="cont">${proy?.unidadEjecutora}</td>

                <th class="etiqueta">Programa presupuestario</th>
                <td class="cont">${fieldValue(bean: proy, field: "programaPresupuestario")}</td>
            </tr>

            <tr>
                <th class="etiqueta">Monto</th>
                <td class="cont">${fieldValue(bean: proy, field: "monto")}</td>

                <th class="etiqueta">Cobertura</th>
                <td class="cont">${proy?.cobertura}</td>
            </tr>

            <tr>
                <th class="etiqueta">Fecha inicio planificada</th>
                <td class="cont"><g:formatDate date="${proy?.fechaInicioPlanificada}"
                                               format="dd-MM-yyyy"/></td>

                <th class="etiqueta">Fecha Inicio</th>
                <td class="cont"><g:formatDate date="${proy?.fechaInicio}" format="dd-MM-yyyy"/></td>
            </tr>

            <tr>
                <th class="etiqueta">Fecha fin planificada</th>
                <td class="cont"><g:formatDate date="${proy?.fechaFinPlanificada}"
                                               format="dd-MM-yyyy"/></td>

                <th class="etiqueta">Fecha Fin</th>
                <td class="cont"><g:formatDate date="${proy?.fechaFin}" format="dd-MM-yyyy"/></td>
            </tr>

            <tr>
                <th class="etiqueta">Eje Programático</th>
                <td colspan="3" class="cont">${fieldValue(bean: proy, field: "ejeProgramatico")}</td>
            </tr>

            <tr>
                <th class="etiqueta">Línea</th>
                <td colspan="3" class="cont">${proy?.linea}</td>
            </tr>

            <tr>
                <th colspan="4" class="nombreArea">
                    Información Narrativa del Proyecto
                </th>
            </tr>
            <tr>
                <th class="etiqueta">Descripción</th>
                <td colspan="3">${proy.descripcion}</td>
            </tr>
            <tr>
                <th class="etiqueta">Problema</th>
                <td colspan="3">${proy.problema}</td>
            </tr>

            <tr>
                <th colspan="4" class="nombreArea">
                    Políticas
                </th>
            </tr>
            <g:each in="${proyecto.politicas}" var="politica" status="i">
                <tr>
                    <td colspan="4">
                        ${politica.politica.descripcion}
                    </td>
                </tr>
            </g:each>

            <tr>
                <th colspan="4" class="nombreArea">
                    Políticas de agenda social
                </th>
            </tr>
            <g:each in="${PoliticasAgendaProyecto.findAllByProyecto(proy)}" status="i" var="plas">
                <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                    <td colspan="4">
                        ${plas.politicaAgendaSocial.descripcion}
                    </td>
                </tr>
            </g:each>

            <tr>
                <th colspan="4" class="nombreArea">
                    Financiamiento
                </th>
            </tr>
            <tr>
                <td colspan="4" style="background: white;">
                    <center>
                        <table>
                            <thead>
                                <tr style="padding: 5px;">
                                    <th style="padding: 5px;" class="ui-corner-tl" width="320px;">
                                        Fuente
                                    </th>
                                    <th style="padding: 5px;" class="" width="120px;">
                                        Monto
                                    </th>
                                    <th style="padding: 5px;" class="ui-cornet-tr" width="120px;">
                                        Porcentaje
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:set var="suma" value="${0}"/>
                                <g:set var="prct" value="${0}"/>
                                <g:each in="${proyecto.financiamientos}" status="i" var="fin">
                                    <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                                        <td fuente="${fin.fuente.id}" tipo="descripcion">
                                            ${fin.fuente.descripcion}
                                        </td>
                                        <td style="text-align: right;" fuente="${fin.fuente.id}"
                                            tipo="monto">

                                            <g:formatNumber number="${fin.monto}" format="###,##0"
                                                            minFractionDigits="2" maxFractionDigits="2"/>

                                            <g:set var="suma" value="${suma + fin.monto}"/>
                                        </td>
                                        <td style="text-align: right;" fuente="${fin.fuente.id}"
                                            tipo="porcentaje">

                                            <g:set var="finPorcentaje"
                                                   value="${(fin.monto * 100) / proy.monto}"/>
                                            <g:formatNumber number="${finPorcentaje/100}" type="percent"
                                                            minFractionDigits="2"
                                                            maxFractionDigits="2"/>

                                            <g:set var="prct" value="${prct+ finPorcentaje}"/>
                                        </td>
                                    </tr>
                                </g:each>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th class="ui-corner-bl" style="font-weight: bold;">
                                        TOTAL
                                    </th>
                                    <th class="" style="text-align: right; font-weight: bold;">
                                        <span id="spanSuma">
                                            <g:formatNumber number="${suma}" format="###,##0"
                                                            minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                    </th>
                                    <th class="ui-corner-br" style="text-align: right; font-weight: bold;">
                                        <span id="spanPrct">
                                            <g:formatNumber number="${prct/100}" type="percent"
                                                            minFractionDigits="2"
                                                            maxFractionDigits="2"/>
                                        </span>
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </center>
                </td>
            </tr>

            <tr>
                <th colspan="4" class="nombreArea">
                    Buen Vivir
                </th>
            </tr>
            <tr>
                <td colspan="4" style="background: white;">
                    <center>
                        <table>
                            <thead>
                                <tr style="padding: 5px;">
                                    <th style="padding: 5px;" class="head ui-corner-tl" width="310px;">
                                        Objetivo
                                    </th>
                                    <th style="padding: 5px;" class="head " width="310px;">
                                        Política
                                    </th>
                                    <th style="padding: 5px;" class="head ui-corner-tr" width="310px;">
                                        Meta
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:set var="suma" value="${0}"/>
                                <g:set var="prct" value="${0}"/>
                                <g:each in="${MetaBuenVivirProyecto.findAllByProyecto(proy)}" status="i" var="meta">
                                    <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                                        <td>
                                            ${meta.metaBuenVivir.politica.objetivo.descripcion}
                                        </td>
                                        <td style="text-align: right;">
                                            ${meta.metaBuenVivir.politica.descripcion}
                                        </td>
                                        <td style="text-align: right;">
                                            ${meta.metaBuenVivir.descripcion}
                                        </td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </center>
                </td>
            </tr>
        </table>
    </div>
</g:each>