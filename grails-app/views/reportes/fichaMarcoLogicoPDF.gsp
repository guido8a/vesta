<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<html>
    <head>
        <title>Ficha de marco lógico de proyecto</title>

        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 24.7cm;
        }

        .titulo {
            width : 24.7cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        .titulo {
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
            /*background    : #7fffd4;*/
        }

        ul {
            padding-left : 20px;
        }

        li {
            margin : 5px !important;
        }

        .tree {
            /*background : #91C05F;*/
            border        : solid 1px #DBDB69;
            /*max-width     : 900px;*/
            margin-bottom : 0.25cm;
        }

        .tree a {
            white-space     : normal !important;
            height          : auto;
            padding         : 1px 2px;

            text-decoration : none;
            cursor          : auto;
            width           : 100%;
        }

        .tree li > ins {
            vertical-align : top;
        }

        .tree .jstree-hovered, .tree .jstree-clicked {
            border : 0;
        }

        .error {
            border     : 1px solid #cd0a0a;
            background : #e14f1c;
            color      : #ffffff;
        }

        .ui-corner-all, .ui-corner-top, .ui-corner-left, .ui-corner-tl {
            -moz-border-radius-topleft     : 5px;
            -webkit-border-top-left-radius : 5px;
            -khtml-border-top-left-radius  : 5px;
            border-top-left-radius         : 5px;
        }

        .ui-corner-all, .ui-corner-top, .ui-corner-right, .ui-corner-tr {
            -moz-border-radius-topright     : 5px;
            -webkit-border-top-right-radius : 5px;
            -khtml-border-top-right-radius  : 5px;
            border-top-right-radius         : 5px;
        }

        .ui-corner-all, .ui-corner-bottom, .ui-corner-left, .ui-corner-bl {
            -moz-border-radius-bottomleft     : 5px;
            -webkit-border-bottom-left-radius : 5px;
            -khtml-border-bottom-left-radius  : 5px;
            border-bottom-left-radius         : 5px;
        }

        .ui-corner-all, .ui-corner-bottom, .ui-corner-right, .ui-corner-br {
            -moz-border-radius-bottomright     : 5px;
            -webkit-border-bottom-right-radius : 5px;
            -khtml-border-bottom-right-radius  : 5px;
            border-bottom-right-radius         : 5px;
        }

        .mensaje {
            margin-bottom : 10px;
        }

        .proyecto {
            color : #000080;
        }

        .liProyecto {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'proy_16.png')}");
        }

        .liFin {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'fin_16.png')}");
        }

        .liIndicadores {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'inds_16.png')}");
        }

        .liIndicador {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'ind_16.png')}");
        }

        .liMedios {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'medios_16.png')}");
        }

        .liMedio {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'medio_16.png')}");
        }

        .liSupuestos {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'sups_16.png')}");
        }

        .liSupuesto {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'sup_16.png')}");
        }

        .liPropositos {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'prop_16.png')}");
        }

        .liActividades {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'acts_16.png')}");
        }

        .liActividad {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'act_16.png')}");
        }

        .liComponentes {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'comps_16.png')}");
        }

        .liComponente {
            list-style-image : url("${resource(dir: 'images/ico/proy', file: 'comp_16.png')}");
        }

        </style>
    </head>

    <body>
        <div class="hoja">
            <div class="titulo">
                Ficha de marco lógico de proyecto
            </div>

            ${bosque}

            %{--<g:render template="fichaMarcoLogico" collection="${proyectos}"/>--}%

        </div>
    </body>
</html>