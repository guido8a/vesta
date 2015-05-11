<rep:headerFooter title="${reforma.tipo == 'R' ? 'REFORMA' : 'AJUSTE'} AL POA"
                  unidad="${reforma.fecha.format('yyyy')}-GPE"
                  numero="${reforma.id}" estilo="right"/>

<div style="margin-left: 10px;">
    <div>
        <ol>
            <li>
                <strong>Unidad responsable (Gerencia - Dirección):</strong> ${reforma.persona.unidad}
            </li>
            <li>
                <strong>Matriz de la ${reforma.tipo == 'R' ? 'reforma' : 'ajuste'}:</strong>
                <g:render template="/reportesReformaTemplates/tablaSolicitud"
                          model="[det: det, tipo: tipo]"/>
            </li>
            <li class="no-break" style="margin-top: 15px">
                <strong>Observación:</strong>

                <div class="justificacion">
                    ${reforma.nota}
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