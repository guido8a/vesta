<h1>${it.unidad}</h1>

<h2>Inversiones</h2>
<g:if test="${it.programas.size() > 0 && it.programas.proyectos.size() > 0 && it.programas.proyectos.actividades.size() > 0 && it.programas.proyectos.actividades.asignaciones.size() > 0}">
    <g:each in="${it.programas}" var="programaMap">
        <h2>${programaMap.programa}</h2>
        <g:if test="${programaMap.proyectos.size() > 0}">
            <table border="1" width="100%">
                <thead>
                    <tr>
                        <th width="30%">
                            Proyecto
                        </th>
                        <th width="20%">
                            Actividad
                        </th>
                        <th width="20%">
                            Presupuesto
                        </th>
                        %{--<th width="8%">--}%
                        %{--Tipo gasto--}%
                        %{--</th>--}%
                        <th width="12%">
                            Grupo gasto
                        </th>
                        <th width="5%">
                            Monto actividad
                        </th>
                        <th width="5%">
                            Asignación
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <g:if test="${programaMap.proyectos.size() > 0 && programaMap.proyectos.actividades.size() > 0 && programaMap.proyectos.actividades.asignaciones.size() > 0}">
                        <g:each in="${programaMap.proyectos}" var="proyectoMap">
                            <g:each in="${proyectoMap.actividades}" var="actividadMap">
                                <g:each in="${actividadMap.asignaciones}" var="asignacion">
                                    <tr>
                                        <td>
                                            ${proyectoMap.proyecto.nombre}
                                        </td>

                                        <td>
                                            ${actividadMap.actividad}
                                        </td>

                                        <td>
                                            ${asignacion.presupuesto?.descripcion}
                                        </td>

                                        %{--<td>--}%
                                        %{--${asignacion.tipoGasto}--}%
                                        %{--</td>--}%

                                        <td>
                                            ${asignacion.presupuesto?.presupuesto?.descripcion}
                                        </td>

                                        <td style="text-align: right;">
                                            <g:formatNumber number="${actividadMap.actividad.monto}"
                                                            format="###,##0"
                                                            minFractionDigits="2"
                                                            maxFractionDigits="2"/>
                                        </td>

                                        <td style="text-align: right;">
                                            <g:formatNumber number="${asignacion.planificado}"
                                                            format="###,##0"
                                                            minFractionDigits="2"
                                                            maxFractionDigits="2"/>
                                        </td>
                                    </tr>
                                </g:each>
                            </g:each>
                        </g:each>
                    </g:if>
                    <g:else>
                        No se encontraron datos
                    </g:else>
                </tbody>
            </table>
        </g:if>
        <g:else>
            No se encontraron datos
        </g:else>
    </g:each>
</g:if>
<g:else>
    No se encontraron datos
</g:else>


<h2>Corrientes</h2>
<g:if test="${it.corrientes.size() > 0}">
    <table border="1" width="100%">
        <thead>
            <tr>
                <th width="15%">
                    Programa
                </th>
                <th width="20%">
                    Actividad
                </th>
                <th width="15%">
                    Meta
                </th>
                <th width="15%">
                    Indicador
                </th>
                <th width="15%">
                    Partida
                </th>
                %{--<th width="8%">--}%
                %{--Tipo gasto--}%
                %{--</th>--}%
                <th width="12%">
                    Fuente
                </th>
                <th width="5%">
                    Presupuesto
                </th>
            </tr>
        </thead>
        <tbody>
            <g:set var="total" value="${0}"/>
            <g:each in="${it.corrientes}" var="asig">
                <g:set var="asignacion" value="${asig.asignacion}"/>
                <tr class="${asignacion.id}">
                    <td>
                        ${asignacion.programa}
                    </td>

                    <td>
                        ${asignacion.actividad}
                    </td>

                    <td>
                        ${asignacion.meta}
                    </td>

                    <td>
                        ${asignacion.indicador}
                    </td>

                    <td>
                        ${asignacion.presupuesto?.numero}. ${asignacion.presupuesto?.descripcion}
                    </td>

                    %{--<td>--}%
                    %{--${asignacion.tipoGasto}--}%
                    %{--</td>--}%

                    <td>
                        ${asignacion.fuente.descripcion}
                    </td>

                    <td style="text-align: right;">
                        <g:set var="ta" value="${asignacion.planificado + asig.desde - asig.hasta}" />
                        <g:formatNumber number="${ta}"
                                          format="###,##0"
                                          minFractionDigits="2"
                                          maxFractionDigits="2"/>
                        <g:set var="total" value="${total + ta}"/>
                    </td>
                </tr>
            </g:each>
        </tbody>
        <tfoot>
            <tr>
                <th colspan="6" style="text-align: right;">
                    TOTAL
                </th>
                <th style="text-align: right;">
                    <g:formatNumber number="${total}"
                                    format="###,##0"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"/>
                </th>
            </tr>
        </tfoot>
    </table>
</g:if>
