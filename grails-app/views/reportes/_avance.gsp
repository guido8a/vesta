<div class="proyecto ui-corner-all">
    <div class="nombreProyecto">
        <strong>Proyecto:</strong> ${it.proyecto.nombre}
    </div>
    <g:if test="${it.componentes.size() > 0}">
        <g:each in="${it.componentes}" var="componente">
            <div class="componente">
                <div class="nombreComponente">
                    <strong>Componente:</strong> ${componente.componente.objeto}
                </div>

                <g:if test="${componente.actividades.size() >0}">
                    <g:each in="${componente.actividades}" var="actividad">

                        <div class="actividad">
                            <div class="nombreActividad">
                                <strong>Actividad:</strong> ${actividad.actividad.objeto}
                            </div>
                            <g:if test="${actividad.metas.size() > 0}">
                                <g:each in="${actividad.metas}" var="meta">
                                    <div class="meta">
                                        <div class="nombreMeta">
                                            <strong>Meta:</strong>
                                            <g:formatNumber number="${meta.meta.indicador}" format="###,##0" maxFractionDigits="2" minFractionDigits="2"/>
                                            ${meta.meta.tipoMeta.descripcion}
                                            ($<g:formatNumber number="${meta.meta.inversion}" format="###,##0" maxFractionDigits="2" minFractionDigits="2"/>)
                                        </div>
                                        <g:if test="${meta.avances.size() > 0}">
                                            <g:each in="${meta.avances}" var="avance">
                                                <div class="avance">
                                                    <strong>Avance:</strong> ${avance.valor} ${avance.descripcion}
                                                </div>
                                            </g:each>
                                        </g:if>
                                        <g:else>
                                            <span style="font-style: italic; color: #990000;">
                                                No se encontraron avances para la meta
                                            </span>
                                        </g:else>
                                    </div>
                                </g:each>
                            </g:if>
                            <g:else>
                                <span style="font-style: italic; color: #990000;">
                                    No se encontraron metas para la actividad
                                </span>
                            </g:else>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <span style="font-style: italic; color: #990000;">
                        No se encontraron actividades para el componente
                    </span>
                </g:else>
            </div>
        </g:each>
    </g:if>
    <g:else>
        <span style="font-weight: bold; color: #990000;">
            No se encontraron componentes, metas ni avances para el proyecto
        </span>
    </g:else>
</div>