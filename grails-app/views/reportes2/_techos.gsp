<table border="1" width="100%">
    <thead>
        <tr>
            <th>Unidad ejecutora</th>
            <th>Año</th>
            <th>Objetivo estratégico</th>
            <th>Objetivo GPR</th>
            <th>Eje programático</th>
            <th>Política</th>
            <th>Max. corriente</th>
            <th>Max. inversión</th>
        </tr>
    </thead>

    <tbody>
        <g:each in="${results}" var="${r}" status="i">
            <tr>
                <td>
                    ${r.unidad?.nombre}
                </td>

                <td>
                    ${r.anio?.anio}
                </td>

                <td>
                    ${r.objetivoEstrategico?.descripcion}
                </td>

                <td>
                    ${r.objetivoGobiernoResultado?.descripcion}
                </td>

                <td>
                    ${r.ejeProgramatico?.descripcion}
                </td>

                <td>
                    ${r.politica?.descripcion}
                </td>

                <td>
                    <g:formatNumber number="${r.maxCorrientes}" format="###,##0" maxFractionDigits="2" minFractionDigits="2"/>
                </td>

                <td>
                    <g:formatNumber number="${r.maxInversion}" format="###,##0" maxFractionDigits="2" minFractionDigits="2"/>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>