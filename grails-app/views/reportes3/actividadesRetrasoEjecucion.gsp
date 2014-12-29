<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/11/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Actividades con retraso de ejecución</title>
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
            <h1>Actividades con retraso de ejecución<br/>
                hasta el ${fecha.format("dd-MM-yyyy")}</h1>

            <table border="1">
                <thead>
                    <tr>
                        <th>Proyecto</th>
                        <th>Objeto</th>
                        <th>Monto</th>
                        <th>Unidad responsable</th>
                        <th>Fecha inicio</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${actividades}" var="act">
                        <tr>
                            <td>${act.proyecto?.descripcion}</td>
                            <td>${act.objeto}</td>
                            <td class="right"><g:formatNumber number="${act.monto}" type="currency"/></td>
                            <td>${act.responsable?.nombre}</td>
                            <td>${act.fechaInicio?.format("dd-MM-yyyy")}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
    </body>
</html>