%{--
<fieldset class="ui-corner-all" style="min-height: 100px;font-size: 11px; align-content: center">
    <legend>
        Actividades y Tareas
        <div class="" style="color: #5cb74c" id="divColor1">
            Editando...
        </div>
    </legend>

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
        <thead>
        <tr>
            <th style="width: 450px">Actividad gasto permanente</th>
            <th style="width: 450px">Tarea</th>
            <th style="width: 240px">Acciones</th>
        </tr>
        </thead>
        <tr>
            <td id="tdActividad"></td>
            <td id="tdTarea"></td>
            <td>
                <div class="btn-group btn-group-sm" role="group" style="width: 240px; align-items: center" id="grupoBotones">
                    <a href="#" id="crearActividad" class="btn btn-primary" title="Crear Actvidad"><i class="fa fa-plus"></i> Crear Actividad</a>
                    <a href="#" id="editarActividad" class="btn btn-success hide" title="Editar Actvidad"><i class="fa fa-pencil"></i> Editar Actividad</a>
                    <a href="#" id="crearTarea" class="btn btn-info" title="Crear Tarea"><i class="fa fa-plus"></i> Crear Tarea</a>
                    <a href="#" id="editarTarea" class="btn btn-success hide" title="Editar Tarea"><i class="fa fa-pencil"></i> Editar Tarea</a>
                </div>
            </td>
        </tr>
    </table>
</fieldset>
--}%

<script type="text/javascript">
    $("#editarActividad").click(function () {
        $.ajax({
            type: "POST",
            url     : "${createLink(controller: 'asignacion', action:'actividadCreacion_ajax')}",
            data    : {
                anio : $("#anio").val(),
                objetivo: $("#objetivo").val(),
                macro   : $("#mac").val(),
                actividad : $("#act").val()

            },
            success: function(msg) {
                bootbox.dialog ({
                    id: "dlgCrearActividad",
                    title: "Editar Actividad",
//                        class: "modal-lg",
                    message: msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar : {
                            label     : "Guardar",
                            className : "btn-success",
                            callback  : function () {
                                if($("#creacionActividad").val()){
                                    if($("#metaActividad").val()){
                                        $.ajax({
                                            type: "POST",
                                            url     : "${createLink(controller: 'asignacion', action:'guardarActividad_ajax')}",
                                            data    : {
                                                id: $("#act").val(),
                                                anio : $("#anio").val(),
                                                macro: $("#mac").val(),
                                                obj: $("#objetivo").val(),
                                                desc: $("#creacionActividad").val(),
                                                meta :$("#metaActividad").val()
                                            },
                                            success: function(msg) {
                                                var parts = msg.split("*");
                                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                if (parts[0] == "SUCCESS") {
                                                    $("#divColor1").removeClass("show").addClass("hide");
                                                    $("#divColor2").removeClass("show").addClass("hide");
                                                    $("#anio").prop('disabled', false);
                                                    $("#mac").prop('disabled',false);
                                                    $("#objetivo").prop('disabled',false);
                                                    estadoAnterior();
                                                    $.ajax({
                                                        type    : "POST",
                                                        url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                        data    : {
                                                            id   : $("#mac").val(),
                                                            anio : $("#anio").val()

                                                        },
                                                        success : function (msg) {
                                                            $("#tdActividad").html(msg);

                                                            $("#tdTarea").html("");
                                                        }
                                                    });
                                                }
                                            }
                                        })
                                    } else{
                                        log("Ingrese una meta!", "error");
                                        return
                                    }
                                }else{
                                    log("Ingrese una descripción!", "error");
                                    return
                                }
                            }
                        }
                    }
                })
            }
        });
    });

    $("#editarTarea").click(function () {
        $.ajax({
            type: "POST",
            url     : "${createLink(controller: 'asignacion', action:'tareaCreacion_ajax')}",
            data    : {
                anio : $("#anio").val(),
                objetivo: $("#objetivo").val(),
                macro   : $("#mac").val(),
                acti:   $("#act").val(),
                id : $("#tar").val()
            },
            success: function(msg) {
                bootbox.dialog ({
                    id: "dlgCreartarea",
                    title: "Editar Tarea",
//                        class: "modal-lg",
                    message: msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar : {
                            label     : "Guardar",
                            className : "btn-success",
                            callback  : function () {
                                if($("#creacionTarea").val()){
                                    $.ajax({
                                        type: "POST",
                                        url     : "${createLink(controller: 'asignacion', action:'guardarTarea_ajax')}",
                                        data    : {
                                            actividad: $("#act").val(),
                                            desc: $("#creacionTarea").val(),
                                            id: $("#tar").val()

                                        },
                                        success: function(msg) {
                                            var parts = msg.split("*");
                                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                            if (parts[0] == "SUCCESS") {
                                                estadoAnterior();
                                                $.ajax({
                                                    type    : "POST",
                                                    url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                    data    : {
                                                        id   : $("#mac").val(),
                                                        anio : $("#anio").val()

                                                    },
                                                    success : function (msg) {
                                                        $("#tdActividad").html(msg);
//                                                                $("#tdTarea").html("");
                                                        $.ajax({
                                                            type    : "POST",
                                                            url     : "${createLink(action:'tarea_ajax',controller: 'asignacion')}",
                                                            data    : {
                                                                id   : $("#act").val()

                                                            },
                                                            success : function (msg) {
                                                                $("#tdTarea").html(msg);
                                                            }
                                                        });
                                                    }
                                                });

                                            }
                                        }
                                    })
                                }else{
                                    log("Ingrese un nombre!", "error")
                                    return
                                }
                            }
                        }
                    }
                })
            }
        });

    });

    $("#crearActividad").click(function () {
        if($("#mac").val() != -1){
            $.ajax({
                type: "POST",
                url     : "${createLink(controller: 'asignacion', action:'actividadCreacion_ajax')}",
                data    : {
                    anio : $("#anio").val(),
                    objetivo: $("#objetivo").val(),
                    macro   : $("#mac").val()

                },
                success: function(msg) {
                    bootbox.dialog ({
                        id: "dlgCrearActividad",
                        title: "Crear Actividad",
//                        class: "modal-lg",
                        message: msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            guardar : {
                                label     : "Guardar",
                                className : "btn-success",
                                callback  : function () {
                                    if($("#creacionActividad").val()){
                                        if($("#metaActividad").val()){
                                            $.ajax({
                                                type: "POST",
                                                url     : "${createLink(controller: 'asignacion', action:'guardarActividad_ajax')}",
                                                data    : {
                                                    anio : $("#anio").val(),
                                                    macro: $("#mac").val(),
                                                    obj: $("#objetivo").val(),
                                                    desc: $("#creacionActividad").val(),
                                                    meta :$("#metaActividad").val()
                                                },
                                                success: function(msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                    if (parts[0] == "SUCCESS") {
                                                        $("#divColor1").removeClass("show").addClass("hide");
                                                        $("#divColor2").removeClass("show").addClass("hide");
                                                        $("#anio").prop('disabled', false);
                                                        $("#mac").prop('disabled',false);
                                                        $("#objetivo").prop('disabled',false);
                                                           estadoAnterior();
                                                                $.ajax({
                                                                    type    : "POST",
                                                                    url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                                    data    : {
                                                                        id   : $("#mac").val(),
                                                                        anio : $("#anio").val()

                                                                    },
                                                                    success : function (msg) {
                                                                        $("#tdActividad").html(msg);

                                                                        $("#tdTarea").html("");
                                                                    }
                                                                });
                                                    }
                                                }
                                            })
                                        } else{
                                            log("Ingrese una meta!", "error");
                                            return
                                        }
                                    }else{
                                        log("Ingrese una descripción!", "error");
                                        return
                                    }


                                }
                            }
                        }
                    })
                }
            });
        }else{
            log("Elija una macro actividad!", "error")
            return
        }

    });


    $("#crearTarea").click(function () {
        if($("#act").val() != -1 || $("#act").val() != '-1'){
            $.ajax({
                type: "POST",
                url     : "${createLink(controller: 'asignacion', action:'tareaCreacion_ajax')}",
                data    : {
                    anio : $("#anio").val(),
                    objetivo: $("#objetivo").val(),
                    macro   : $("#mac").val(),
                    acti:   $("#act").val()
                },
                success: function(msg) {
                    bootbox.dialog ({
                        id: "dlgCreartarea",
                        title: "Crear Tarea",
//                        class: "modal-lg",
                        message: msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            guardar : {
                                label     : "Guardar",
                                className : "btn-success",
                                callback  : function () {
                                    if($("#creacionTarea").val()){
                                            $.ajax({
                                                type: "POST",
                                                url     : "${createLink(controller: 'asignacion', action:'guardarTarea_ajax')}",
                                                data    : {
                                                    actividad: $("#act").val(),
                                                    desc: $("#creacionTarea").val()

                                                },
                                                success: function(msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                    if (parts[0] == "SUCCESS") {
                                                        estadoAnterior();
                                                        $.ajax({
                                                            type    : "POST",
                                                            url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                            data    : {
                                                                id   : $("#mac").val(),
                                                                anio : $("#anio").val()

                                                            },
                                                            success : function (msg) {
                                                                $("#tdActividad").html(msg);
//                                                                $("#tdTarea").html("");
                                                                $.ajax({
                                                                type    : "POST",
                                                                url     : "${createLink(action:'tarea_ajax',controller: 'asignacion')}",
                                                                data    : {
                                                                id   : $("#act").val()

                                                                },
                                                                success : function (msg) {
                                                                $("#tdTarea").html(msg);
                                                                }
                                                                });
                                                            }
                                                        });

                                                    }
                                                }
                                            })
                                    }else{
                                        log("Ingrese un nombre!", "error")
                                        return
                                    }
                                }
                            }
                        }
                    })
                }
            });
        }else{
            log("Seleccione una actividad!", "error");
            return
        }

    });
</script>