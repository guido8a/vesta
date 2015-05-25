<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Avances físicos</title>
        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'semaforos.css')}" type="text/css"/>
    </head>

    <body>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="row no-margin-top">
            <div class="col-md-4">
                <div class="btn-toolbar toolbar">
                    <div class="btn-group">
                        <g:link controller="avales" action="listaProcesos" class="btn btn-default"><i class="fa fa-bars"></i> Lista de procesos</g:link>
                    </div>
                </div>
            </div>

            <div class="col-md-8 text-right">
                Código de colores:
                <div class="semaforo green"></div>100% - 76%
                <div class="semaforo yellow"></div>75% - 51%
                <div class="semaforo orange"></div>50% - 26%
                <div class="semaforo red"></div>25% - 0%
            </div>
        </div>

        <fieldset>
            <legend>Proceso</legend>

            <div class="row">
                <div class="col-md-7 alert alert-info sh" style="height: 100%;">
                    <div class="row no-margin-top">
                        <label class="col-md-3 control-label">
                            Proyecto
                        </label>

                        <div class="col-md-5">
                            ${proceso?.proyecto.toStringCompleto()}
                        </div>
                    </div>

                    <div class="row no-margin-top">
                        <label class="col-md-3 control-label">
                            Fecha inicio</label>

                        <div class="col-md-2">
                            ${proceso.fechaInicio.format("dd-MM-yyyy")}
                        </div>
                        <label class="col-md-2 control-label">Fecha fin</label>

                        <div class="col-md-2">
                            ${proceso.fechaFin.format("dd-MM-yyyy")}
                        </div>
                    </div>

                    <div class="row no-margin-top">
                        <label class="col-md-3 control-label">Nombre</label>

                        <div class="col-md-6">
                            ${proceso.nombre}
                        </div>
                    </div>

                    <div class="row no-margin-top">
                        <label class="col-md-3 control-label">Reportar cada</label>

                        <div class="col-md-4">
                            ${proceso.informar} Días
                        </div>
                    </div>
                </div>

                <div class="col-md-5 alert alert-success sh" style="height: 100%;">
                    <g:set var="dataProceso" value="${proceso.getColorSemaforo()}"/>
                    <div class="row no-margin-top">
                        <label class="col-md-6 control-label">
                            Avance real al ${new java.util.Date().format("dd/MM/yyyy")}:
                        </label>

                        <div class="col-md-4">
                            ${dataProceso[1]}% (a)
                        </div>
                    </div>

                    <div class="row no-margin-top">
                        <label class="col-md-6 control-label">
                            Avance esperado:
                        </label>

                        <div class="col-md-4">
                            ${dataProceso[0].toDouble().round(2)}% (b)
                        </div>
                    </div>

                    <div class="row no-margin-top" style="margin-left: 10px">
                        <div class="semaforo ${dataProceso[2]}" title="Avance esperado al ${new Date().format('dd/MM/yyyy')}: ${dataProceso[0].toDouble().round(2)}%, avance registrado: ${dataProceso[1].toDouble().round(2)}%">
                        </div>
                        <b>Gestión:</b>
                        <g:if test="${dataProceso && dataProceso[0] && dataProceso[0] > 0}">
                            <g:formatNumber number="${dataProceso[1] / dataProceso[0] * 100}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>% (a/b)
                        </g:if>
                    </div>

                    <div class="row no-margin-top" style="margin-top: 5px">
                        <label class="col-md-6 control-label">
                            Último Avance:
                        </label>

                        <div class="col-md-6">
                            ${dataProceso[3]}
                        </div>
                    </div>
                </div>
            </div>
        </fieldset>

        <fieldset>
            <legend>Subactividades</legend>

            <div class="fila" style="margin-bottom: 10px;">
                <a href="#" class="btn btn-success btn-sm btnAgregar" id="btnOpenDlg"><i class="fa fa-plus"></i> Agregar
                </a>
            </div>

            <div id="detalle" style="width: 100%; overflow: auto;"></div>
        </fieldset>

        <script type="text/javascript">
            var max = parseFloat("${maxAvance}");
            var min = parseFloat("${minAvance}");

            function agregarSub() {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action: 'agregarSubact', id: proceso?.id)}",
                    %{--id : ${proceso?.id},--}%
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgAgregarSub",
                            title   : "Agregar Subactividad",
                            message : msg,
                            buttons : {
                                guardar  : {
                                    label     : "<i class='fa fa-save'></i> Guardar",
                                    classname : "btn-success",
                                    callback  : function () {
                                        var aporte = $.trim($("#aporte").val());
                                        var inicio = $.trim($("#inicioSub_input").val());
                                        var fin = $.trim($("#finSub_input").val());
                                        var obs = $.trim($("#observaciones").val());
                                        var id = "${proceso.id}";
                                        if (aporte == "" || inicio == "" || fin == "" || obs.length < 1) {
                                            log("Por favor ingrese el porcentaje de aportación, las fechas y la descripción de la sub actividad", "error")
                                            return false
                                        } else {
                                            if (isNaN(aporte)) {
                                                log("Por favor ingrese un número válido en el porcentaje de avance", "error")
                                                return false
                                            } else {
                                                aporte = parseFloat(aporte);
                                                if (aporte > max) {
                                                    log("El aporte ingresado debe ser un número menor a " + max, "error")
                                                    return false
                                                } else {
                                                    $.ajax({
                                                        type    : "POST",
                                                        url     : "${createLink(action:'addAvanceFisicoProceso_ajax')}",
                                                        data    : {
                                                            id            : id,
                                                            avance        : aporte,
                                                            inicio        : inicio,
                                                            fin           : fin,
                                                            observaciones : obs
                                                        },
                                                        success : function (msg) {
                                                            updateAll(msg);
                                                            var $d = $('#detalle');
                                                            $d.animate({scrollTop : $d[0].scrollHeight}, 1000);
                                                            var parts = msg.split("*");
                                                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                                            if (parts[0] == "SUCCESS") {
                                                                setTimeout(function () {
                                                                    location.reload(true);
                                                                }, 1000);
                                                            } else {
                                                                closeLoader();
                                                            }
                                                        }
                                                    });
                                                }
                                            }
                                        }
                                    }
                                },
                                cancelar : {
                                    label     : "Cancelar",
                                    classname : "btn-primary",
                                    callback  : function () {

                                    }

                                }
                            }
                        })
                    }
                });
            }

            function loadTabla() {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'avanceFisicoProceso_ajax')}",
                    data    : {
                        id : "${proceso.id}"
                    },
                    success : function (msg) {
                        $("#detalle").html(msg);
                    }
                });
            }

            function setMinDate(minDate) {
//                var date = Date.parse(minDate, "dd-MM-yyyy");
//                if (minDate != "") {
//                    $(".datepicker").datepicker("option", "minDate", date);
//                } else {
//                    $(".datepicker").datepicker("option", "minDate", new Date(1900, 0, 1));
//                }
            }

            function updateAll(msg) {
                var parts = msg.split("_");
                if (parts[0] == "OK") {
                    min = parseFloat(parts[1]);
                    max = parseFloat(parts[2]);
                    setMinDate(parts[3]);
                    loadTabla();
                }
            }

            $(function () {
                var mh = 0;
                $(".sh").each(function () {
                    var h = $(this).height();
                    if (mh < h) {
                        mh = h;
                    }
                }).each(function () {
                    $(this).height(mh);
                });

                $(".btnAgregar").click(function () {
                    agregarSub();
                });

                loadTabla();
                setMinDate("${minDate}")
            });
        </script>

    </body>
</html>