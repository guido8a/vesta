%{--<rep:headerFooter title="${reforma.tituloSolicitud.toUpperCase()}"--}%
                  %{--form=" GPE-DPI-003"--}%
                  %{--unidad="Ref. ${reforma.fecha.format('yyyy')}-${reforma.persona.unidad.gerencia.codigo}"--}%
                  %{--numero="${reforma.numero}" estilo="right"/>--}%

<rep:headerFooter title="${reforma.tituloSolicitud.toUpperCase()}"
                  form=" GPE-DPI-003"
                  unidad="${unidades.unidad}"
                  numero="${reforma.numero}" estilo="right"/>

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
                <strong>Tipo de ${reforma.tipo == 'R' ? 'reforma' : 'ajuste'}:</strong>
                <elm:tipoReforma reforma="${reforma}"/>
            </li>
            <li>
                <strong>Matriz de la ${reforma.tipoString}:</strong>
                <g:if test="${reforma.tipo == 'C'}">
                    <g:render template="/reportesReformaTemplates/tablaSolicitudCorriente"
                              model="[det: det, tipo: tipo]"/>
                </g:if>
                <g:else>
                    <g:render template="/reportesReformaTemplates/tablaSolicitud"
                              model="[det: det, tipo: tipo]"/>
                    <g:if test="${det2}">
                        <g:render template="/reportesReformaTemplates/tablaSolicitud"
                                  model="[det: det2, tipo: tipo, analista: reforma.analista]"/>
                    </g:if>
                </g:else>
            </li>
            <li class="no-break" style="margin-top: 15px">
                <strong>Justificación ${reforma.tipo == 'R' ? 'de la reforma' : ('del ajuste' + reforma.tipo == 'C' ? ' corriente' : '')} al POA solicitada:</strong>

                <div class="justificacion">
                    ${reforma.concepto.decodeHTML()}
                </div>
            </li>
        </ol>

        <div>
            <strong>Elaborado por:</strong> ${reforma.persona.sigla ?: reforma.persona.nombre + ' ' + reforma.persona.apellido}
        </div>

        <div class="fright">
            <strong>FECHA:</strong> ${reforma.fecha?.format("dd-MM-yyyy")}
        </div>

        <div style="margin-top: 10px;">
            Es importante señalar que ${reforma.tipo == 'R' ? 'la reforma' : 'el ajuste'} no implica un incremento en el techo del presupuesto programado y que el impacto
            causado por la modificación de POA no afecta a los objetivos institucionales
        </div>

        <div class="firma no-break" style="text-align: center;">
            <span class="spanFirma">
                <g:if test="${reforma?.firmaSolicitud?.estado == 'F'}">
                    <img src="${resource(dir: 'firmas', file: reforma?.firmaSolicitud?.path)}" style="width: 150px;"/><br/>

                    <b>
                        ${reforma?.firmaSolicitud?.usuario?.nombre} ${reforma?.firmaSolicitud?.usuario?.apellido}<br/>
                    </b>
                    <b>
                        %{--${reforma?.firmaSolicitud?.usuario?.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                        ${reforma?.firmaSolicitud?.usuario?.cargo?.toString()?.toUpperCase()}<br/>
                    </b>
                </g:if>
            </span>
        </div>
   </div>
</div>