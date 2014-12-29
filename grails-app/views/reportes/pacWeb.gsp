<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<html>
    <head>
        <meta name="layout" content="main"/>
        <title>P.A.C.</title>

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
            <table border="1">
                <thead>
                    <tr>
                        <th>Ejercicio</th>
                        <th>Entidad</th>
                        <th>Unidad Ejecutora</th>
                        %{--<th>Unidad desconcentrada</th>--}%
                        <th>Programa</th>
                        %{--<th>Subprograma</th>--}%
                        <th>Proyecto</th>
                        <th>Actividad</th>
                        %{--<th>Obra</th>--}%
                        %{--<th>Geogr&aacute;fico</th>--}%
                        <th>Rengl&oacute;n</th>
                        <th>Presupuesto</th>
                        %{--<th>Rengl&oacute;n auxiliar</th>--}%
                        <th>Fuente</th>
                        %{--<th>Organismo</th>--}%
                        %{--<th>Correlativo</th>--}%
                        <th>CPC</th>
                        <th>Tipo compra</th>
                        <th>Detalle del producto</th>
                        <th>Cantidad anual</th>
                        <th>Unidad</th>
                        <th>Costo unitario</th>
                        <th>C. 1</th>
                        <th>C. 2</th>
                        <th>C. 3</th>
                    </tr>
                </thead>
                <tbody>
                    <g:render template="pac" collection="${result}"/>
                </tbody>
            </table>
        </div>
    </body>
</html>