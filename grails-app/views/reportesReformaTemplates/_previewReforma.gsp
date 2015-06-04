<rep:headerFooter title="${reforma.tipo == 'R' ? 'REFORMA' : 'AJUSTE'} AL POA"
                  form="GPE-DPI-003"
                  unidad="Ref. ${reforma.fecha.format('yyyy')}-${reforma.persona.unidad.gerencia.codigo}"
                  numero="${reforma.numeroReforma}" estilo="right"/>

<div style="margin-left: 10px;">
    <div>
        <ol>
            <li>
                <strong>Unidad responsable (Gerencia - Dirección):</strong>
                <g:if test="${unidades}">
                    <g:if test="${unidades.gerencia.id != unidades.unidad.id}">
                        ${unidades.gerencia} -
                    </g:if>
                    ${unidades.unidad}
                </g:if>
                <g:else>
                    ${reforma.persona.unidad} (No está completo el código!)
                </g:else>
            </li>
            <li>
                <strong>Matriz de la ${reforma.tipo == 'R' ? 'reforma' : 'ajuste'}:</strong>
                <g:render template="/reportesReformaTemplates/tablaSolicitud"
                          model="[det: det, tipo: tipo]"/>
            </li>
            <li class="no-break" style="margin-top: 15px">
                <strong>Observación:</strong>

                <div class="justificacion">
                    ${reforma.nota.decodeHTML()}
                </div>
            </li>
        </ol>

        <div>
            <strong>Elaborado por:</strong> ${reforma.analista ? reforma.analista.sigla : reforma.persona.sigla}
        </div>

        <div class="fright">
            <strong>FECHA:</strong> ${reforma.fecha?.format("dd-MM-yyyy")}
        </div>
    </div>
</div>