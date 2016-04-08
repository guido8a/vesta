<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 08/04/16
  Time: 10:18 AM
--%>
<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 03/07/15
  Time: 12:31 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Administración de actividades y tareas</title>

    <script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}">

    <style type="text/css">
    .actividades {
        height   : 300px;
        overflow : auto;
    }

    .actDisp {
        border        : solid 1px floralwhite;
        margin-bottom : 5px;
        padding       : 5px;
    }

    .actTitleDisp {
        background    : #c6ddff;
        padding       : 2px 25px 2px 5px;
        position      : relative;
        margin-bottom : 5px;
        cursor        : pointer;
    }

    .actTitleDisp.selected {
        background : #80b26f;
        color      : whitesmoke;
    }

    .tareaDisp {
        border   : solid 1px slategrey;
        padding  : 2px 25px 2px 5px;
        position : relative;
        cursor   : pointer;
    }

    .tareaDisp.selected {
        background : #addda9;
    }

    .divSelectAllDisp {
        position : absolute;
        right    : 5px;
        top      : 0;
    }

    .divSelectDisp {
        position : absolute;
        right    : 5px;
        top      : 0;
    }

    .actCopiada {
        border        : solid 1px floralwhite;
        margin-bottom : 5px;
        padding       : 5px;
    }

    .actTitleCopiada {
        background    : #80b26f;
        padding       : 2px 25px 2px 5px;
        position      : relative;
        margin-bottom : 5px;
        cursor        : pointer;
        color         : white;
    }

    .actTitleCopiada.selected {
        background : #84474e;
        color      : whitesmoke;
    }

    .tareaCopiada {
        border   : solid 1px #567d46;
        padding  : 2px 25px 2px 5px;
        position : relative;
        cursor   : pointer;
        color    : white;
    }

    .tareaCopiada.selected {
        background : #ad6f6f;
    }

    .divSelectAllCopiada {
        position : absolute;
        right    : 5px;
        top      : 0;
    }

    .divSelectCopiada {
        position : absolute;
        right    : 5px;
        top      : 0;
    }
    </style>
</head>

<body>

<div class="row">
    <div class="col-md-2">
        <label for="anio">Año</label>
    </div>

    <div class="col-md-2">
        <g:select name="anio_name" id="anio" from="${anios}" class="form-control input-sm" optionKey="id" optionValue="anio" value="${actual?.anio}"/>
    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <label>Objetivo gasto permanente</label>
    </div>

    <div class="col-md-8" id="tdObj">

    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <label>MacroActividad</label>
    </div>

    <div class="col-md-8" id="tdMacro">

    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <label>Actividades y Tareas</label>
    </div>
    <div class="col-md-8 alert alert-info">
        <h4>
            <span id="spAnioDesde" class="spanAnio"></span>
            <a href="#" class="btn btn-danger btn-sm disabled" id="btnDelete" style="margin-left: 300px">
                <i class="fa fa-trash-o"></i>
                Eliminar selección
            </a>

        </h4>

        <div class="actividades" id="actividadesDisponibles">

        </div>
    </div>
</div>

<script type="text/javascript">

    function cargarObjAnio(anio) {
        $("#tdObj").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'poaCorriente', action:'cargarObjetivos_ajax')}",
            data    : {
                anio   : anio,
                width  : "940px"
            },
            success : function (msg) {
                $("#tdObj").html(msg);
                $("#actividadesDisponibles").html("");
                $("#tdMacro").html("")
            }
        });
    }

    function cargarActividadesAnio() {
        $("#actividadesDisponibles").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'cargarActividades_ajax')}",
            data    : {
                anio  : $("#anio").val(),
                macro : $("#mac").val()
            },
            success : function (msg) {
                $("#actividadesDisponibles").html(msg);
            }
        });
    }

    function validarEliminar() {
        var acts = $(".actTitleDisp.selected,.tareaDisp.selected").length;
        if (acts > 0) {
            $("#btnDelete").removeClass("disabled");
        } else {
            $("#btnDelete").addClass("disabled");
        }
    }

    $(function () {

        cargarObjAnio($("#anio").val());


        $("#anio").change(function () {
            cargarObjAnio($("#anio").val())
        });


         $("#btnDelete").click(function () {
            bootbox.confirm("¿Está seguro de querer eliminar estas actividades/tareas?", function () {
                var acts = "";
                var tareas = "";
                $(".actTitleDisp.selected").each(function () {
                    acts += $(this).data("id") + ",";
                });
                $(".tareaDisp.selected").each(function () {
                    tareas += $(this).data("id") + ",";
                });
                openLoader();
                $.ajax({
                    type    : "POST",
                    url     : "${createLink( action:'eliminarActividadesTareas_ajax')}",
                    data    : {
                        acts   : acts,
                        tareas : tareas
                    },
                    success : function (msg) {
                        var parts = msg.split("*");
                        if(parts[0] == "SUCCESS"){
                            log(parts[1], parts[0]);
                            closeLoader();
                            setTimeout(function () {
                                location.href = "${createLink(controller:'poaCorriente',action:'administrar')}";
                            }, 1500);
                        }else{
                            log(parts[1], parts[0]);
                            closeLoader();
                        }

                    }
                });
            });
            return false;
        });

    });
</script>

</body>
</html>