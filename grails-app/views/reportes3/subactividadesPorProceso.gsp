<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/11/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Subactividades por proceso</title>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'svt.css')}"/>
        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 25.2cm;
        }

        .titulo, .proyecto, .componente {
            width : 25.2cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        h1 {
            text-align : center;
        }

        table {
            width           : 100%;
            border-collapse : collapse;
        }

        th {
            text-align : center;
            font-size  : 12pt;
        }

        td {
            padding : 5px;
        }

        .right {
            text-align : right;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <h1>Subactividades del proceso ${proceso.nombre}<br/>
                hasta el ${fecha.format("dd-MM-yyyy")}</h1>

            <table border="1">
                <thead>
                    <tr>
                        <th>Actividad</th>
                        <th>Aporte</th>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Completado</th>
                    </tr>
                </thead>
                <tbody>
                    <g:set var="total" value="${0}"/>
                    <g:set var="completado" value="${0}"/>
                    <g:each in="${avances}" var="avance">
                        <g:set var="total" value="${total + avance.avance}"/>

                        <g:set var="info" value="${avance.getColorSemaforoAl(fecha)}"/>
                        <g:set var="valor" value="${avance.getAvanceFisico()}"/>
                        <tr>
                            <td>${avance.observaciones}</td>
                            <td><g:formatNumber number="${avance.avance}" maxFractionDigits="2" minFractionDigits="2"/>%</td>
                            <td>${avance.inicio?.format("dd-MM-yyyy")}</td>
                            <td>${avance.fin?.format("dd-MM-yyyy")}</td>
                            <td class="right semaforo ${info[2]}">
                                <g:formatNumber number="${valor}" maxFractionDigits="2" minFractionDigits="2"/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <td style="font-weight: bold;text-align: right">
                            Total  planificado:
                        </td>
                        <td style="font-weight: bold;text-align: right">
                            <g:formatNumber number="${total}" minFractionDigits="2" maxFractionDigits="2"/>%
                        </td>
                        <td colspan="2" style="text-align: right;font-weight: bold">
                            Total completado:
                        </td>
                        <td style="font-weight: bold;text-align: right">
                            <g:formatNumber number="${proceso.getAvanceFisico()}" minFractionDigits="2" maxFractionDigits="2"/>%
                        </td>
                    </tr>
                </tfoot>
            </table>

        </div>
    </body>
</html>