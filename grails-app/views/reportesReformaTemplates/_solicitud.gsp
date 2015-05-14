<rep:headerFooter title="${reforma.tipo == 'R' ? 'SOLICITUD DE REFORMA' : 'AJUSTE'} AL POA"
                  unidad="${reforma.fecha.format('yyyy')}-GPE"
                  numero="${reforma.id}" estilo="right"/>

<div style="margin-left: 10px;">
    <div>
        <ol>
            <li>
                <strong>Unidad responsable (Gerencia - Dirección):</strong> ${reforma.persona.unidad}
            </li>
            <li>
                <strong>Tipo de ${reforma.tipo == 'R' ? 'reforma' : 'ajuste'}:</strong>
                <elm:tipoReforma reforma="${reforma}"/>
            </li>
            <li>
                <strong>Matriz de la ${reforma.tipo == 'R' ? 'reforma' : 'ajuste'}:</strong>
                <g:render template="/reportesReformaTemplates/tablaSolicitud"
                          model="[det: det, tipo: tipo]"/>
                <g:if test="${det2}">
                    <g:render template="/reportesReformaTemplates/tablaSolicitud"
                              model="[det: det2, tipo: tipo, analista: reforma.analista]"/>
                </g:if>
            </li>
            <li class="no-break" style="margin-top: 15px">
                <strong>Justificación ${reforma.tipo == 'R' ? 'de la reforma' : 'del ajuste'} al POA solicitada:</strong>

                <div class="justificacion">
                    ${reforma.concepto.encodeAsHTML()}
                </div>
            </li>
        </ol>

        <div>
            <strong>Elaborado por:</strong> ${reforma.persona.sigla}
        </div>

        <div class="fright">
            <strong>FECHA:</strong> ${reforma.fecha?.format("dd-MM-yyyy")}
        </div>

        <div>
            Es importante señalar que ${reforma.tipo == 'R' ? 'la reforma' : 'el ajuste'} no implica un incremento en el techo del presupuesto programado y que el impacto
            causado por la modificación de POA no afecta a los objetivos institucionales
        </div>

        <div class="firma ">
            <div>
                <span class="spanFirma">
                    <g:if test="${reforma?.firmaSolicitud?.estado == 'F'}">
                        <img src="${resource(dir: 'firmas', file: reforma?.firmaSolicitud?.path)}" style="width: 150px;"/><br/>

                        <div style="border-bottom: solid; width: 150px"></div>
                        ${reforma?.firmaSolicitud?.usuario?.nombre} ${reforma?.firmaSolicitud?.usuario?.apellido}<br/>
                        <b>GERENTE DE ${reforma?.firmaSolicitud?.usuario?.cargoPersonal?.toString()?.toUpperCase()}<br/>
                        </b>
                    </g:if>
                </span>
            </div>
        </div>
    </div>
</div>