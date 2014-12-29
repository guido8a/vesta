<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/10/11
  Time: 3:50 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>
            Ejecución presupuestaria
        </title>

        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 25.7cm;
        }

        .titulo {
            width : 25.7cm;
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
            background : #cccccc;
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
            <table border="1" cellpadding="5">
                <thead>
                    <tr>
                        <th>Proyecto</th>
                        <th>Monto</th>
                        <th>Asignaciones</th>
                        <th>Vigente</th>
                        <th>Compromiso</th>
                        <th>Devengado</th>
                        <th>Pagado</th>
                        <th>Saldo presupuesto</th>
                        <th>Saldo disponible</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${proyectos}" status="i" var="proy">
                        <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                            <td>${proy.proyecto}</td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.asignaciones}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.vigente}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.compromiso}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.devengado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.pagado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.saldoPresupuesto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>

                            <td style="text-align: right;"><g:formatNumber number="${proy.saldoDisponible}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
    </body>
</html>