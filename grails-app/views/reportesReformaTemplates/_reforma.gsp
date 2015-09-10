%{--<rep:headerFooter title="REFORMA AL POA${reforma.tipo == 'C' ? ' CORRIENTE' : ''}"--}%
                  %{--form="GPE-DPI-003"--}%
                  %{--unidad="Ref. ${reforma.fecha.format('yyyy')}-${reforma.persona.unidad.gerencia.codigo}"--}%
                  %{--numero="${reforma.numeroReforma}" estilo="right"/>--}%

<rep:headerFooter title="REFORMA AL POA${reforma.tipo == 'C' ? ' CORRIENTE' : ''}"
                  form="GPE-DPI-003"
                  unidad="Ref. ${unidades?.unidad}"
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
                <strong>Matriz de la reforma:</strong>
                <g:if test="${reforma.tipo == 'C'}">
                    <g:render template="/reportesReformaTemplates/tablaReformaCorriente"
                              model="[det: det, tipo: tipo]"/>
                </g:if>
                <g:else>
                    <g:render template="/reportesReformaTemplates/tablaReforma"
                              model="[det: det, tipo: tipo]"/>
                </g:else>
            </li>
        </ol>

        <div class="no-break" style="margin-bottom: 10px">
            <strong>Observación:</strong>  ${reforma.nota.decodeHTML()}
        </div>

        <div>
            <strong>Elaborado por:</strong> ${reforma.analista ?
                (reforma.analista.sigla ?: reforma.analista.nombre + ' ' + reforma.analista.apellido) :
                (reforma.persona.sigla ?: reforma.persona.nombre + ' ' + reforma.persona.apellido)}
        </div>

        <div class="fright">
            <strong>FECHA:</strong> ${reforma.fecha?.format("dd-MM-yyyy")}
        </div>

        <div class="no-break">
            <table width="100%" style="margin-top: 0.5cm; border: none" border="none">
                <tr>
                    <g:if test="${reforma.firma1?.estado == 'F' && reforma.firma2?.estado == 'F'}">
                        <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                        <td width="25%" style="border: none"></td>
                        <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                        <td width="25%" style="border: none"></td>
                    </g:if>

                    <g:if test="${reforma.firma1?.estado == 'F' && reforma.firma2?.estado != 'F'}">
                        <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                        <td width="25%" style="border: none"></td>
                        <td width="25%" style="border: none"></td>
                        <td width="25%" style="border: none"></td>
                    </g:if>
                    <g:if test="${reforma.firma2?.estado == 'F' && reforma.firma1?.estado != 'F'}">
                        <td width="25%" style="border: none"></td>
                        <td width="25%" style="border: none"></td>
                        <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                        <td width="25%" style="border: none"></td>
                    </g:if>
                </tr>
            </table>

            <table width="100%" style="border: none" border="none">
                <tr>
                    <td width="50%" style=" text-align: center;border: none">
                        <g:if test="${reforma?.firma1?.estado == 'F'}">
                            <g:if test="${resource(dir: 'firmas', file: reforma.firma1.path)}">
                                <img src="${resource(dir: 'firmas', file: reforma.firma1.path)}" style="width: 150px;"/><br/>

                                <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px"></div>
                                <b style="text-align: center">
                                    ${reforma.firma1.usuario.nombre} ${reforma.firma1.usuario.apellido}<br/>
                                </b>
                                <b style="text-align: center;">
                                    %{--${reforma.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    ${reforma.firma1.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                </b>
                            </g:if>
                            <g:else>
                                <img src="${resource(dir: 'firmas', file: reforma.firma1.path)}" style="width: 150px;"/><br/>

                                <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                <b style="text-align: center">
                                    ${reforma.firma1.usuario.nombre} ${reforma.firma1.usuario.apellido}<br/>
                                </b>
                                <b style="text-align: center;">
                                    %{--${reforma.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    ${reforma.firma1.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                </b>
                            </g:else>

                        </g:if>
                    </td>
                    <td width="50%" style=" text-align: center;;border: none">
                        <g:if test="${reforma?.firma2?.estado == 'F'}">
                            <g:if test="${resource(dir: 'firmas', file: reforma.firma2.path)}">
                                <img src="${resource(dir: 'firmas', file: reforma.firma2.path)}" style="width: 150px;"/><br/>

                                <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px;"></div>
                                <b style="text-align: center;">
                                    ${reforma.firma2.usuario.nombre} ${reforma.firma2.usuario.apellido}<br/>
                                </b>
                                <b style="text-align: center;">
                                    %{--${reforma.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    ${reforma.firma2.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                </b>

                            </g:if>
                            <g:else>
                                <img src="${resource(dir: 'firmas', file: reforma.firma2.path)}" style="width: 150px;"/><br/>

                                <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                <b style="text-align: center;">
                                    ${reforma.firma2.usuario.nombre} ${reforma.firma2.usuario.apellido}<br/>
                                </b>
                                <b style="text-align: center;">
                                    ${reforma.firma2.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                    %{--${reforma.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                </b>
                            </g:else>

                        </g:if>
                    </td>
                </tr>
            </table>
        </div>

    </div>
</div>