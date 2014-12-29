<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/9/11
  Time: 11:56 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>
            Componentes proyectos
        </title>

        <style type="text/css">
        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 16cm;
        }

        .titulo, .proyecto, .componente, .area {
            width : 16cm;
        }

        .area {
            border        : #c0c0c0 solid 1px;
            margin-bottom : 20px;
            padding       : 3px;
        }

        .titulo {
            min-height        : .5cm;
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
        }

        .proyecto {
            /*background    : #fffacd;*/
            margin-bottom : .35cm;
            border        : solid 1px #404040;
            /*padding       : .25cm;*/
        }

        .componente {
            margin-bottom : 5px;
        }

        .nombreArea {
            background  : #dedede;
            font-weight : bold;
            font-size   : 12pt;
            /*padding     : 3px;*/
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        table {
            border-collapse : collapse;
            border          : solid 1px #000000;
        }

        th {
            /*background : #eee;*/
        }

        tbody tr.even {
            background : none repeat scroll 0 0 #E1F1F7;
        }

        tbody tr.odd {
            background : none repeat scroll 0 0 #F5F5F5;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <h1 style="text-align: center;">Detalle de componentes por proyecto</h1>
            <g:each in="${proyectos}" var="proyecto">
                <g:set var="totalProyecto" value="${0}"/>
                <div class="area">
                    <div class="titulo">
                        ${proyecto.proyecto.nombre}
                    </div>

                    <g:each in="${proyecto.componentes}" var="componente" status="c">
                        <g:set var="totalComponente" value="${0}"/>
                        <div class="componente">
                            <div class="nombreArea">
                                ${componente.componente.objeto}
                            </div>
                            <g:if test="${componente.actividades.size() > 0}">
                                <table border="1" width="100%">
                                    <thead>
                                        <tr>
                                            <th width="80%">Actividad</th>
                                            <th width="20%">Monto</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in="${componente.actividades}" var="actividad" status="a">
                                            <tr>
                                                <td>
                                                    ${actividad.objeto}
                                                </td>

                                                <td style="text-align: right;">
                                                    <g:formatNumber number="${actividad.monto}"
                                                                    format="###,##0"
                                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                                    <g:set var="totalComponente" value="${totalComponente + actividad.monto}"/>
                                                    <g:set var="totalProyecto" value="${totalProyecto+actividad.monto}"/>
                                                </td>
                                            </tr>
                                        </g:each>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th>
                                                Total
                                            </th>
                                            <th style="text-align: right;">
                                                <g:formatNumber number="${totalComponente}"
                                                                format="###,##0"
                                                                minFractionDigits="2" maxFractionDigits="2"/>
                                            </th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </g:if>
                        </div>
                    </g:each>
                    <table border="1" width="100%">
                        <tbody>
                            <tr>
                                <th width="80%">TOTAL</th>
                                <th width="20%" style="text-align: right; font-size: larger;">
                                    <g:formatNumber number="${totalProyecto}"
                                                    format="###,##0"
                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </g:each>
        </div>
    </body>
</html>