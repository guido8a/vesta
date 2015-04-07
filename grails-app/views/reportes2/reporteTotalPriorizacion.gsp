<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/11/14
  Time: 11:56 AM
--%>


<%@ page import="vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reporte de Total de Priorización</title>
        <rep:estilos orientacion="p" pagTitle="Reporte de Total de Priorización"/>
        <style type="text/css">


        /*@page {*/
        /*size   : 29.7cm 21cm;  *//*width height */
        /*margin : 2cm;*/
        /*}*/

        /*.hoja {*/
        /*width : 23.7cm;*/
        /*}*/

        /*.hoja {*/
        /*background  : #e6e6fa;*/
        /*height      : 24.7cm; *//**//*29.7-(1.5*2)*/
        /*font-family : arial;*/
        /*font-size   : 9pt;*/
        /*}*/

        table {
            font-size : 9pt;
        }

        .titulo {
            min-height    : 20px;
            font-size     : 16pt;
            /*font-weight   : bold;*/
            text-align    : left;
            margin-bottom : 5px;
            width         : 100%;
            /*border-bottom : solid 1px #000000;*/
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

        /*.odd {*/
        /*background : none repeat scroll 0 0 #E1F1F7;*/
        /*}*/

        /*.even {*/
        /*background : none repeat scroll 0 0 #F5F5F5;*/
        /*}*/

        ol {
            counter-reset : item;
            padding       : 0;
        }

        ol li {
            display       : block;
            margin-bottom : 15px;
        }

        ol li:before {
            content           : counter(item) ". ";
            counter-increment : item;
            font-weight       : bold;
        }

        .table {
            /*border-collapse : collapse;*/
        }

        .center {
            text-align : center;
        }

        .right {
            text-align : right;
        }

        .justificacion {
            border     : solid 1px #000000;
            margin-top : 5px;
            padding    : 10px;
        }

        .firma {
            margin-left : 4cm;
            float       : left;
        }

        .negro {
            background : #000000;
            color      : #f5f5f5;
        }

        .numeracion {
            height : 35px;
        }

        .fright {
            float : right;
        }

        .firmas {
            margin-top : 2cm;
            width      : 100%;
            height     : 3cm;
        }

        .valor {
            text-align : right;
        }

        td {
            text-align : center;
        }

        .table {
            border-collapse : collapse;
        }

        .table, .table td, .table th {
            border : solid 1px #555;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter title="Reporte Total Priorización"/>


        %{--<table>--}%
        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th style="text-align: center">Proyecto</th>
                    <th style="text-align: center">Unidad Administrativa</th>
                    <th style="text-align: center">Monto Planificado</th>
                    <th style="text-align: center">Priorizado</th>
                </tr>
            </thead>
            <tbody>
                <g:set var="total" value="${0}"/>
                <g:set var="total2" value="${0}"/>
                <g:each in="${proyectos}" var="pro" status="i">
                    <tr>
                        <td style="text-align: left">
                            ${pro?.nombre}
                        </td>
                        <td>
                            ${pro?.unidadAdministradora}
                        </td>
                        <td style="text-align: right">
                            <g:set var="marcos" value="${0}"/>
                            <g:set var="subTotal" value="${0}"/>
                            <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(pro, TipoElemento.get(3))}" var="parcial">
                                <g:set var="marcos" value="${marcos + parcial?.monto}"/>
                            </g:each>
                            <g:set var="total" value="${total + marcos}"/>
                            <g:formatNumber number="${marcos}" type="currency" currencySymbol=""/>
                        </td>
                        <td style="text-align: right">
                            <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(pro, TipoElemento.get(3))}" var="mlo">
                                <g:set var="subTotal" value="${subTotal + mlo?.getTotalPriorizado()}"/>
                            </g:each>
                            <g:set var="total2" value="${total2 + subTotal}"/>
                            <g:formatNumber number="${subTotal}" type="currency" currencySymbol=""/>
                        </td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="2">TOTAL</th>
                    <th style="text-align: right;">
                        <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
                    </th>
                    <th style="text-align: right;">
                        <g:formatNumber number="${total2}" type="currency" currencySymbol=""/>
                    </th>
                </tr>
            </tfoot>
        </table>
    </body>
</html>