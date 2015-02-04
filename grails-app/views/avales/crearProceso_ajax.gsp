<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/01/15
  Time: 02:29 PM
--%>

<%@ page import="vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Anio; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<g:form action="saveProceso" class="form-horizontal" name="frmProceso" role="form" method="POST" id="${proceso?.id}">
    <input type="hidden" name="id" value="${proceso?.id}">

    <div class="form-group keeptogether">
        <span class="grupo">
            <label class="col-md-2 control-label">
                Proyecto
            </label>

            <div class="col-md-4">
                <g:select name="proyecto.id" from="${proyectos}" class="form-control input-sm" value="${proceso?.proyecto?.id}" optionKey="id" optionValue="descripcion" id="proyecto"/>
            </div>
        </span>
    </div>


    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="fechaInicio" class="col-md-2 control-label">
                Fecha Inicio
            </label>

            <div class="col-md-3">
                <elm:datepicker name="fechaInicio" class="datepicker form-control input-sm" value="${proceso?.fechaInicio}"/>
            </div>
        </span>
    </div>


    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="fechaFin" class="col-md-2 control-label">
                Fecha Fin
            </label>

            <div class="col-md-3">
                <elm:datepicker name="fechaFin" class="datepicker form-control input-sm" value="${proceso?.fechaFin}"/>
            </div>
        </span>
    </div>

    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="informar" class="col-md-2 control-label">
                Informar cada:
            </label>

            <div class="col-md-3">
                <g:textField class="form-control input-sm"
                             name="informar" title="Plazo de Ejecución" value="${proceso?.informar}" id="informar"/>
            </div>

            <div>
                <label>Días</label>
            </div>
        </span>
    </div>

    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="nombre" class="col-md-2 control-label">
                Nombre:
            </label>

            <div class="col-md-3">
                <g:textField class="form-control input-sm"
                             name="nombre" value="${proceso?.nombre}" id="nombre"/>
            </div>
        </span>
    </div>
</g:form>
%{--</fieldset>--}%
<g:if test="${proceso && band}">
    <fieldset style="width: 95%;height: 260px;" class="ui-corner-all">
        <legend>Agregar asignaciones</legend>
        <input type="hidden" id="idAgregar">

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Año:
                </label>

                <div class="col-md-2">
                    <g:select name="anio" from="${Anio.list([sort: 'anio'])}" value="${actual?.id}" class="form-control input-sm" id="anio" optionKey="id" optionValue="anio"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Componente
                </label>

                <div class="col-md-4" id="div_comp">
                    <g:select name="comp" from="${MarcoLogico.findAllByProyectoAndTipoElemento(proceso?.proyecto, TipoElemento.get(2))}" class="form-control input-sm" optionKey="id" optionValue="objeto" id="comp" noSelection="['-1': 'Seleccione...']"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Actividad
                </label>

                <div class="col-md-4" id="divAct">
                    <g:select name="actividad" from="${[]}" class="form-control input-sm" id="actividad" noSelection="['-1': 'Seleccione...']"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Asignación
                </label>

                <div class="col-md-4" id="divAsg">
                    <g:select name="asignacion" from="${[]}" class="form-control input-sm" id="asignacion" noSelection="['-1': 'Seleccione...']"/>
                </div>
            </span>
        </div>


        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto:
                </label>

                <div class="col-md-3">
                    <g:textField class="form-control input-sm number money" name="montoName" style="text-align: right; margin-right: 10px" id="monto"/>
                </div>

                <div class="col-md-3">
                    <label>Máximo <span id="max" style="display: inline-block"></span> $</label>
                </div>

                <div class="col-md-1">
                    <a href="#" class="btn btn-success" id="agregar"><i class="fa fa-plus"></i></a>
                </div>

            </span>
        </div>

    </fieldset>
</g:if>

<fieldset style="width: 95%;height: 300px;overflow: auto; margin-top: 30px" class="ui-corner-all">
    <legend>Asignaciones</legend>

    <div id="detalle" style="width: 95%"></div>
</fieldset>

<script>

    function editarAsg(id, max) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'editarAsignacion')}",
            data    : {
                band : ${band},
                id   : id,
                max  : max
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEdit",
                    title : "Editar asignación",

                    class : "modal-lg",

                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {

                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            }
        });
    }

    function getMaximo(asg, monto) {
        var maximof;
        $.ajax({
            type    : "POST",
            async   : false,
            url     : "${createLink(action:'getMaximoAsg')}",
            data    : {
                id : asg
            },
            success : function (msg) {
                if ($("#asignacion").val() != "-1")
                    maximof = msg;
                else {
                    var valor = parseFloat(msg);
                    monto = parseFloat(monto);
                    maximof = valor + monto
                }
            },
            error   : function () {
                maximof = monto
            }
        });
        return maximof
    }
    function getDetalle() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'getDetalle')}",
            data    : {
                id : "${proceso?.id}"
            },
            success : function (msg) {
                $("#detalle").html(msg)
            }
        });
    }
    ;

    function vaciar() {
        $("#monto").val("");
        $("#max").html("");
        $("#asignacion").val("-1");
    }

    <g:if test="${proceso}">
    getDetalle();
    </g:if>

    $("#anio").change(function () {
        $("#comp").val("-1");
        $("#actividad").val("-1");
        $("#asignacion").val("-1");
        $("#monto").val("");
        $("#max").html("");
    });

    $("#agregar").click(function () {
        var id = $("#idAgregar").val();
        var monto = $("#monto").val();
        monto = monto.replace(new RegExp(",", 'g'), "");
        var max = $("#max").html();
        max = max.replace(new RegExp(",", 'g'), "");
        var asg = $("#asignacion").val();
        var proceso = "${proceso?.id}";

        var msg = "";
        if (asg == "-1" || isNaN(asg)) {
            msg += "<br>Debe seleccionar una asignación.";
        } else {

            if (isNaN(monto) || monto == "") {
                msg += "<br>El monto tiene que ser un número positivo.";
            } else {
                if (monto * 1 < 0)
                    msg += "<br>El monto tiene que ser un número positivo.";
                if (monto * 1 > max * 1)
                    msg += "<br>El monto no puede ser mayor al máximo.";
            }
        }

        if (msg == "") {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'agregarAsignacion')}",
                data    : {
                    id      : id,
                    proceso : proceso,
                    monto   : monto,
                    asg     : asg
                },
                success : function (msg) {
                    getDetalle();
                    vaciar();
                }
            });
        } else {
            bootbox.dialog({
                title   : "Error",
                message : msg,
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    }
                }
            });
        }
    });

    $("#comp").change(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividades')}",
            data    : {
                id     : $("#comp").val(),
                unidad : "${unidad?.id}"
            },
            success : function (msg) {
                $("#divAct").html(msg)
            }
        });
    });

    $(function () {

        var validator = $("#frmProceso").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
                label.remove();
            }
        });

    });

</script>
