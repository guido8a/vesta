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
        <title>Ficha de marco l&oacute;gico de proyecto</title>

        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.hotkeys.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.cookie.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.jstree.js')}"></script>

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

        .titulo {
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
            /*background    : #7fffd4;*/
        }

        .tree {
            /*background : #91C05F;*/
            border        : solid 1px #DBDB69;
            /*max-width     : 900px;*/
            margin-bottom : 0.25cm;
            width         : 25.7cm;
        }

        .tree a {
            white-space : normal !important;
            height      : auto;
            padding     : 1px 2px;
            word-wrap   : break-word;
            max-width   : 24.8cm;
        }

        .tree li > ins {
            vertical-align : top;
        }

        .tree .jstree-hovered, .tree .jstree-clicked {
            border : 0;
        }

        .mensaje {
            margin-bottom : 10px;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <div class="titulo">
                Marco L&oacute;gico de Proyecto
            </div>

            ${bosque}

            %{--<g:render template="fichaMarcoLogico" collection="${proyectos}"/>--}%

        </div>

        <script type="text/javascript">
            var icons = {
                act:"${resource(dir: 'images/ico/proy', file:'act_16.png')}",
                acts:"${resource(dir: 'images/ico/proy', file:'acts_16.png')}",
                comp:"${resource(dir: 'images/ico/proy', file:'comp_16.png')}",
                comps:"${resource(dir: 'images/ico/proy', file:'comps_16.png')}",
                fin:"${resource(dir: 'images/ico/proy', file:'fin_16.png')}",
                ind:"${resource(dir: 'images/ico/proy', file:'ind_16.png')}",
                inds:"${resource(dir: 'images/ico/proy', file:'inds_16.png')}",
                medio:"${resource(dir: 'images/ico/proy', file:'medio_16.png')}",
                medios:"${resource(dir: 'images/ico/proy', file:'medios_16.png')}",
                prop:"${resource(dir: 'images/ico/proy', file:'prop_16.png')}",
                proy:"${resource(dir: 'images/ico/proy', file:'proy_16.png')}",
                sup:"${resource(dir: 'images/ico/proy', file:'sup_16.png')}",
                sups:"${resource(dir: 'images/ico/proy', file:'sups_16.png')}"
            };

            $(function () {
                $(".tree").bind("loaded.jstree",
                        function (e, data) {
                            data.inst.open_all(-1); // -1 opens all nodes in the container
                        }).jstree({
                            "plugins":["themes", "html_data", "ui", "hotkeys", "cookies", "types"],
                            open_parents:true,
                            "themes":{
                                "theme":"default"
                            },
                            "ui":{
                                "select_limit":1
                            },
                            "types":{
                                "types":{
                                    "actividades":{
                                        "icon":{
                                            "image":icons.acts
                                        }
                                    },
                                    "actividad":{
                                        "icon":{
                                            "image":icons.act
                                        }
                                    },
                                    "componentes":{
                                        "icon":{
                                            "image":icons.comps
                                        }
                                    },
                                    "componente":{
                                        "icon":{
                                            "image":icons.comp
                                        }
                                    },
                                    "fin":{
                                        "icon":{
                                            "image":icons.fin
                                        }
                                    },
                                    "indicadores":{
                                        "icon":{
                                            "image":icons.inds
                                        }
                                    },
                                    "indicador":{
                                        "icon":{
                                            "image":icons.ind
                                        }
                                    },
                                    "medios":{
                                        "icon":{
                                            "image":icons.medios
                                        }
                                    },
                                    "medio":{
                                        "icon":{
                                            "image":icons.medio
                                        }
                                    },
                                    "propositos":{
                                        "icon":{
                                            "image":icons.prop
                                        }
                                    },
                                    "proyecto":{
                                        "icon":{
                                            "image":icons.proy
                                        }
                                    },
                                    "supuestos":{
                                        "icon":{
                                            "image":icons.sups
                                        }
                                    },
                                    "supuesto":{
                                        "icon":{
                                            "image":icons.sup
                                        }
                                    }
                                }
                            }
                        });//js tree
            });
        </script>

    </body>
</html>