<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Ficha de proyecto</title>

    <style type="text/css">
    @page {
        size   : 29.7cm 21cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width : 25.7cm;
    }

    .titulo, .proyecto, .componente {
        width : 25.7cm;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height      : 17cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 10pt;
    }

    .titulo {
        height        : .5cm;
        font-size     : 16pt;
        font-weight   : bold;
        text-align    : center;
        margin-bottom : .5cm;
    }

    .tabla {
        /*border-collapse : collapse;*/
        /*border-color    : #8a8a8a;*/
    }

    .proyecto {
        /*background    : #fffacd;*/
        margin-bottom : .35cm;
        border        : solid 1px #404040;
        /*padding       : .25cm;*/
    }

    .nombreArea {
        background  : #d0d0d0;
        font-weight : bold;
        font-size   : 12pt;
        /*padding     : 3px;*/
    }

    tbody tr:nth-child(even) {
        background : #f5f5f5;
    }

    tbody tr:nth-child(odd) {
        background : #e5e5e5;
    }

    </style>

</head>

<body>
    <div class="hoja">
        <div class="titulo">
            Ficha de proyecto
        </div>

        <g:each in="${proyectos}" var="proyecto">
            <g:set var="proy" value="${proyecto.proyecto}"/>
            <div class="proyecto">
                <table border="0" width="100%" class="tabla">
                    <tr>
                        <th colspan="2" class="nombreArea">
                            Datos Generales del proyecto
                        </th>
                    </tr>
                    <tr>
                        <th width="15%" class="etiqueta">Nombre</th>
                        <td width="85%" class="cont">${proy.nombre}</td>
                    </tr>

                    <tr>
                        <th class="etiqueta">CUP</th>
                        <td class="cont">${proy.codigoProyecto}</td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Etapa</th>
                        <td class="cont">${proy.etapa}</td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Fase</th>
                        <td class="cont">${proy.fase}</td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Monto</th>
                        <td class="cont"><g:formatNumber number="${proy.monto.toDouble()}" format="###,##0"
                                                         minFractionDigits="2"
                                                         maxFractionDigits="2"/></td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Fecha de Inicio</th>
                        <td class="cont">${proy.fechaInicio}</td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Fecha de Finalización</th>
                        <td class="cont">${proy.fechaFin}</td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Unidad Ejecutora</th>
                        <td class="cont">${proy.unidadEjecutora}</td>
                    </tr>

                    <tr>
                        <th colspan="2" class="nombreArea">
                            Información Narrativa del Proyecto
                        </th>
                    </tr>
                    <tr>
                        <th class="etiqueta">Descripción</th>
                        <td>${proy.descripcion}</td>
                    </tr>
                    <tr>
                        <th class="etiqueta">Problema</th>
                        <td>${proy.problema}</td>
                    </tr>

                    <tr>
                        <th colspan="2" class="nombreArea">
                            Políticas
                        </th>
                    </tr>
                    <g:each in="${proyecto.politicas}" var="politica" status="i">
                        <tr>
                            <td colspan="2">
                                ${politica.politica.descripcion}
                            </td>
                        </tr>
                    </g:each>

                    <tr>
                        <th colspan="2" class="nombreArea">
                            Financiamiento
                        </th>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <center>
                                <table>
                                    <thead>
                                        <tr style="padding: 5px;">
                                            <th style="padding: 5px;" class="ui-corner-tl" width="320px;">
                                                Fuente
                                            </th>
                                            <th style="padding: 5px;" class="" width="120px;">
                                                Monto
                                            </th>
                                            <th style="padding: 5px;" class="ui-cornet-tr" width="120px;">
                                                Porcentaje
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:set var="suma" value="${0}"/>
                                        <g:set var="prct" value="${0}"/>
                                        <g:each in="${proyecto.financiamientos}" status="i" var="fin">
                                            <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                                                <td fuente="${fin.fuente.id}" tipo="descripcion">
                                                    ${fin.fuente.descripcion}
                                                </td>
                                                <td style="text-align: right;" fuente="${fin.fuente.id}" tipo="monto">

                                                    <g:formatNumber number="${fin.monto}" format="###,##0"
                                                                    minFractionDigits="2" maxFractionDigits="2"/>

                                                    <g:set var="suma" value="${suma + fin.monto}"/>
                                                </td>
                                                <td style="text-align: right;" fuente="${fin.fuente.id}"
                                                    tipo="porcentaje">

                                                    <g:set var="finPorcentaje"
                                                           value="${(fin.monto * 100) / proy.monto}"/>
                                                    <g:formatNumber number="${finPorcentaje/100}" type="percent"
                                                                    minFractionDigits="2"
                                                                    maxFractionDigits="2"/>

                                                    <g:set var="prct" value="${prct+ finPorcentaje}"/>
                                                </td>
                                            </tr>
                                        </g:each>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th class="ui-corner-bl" style="font-weight: bold;">
                                                TOTAL
                                            </th>
                                            <th class="" style="text-align: right; font-weight: bold;">
                                                <span id="spanSuma">
                                                    <g:formatNumber number="${suma}" format="###,##0"
                                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                                </span>
                                            </th>
                                            <th class="ui-corner-br" style="text-align: right; font-weight: bold;">
                                                <span id="spanPrct">
                                                    <g:formatNumber number="${prct/100}" type="percent"
                                                                    minFractionDigits="2"
                                                                    maxFractionDigits="2"/>
                                                </span>
                                            </th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </center>
                        </td>
                    </tr>

                    <tr>
                        <th colspan="2" class="nombreArea">
                            Marco Lógico
                        </th>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Fin
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Fin
                        </td>
                        <td>${proyecto.fin.fin.objeto}</td>
                    </tr>
                </table>
            </div>
        </g:each>

    </div>

</body>
</html>