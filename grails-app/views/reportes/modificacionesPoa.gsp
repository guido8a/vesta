
<html>
<head>
    <title>Modificaciones al PAPP de la unidad: ${unidad}</title>

    <style type="text/css">
    @page {
        size   : 21cm 29.7cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width : 15cm;
    }

    .titulo {
        width : 15.5cm;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height      : 24.7cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 12pt;
    }

    .titulo {
        min-height        : 20px;
        font-size     : 12pt;
        /*font-weight   : bold;*/
        text-align    : center;
        margin-bottom : 5px;
        width: 95%;
    }

    .totales {
        font-weight : bold;
    }

    .num {
        text-align : right;
    }

    .header {
        background : #333333 !important;
        color      : #AAAAAA;
    }

    .total {
        background : #000000 !important;
        color      : #FFFFFF !important;
    }
    th {
        background : #cccccc;
    }

    .odd {
        background : none repeat scroll 0 0 #E1F1F7;
    }

    .even {
        background : none repeat scroll 0 0 #F5F5F5;
    }
    </style>

</head>

<body>

<div style="margin-left: 10px;">
    <div class="hoja">
        <div class="titulo">Modificaciones al PAPP de la unidad: <br/>${unidad}</div>

        <g:each in="${res}" var="mod" status="i">
            <table width="600px;" style="margin-top: 20px;font-size: 10px">
                <thead>
                <th class="ui-state-default"><b># ${i+1}</b></th>
                <th class="ui-state-default" style="width: 120px">Unidad</th>
                <th style="width: 250px;" class="ui-state-default">Programa</th>
                <th style="width: 200px;" class="ui-state-default">Actividad</th>
                <th class="ui-state-default">Partida</th>
                <th style="width: 150px" class="ui-state-default">Desc. partida</th>
                <th class="ui-state-default">Fuente</th>
                %{--<th class="ui-state-default">Presupuesto</th>--}%
                </thead>
                <tbody>

                <tr class="odd">
                    <td>
                        <b>Desde:</b>
                    </td>
                    <td>
                        ${mod.desde.unidad}
                    </td>
                    <td class="programa" style="width: 250px;">
                        ${(mod.desde.marcoLogico)?mod.desde.marcoLogico.proyecto.programa.descripcion:mod.desde.programa.descripcion}
                    </td>

                    <td class="actividad">
                        ${(mod.desde.marcoLogico)?mod.desde.marcoLogico:mod.desde.actividad}
                    </td>

                    <td class="prsp" style="text-align: center">
                        ${mod.desde.presupuesto.numero}
                    </td>

                    <td class="desc" style="width: 240">
                        ${mod.desde.presupuesto.descripcion}
                    </td>

                    <td class="fuente">
                        ${mod.desde.fuente.descripcion}
                    </td>

                    %{--<td class="valor" style="text-align: right">--}%
                        %{--<g:formatNumber number="${(mod.desde.redistribucion==0)?mod.desde.planificado.toFloat():mod.desde.redistribucion.toFloat()}"--}%
                                        %{--format="###,##0"--}%
                                        %{--minFractionDigits="2" maxFractionDigits="2"/>--}%

                    %{--</td>--}%
                </tr>
                <tr class="even">
                    <td>
                        <b> Hasta: </b>
                    </td>
                    <g:if test="${mod.recibe}">
                        <td>
                            ${mod.desde.unidad}
                        </td>
                        <td class="programa">
                            ${(mod.recibe.marcoLogico)?mod.recibe.marcoLogico.proyecto.programa.descripcion:mod.recibe.programa.descripcion}
                        </td>

                        <td class="actividad">
                            ${(mod.recibe.marcoLogico)?mod.recibe.marcoLogico:mod.recibe.actividad}
                        </td>

                        <td class="prsp" style="text-align: center">
                            ${mod.recibe.presupuesto.numero}
                        </td>

                        <td class="desc" style="width: 240">
                            ${mod.recibe.presupuesto.descripcion}
                        </td>

                        <td class="fuente">
                            ${mod.recibe.fuente.descripcion}
                        </td>

                        %{--<td class="valor" style="text-align: right">--}%
                            %{--<g:formatNumber number="${mod.recibe.planificado}"--}%
                                            %{--format="###,##0"--}%
                                            %{--minFractionDigits="2" maxFractionDigits="2"/>--}%
                        %{--</td>--}%
                    </g:if>
                    <g:else>
                        <g:if test="${mod.unidad}">
                            <td colspan="6">Área de gestión: ${mod.unidad}</td>
                        </g:if>
                        <g:else>
                            <td colspan="6">
                                Nueva asginación
                            </td>
                        </g:else>
                    </g:else>

                </tr>
                <tr class="odd">
                    <td>
                        <b>Valor:</b>
                    </td>
                    <td>
                        <g:formatNumber number="${mod.valor}"
                                        format="###,##0"
                                        minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                </tr>
                <tr class="even">
                    <td>
                        <b> Fecha:</b>
                    </td>
                    <td>
                        ${mod.fecha?.format("dd/MM/yyyy")}
                    </td>
                </tr>

                </tbody>
            </table>

        </g:each>

    </div>



</div>
</body>
</html>