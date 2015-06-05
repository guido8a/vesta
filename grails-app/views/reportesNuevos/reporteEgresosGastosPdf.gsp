<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 05/06/15
  Time: 11:24 AM
--%>
<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>REPORTE PROFORMA DE EGRESOS NO PERMANENTES - GRUPO DE GASTO </title>

    <rep:estilos orientacion="p" pagTitle="REPORTE PROFORMA DE EGRESOS NO PERMANENTES - GRUPO DE GASTO"/>

    <style type="text/css">

    .tbl {
        border-collapse : collapse;
    }

    .tbl, .tbl th, .tbl td {
        border : solid 1px #555;
    }

    .tbl th {
        /*background  : #bbb;*/
        font-weight : bold;
        text-align  : left;
        width       : 5cm;
    }

    .tbl td, .tbl th {
        padding-left  : 5px;
        padding-right : 5px;
    }

    .bold {
        font-weight : bold;
    }

    .tbl2 {
        width           : 50%;
        border-collapse : collapse;
    }

    .tbl2, .tbl2 th, .tbl2 td {
        border : solid 1px transparent;
    }

    .pequena {
        /*font-size: 8px !important;*/
        font-size : 8pt !important;
    }

    .observaciones {
        border            : 1px solid black;
        padding           : 5px;
        text-align        : justify;
        page-break-inside : avoid;
        font-size         : 8pt;
    }

    .observaciones p {
        font-size : 8pt;
    }

    .observaciones .ttl {
        font-size       : 9pt;
        font-weight     : bold;
        text-decoration : underline;
    }

    </style>

</head>

<body>
<div class="hoja">
    <rep:headerFooter title="Egresos permanentes - grupo de gastos" estilo="right"/>

    <p>
    Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
    </p>
    <div style="text-align: justify;float: left;font-size: 10pt;">

        <div class="tabla" style="margin-top: 10px">

            <table width="100%" border="1" class="tbl">
                <thead>
                <tr>
                    <th>
                        GRUPO PRESUPUESTARIO
                    </th>
                    <th>
                        GRUPO DE GASTOS
                    </th>
                    <g:each in="${anios}" var="a">
                        <th>Año${a}</th>
                    </g:each>
                </tr>
                </thead>
                <tbody>
                    <g:each in="${data}" var="v">
                        <td class="text-center">${v.partida.numero.replaceAll("0", "")}</td>
                    </g:each>
                </tbody>
            </table>

        </div>

    </div>


</div>

</body>
</html>