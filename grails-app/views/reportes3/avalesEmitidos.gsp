<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/11/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Avales emitidos</title>
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
            <h1>Avales emitidos<br/>
                hasta el ${fecha.format("dd-MM-yyyy")}</h1>

            <table border="1">
                <thead>
                    <tr>
                        <th>Proceso</th>
                        <th>Fecha proceso</th>
                        <th>Aval</th>
                        <th>Fecha aprobación</th>
                        <th>Estado</th>
                        <th>Avance</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${avales}" var="aval">
                        <g:set var="info" value="${aval.proceso.getColorSemaforoAl(fecha)}"/>
                        <tr>
                            <td>${aval.proceso?.nombre}</td>
                            <td>${aval.proceso?.fechaInicio?.format("dd-MM-yyyy")}</td>
                            <td>${aval.concepto}</td>
                            <td>${aval.fechaAprobacion?.format("dd-MM-yyyy")}</td>
                            <td>${aval.estado.descripcion}</td>
                            <td class="right semaforo ${info[2]}">
                                <g:formatNumber number="${info[1]}" maxFractionDigits="2" minFractionDigits="2"/>%
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>
    </body>
</html>