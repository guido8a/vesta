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

        %{--<div class="firma no-break" style="text-align: center;">--}%
            %{--<span class="spanFirma">--}%
                %{--<g:if test="${reforma?.firmaSolicitud?.estado == 'F'}">--}%
                    %{--<img src="${resource(dir: 'firmas', file: reforma?.firmaSolicitud?.path)}" style="width: 150px;"/><br/>--}%

                    %{--<b>--}%
                        %{--${reforma?.firmaSolicitud?.usuario?.nombre} ${reforma?.firmaSolicitud?.usuario?.apellido}<br/>--}%
                    %{--</b>--}%
                    %{--<b>--}%
                        %{--${reforma?.firmaSolicitud?.usuario?.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                        %{--${reforma?.firmaSolicitud?.usuario?.cargo?.toString()?.toUpperCase()}<br/>--}%
                    %{--</b>--}%
                %{--</g:if>--}%
            %{--</span>--}%
        %{--</div>--}%

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