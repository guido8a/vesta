<%@ page import="vesta.seguridad.Persona; vesta.proyectos.Proyecto; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Solicitar Reforma del POA</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <elm:container tipo="horizontal" titulo="Asignación de origen">
            <g:form action="save" class="frmProceso">
                <div class="row">
                    <div class="col-md-1">
                        <label>POA año:</label>
                    </div>

                    <div class="col-md-2" id="">
                        <g:select from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" value="${actual?.id}" optionKey="id" optionValue="anio" id="anio" name="anio" class="form-control input-sm"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Proyecto:</label>
                    </div>

                    <div class="col-md-10">
                        <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto.id" id="proyecto"
                                  style="width:100%" class="form-control input-sm" value="${proceso?.proyecto?.id}"
                                  noSelection="['-1': 'Seleccione...']"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Componente:</label>
                    </div>

                    <div class="col-md-10" id="div_comp">
                        <g:select from="${[]}" name="comp" id="comp" noSelection="['-1': 'Seleccione...']" style="width: 100%" class="form-control input-sm"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Actividad:</label>
                    </div>

                    <div class="col-md-10" id="divAct">
                        <g:select from="${[]}" id="actividad" name="actividad" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Asignacion:</label>
                    </div>

                    <div class="col-md-10" id="divAsg">
                        <g:select from="${[]}" id="asignacion" name="origen.id" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm"/>
                    </div>
                </div>

                <div class="row" style="margin-bottom: 10px">
                    <div class="col-md-1">
                        <label>Monto:</label>
                    </div>
                    <input type="hidden" id="valor">

                    <div class="col-md-3">
                        <input type="text" id="monto" class="form-control input-sm number money" style="width: 100px;text-align: right;margin-right: 10px;display: inline-table">
                        Máximo: <span id="max" style="display: inline-block"></span> $

                    </div>
                    <span style="color: #008; ">En caso de incremento registre aquí el valor a incrementar la asignación</span>
                </div>

            </g:form>
        </elm:container>


        <elm:container tipo="horizontal" titulo="Firma" style="">
            <div class="row" style="margin-bottom: 10px">
                <div class="col-md-1">
                    <label>Firma:</label>
                </div>

                <div class="col-md-3">
                    <g:select from="${Persona.findAllByUnidad(session.usuario.unidad, [sort: 'nombre'])}" optionKey="id" optionValue="" id="firma" name="firma" class="form-control input-sm"/>
                </div>
            </div>
        </elm:container>
        <div role="tabpanel" style="margin-top: 20px">

            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#reasignar" aria-controls="reasignar" role="tab" data-toggle="tab">Actividad existente</a>
                </li>
                <li role="presentation"><a href="#nueva" aria-controls="nueva" role="tab" data-toggle="tab">Nueva actividad</a>
                </li>
                <li role="presentation"><a href="#derivada" aria-controls="derivada" role="tab" data-toggle="tab">Nueva partida</a>
                </li>
                <li role="presentation"><a href="#aumentar" aria-controls="aumentar" role="tab" data-toggle="tab">Incremento</a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="reasignar">
                    <elm:container tipo="horizontal" titulo="Asignación de destino." style="">
                        <div class="row">
                            <div class="col-md-1">POA año:</div>

                            <div class="col-md-2">
                                <g:select from="${Anio.list([sort: 'anio'])}" value="${actual?.id}" optionKey="id" optionValue="anio" id="anio_dest" name="anio" class="form-control input-sm"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Proyecto:</div>

                            <div class="col-md-10">
                                <g:select from="${Proyecto.list([sort: 'nombre'])}" optionKey="id" optionValue="nombre" name="proyecto.id" id="proyectoDest" style="width:100%" class="form-control input-sm" value="${proceso?.proyecto?.id}" noSelection="['-1': 'Seleccione...']"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Componente:</div>

                            <div class="col-md-10" id="div_comp_dest">
                                <g:select from="${[]}" name="comp" id="compDest" noSelection="['-1': 'Seleccione...']" style="width: 100%" class="form-control input-sm"/>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-1">Actividad:</div>

                            <div class="col-md-10" id="divAct_dest">
                                <g:select from="${[]}" id="actividad_dest" name="actividad" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Asignacion:</div>

                            <div class="col-md-10" id="divAsg_dest">
                                <g:select from="${[]}" id="asignacion_dest" name="origen.id" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Concepto:</div>

                            <div class="col-md-10">
                                <textarea id="concepto_reasignacion" style="height: 80px" class="form-control input-sm"></textarea>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">
                                <a href="#" id="guardar1" class="btn btn-success">Guardar</a>
                            </div>
                        </div>
                    </elm:container>

                </div>

                <div role="tabpanel" class="tab-pane" id="nueva">
                    <elm:container tipo="horizontal" titulo="Nueva asignación." style="">
                        <div class="row">
                            <div class="col-md-1">POA año:</div>

                            <div class="col-md-2">
                                <g:select from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" value="${actual?.id}" optionKey="id" optionValue="anio" id="anio_nueva" name="anio" class="form-control input-sm"/>
                            </div>
                        </div>

                        <div class="row" style="height: 60px">
                            <div class="col-md-1">Actividad:</div>

                            <div class="col-md-10" style="width: 700px" id="divAct_nueva_">
                                %{--<g:select from="${[]}" id="actividad_nueva" name="actividad" style="width:100%" noSelection="['-1': 'Seleccione']"/>--}%
                                <textarea id="actividad_nueva" style="width: 100%;height: 50px;resize: none" class="form-control input-sm"></textarea>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Incio:</div>

                            <div class="col-md-2">
                                <elm:datepicker class="form-control input-sm fechaInicio"
                                                name="fechaInicio"
                                                title="Fecha de inicio de la actividad"
                                                id="inicio"/>

                            </div>

                            <div class="col-md-1">Fin:</div>

                            <div class="col-md-2">
                                <elm:datepicker class="form-control input-sm fechaFin"
                                                name="fechaFin"
                                                title="Fecha fin de la actividad"
                                                id="fin"
                                                format="dd-MM-yyyy"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Fuente:</div>

                            <div class="col-md-10">
                                <g:select from="${vesta.parametros.poaPac.Fuente.list([sort: 'descripcion'])}" id="fuente" name="fuente" class="form-control input-sm" optionKey="id" optionValue="descripcion"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Partida:</div>

                            <div class="col-md-10">
                                <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search" titulo="Busque una partida" campos="${campos}" clase="required"/>
                                %{--<input type="hidden" class="prsp" value="" id="prsp_id">--}%
                                %{--<input type="text" id="prsp_num" class="buscar form-control input-sm" style="width: 60px;color:black">--}%
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">Concepto:</div>

                            <div class="col-md-10">
                                <textarea id="concepto_nueva" style="height: 80px" class="form-control input-sm"></textarea>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">
                                <a href="#" id="guardar2" class="btn btn-success">Guardar</a>
                            </div>
                        </div>
                    </elm:container>

                </div>

                <div role="tabpanel" class="tab-pane" id="derivada">

                    <div class="row">
                        <div class="col-md-1">Concepto:</div>

                        <div class="col-md-10">
                            <textarea id="concepto_derivada" style="height: 80px" class="form-control input-sm"></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-1">
                            <a href="#" id="guardar3" class="btn btn-success">Guardar</a>
                        </div>
                    </div>
                </div>

                <div role="tabpanel" class="tab-pane" id="aumentar">

                    <div class="row">
                        <div class="col-md-1">Concepto:</div>

                        <div class="col-md-10">
                            <textarea id="concepto_aumentar" style="height: 80px" class="form-control input-sm"></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-1">
                            <a href="#" id="guardar4" class="btn btn-success">Guardar</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>



        <script>

            function getMaximo(asg) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getMaximoAsg',controller: 'avales')}",
                    data    : {
                        id : asg
                    },
                    success : function (msg) {
                        getValor(asg)
                        if ($("#asignacion").val() != "-1") {
                            $("#max").html(number_format(msg, 2, ".", ","));
                            $("#max").attr("valor", msg)
                        } else {
                            var valor = parseFloat(msg);
                            var monto = $("#dlgMonto").val();
//                    monto = monto.replace(new RegExp("\\.", 'g'), "");
                            monto = monto.replace(new RegExp(",", 'g'), "");
                            monto = parseFloat(monto);
                            $("#dlgMax").html(number_format(valor + monto, 2, ".", ","));
                        }
                    }
                });
            }
            function getValor(asg) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getValor',controller: 'modificacionesPoa')}",
                    data    : {
                        id : asg
                    },
                    success : function (msg) {
//                combosInternos()
                        $("#valor").val(msg);
                    }
                });
            }
            function combosInternos() {
//        comboNuevo()
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'cargarActividades',controller: 'modificacionesPoa')}",
                    data    : {
                        id  : $("#comp").val(),
                        div : "divAsg_dest"
                    },
                    success : function (msg) {

                        $("#divAct_dest").html(msg)

                    }
                });
            }
            function comboNuevo() {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'cargarActividades',controller: 'modificacionesPoa')}",
                    data    : {
                        id      : $("#comp").val(),
                        div     : "",
                        comboId : "actividad_nueva"
                    },
                    success : function (msg) {

                        $("#divAct_nueva").html(msg)

                    }
                });
            }

            //$(".decimal").setMask("decimal");
            /*Guardar*/
            $("#guardar1").click(function () {
                var asgDest = $("#asignacion_dest").val()
                var asgOrigen = $("#asignacion").val()
                var monto = $("#monto").val();
//        monto = monto.replace(new RegExp("\\.", 'g'), "");
                monto = monto.replace(new RegExp(",", 'g'), "");
                var max = $("#max").attr("valor")
                var msg = ""
                var concepto = $("#concepto_reasignacion").val()
//        console.log("dest ",asgDest,monto,max,"!"+concepto+"!")
                if (asgOrigen == "-1") {
                    msg += "<br>Por favor, seleccione una asignación de origen"
                }
                if (asgDest == "-1") {
                    msg += "<br>Por favor, seleccione una asignación de destino"
                }
                if (monto == "") {
                    msg += "<br>Por favor, ingrese un monto válido"
                }
                //console.log(monto,max)
                if (isNaN(monto)) {
                    msg += "<br>Por favor, ingrese un monto válido"
                } else {
                    if (monto * 1 <= 0) {
                        msg += "<br>El monto debe ser un número positivo mayor a cero"
                    }
                    if (monto * 1 > max * 1) {
                        msg += "<br>El monto no puede superar al máximo"
                    }
                }
                if (concepto.trim().length == 0) {
                    msg += "<br>Por favor, ingrese concepto"
                }
                if (asgDest == asgOrigen) {
                    msg += "<br>La asignación de destino debe ser diferente a la de origen"
                }
                if (msg == "") {
                    console.log("MONTO??? ", monto);
                    $("#load").dialog("open")
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'guardarSolicitudReasignacion',controller:'modificacionesPoa')}",
                        data    : {
                            origen   : asgOrigen,
                            destino  : asgDest,
                            monto    : monto,
                            concepto : concepto,
                            firma    : $("#firma").val()
                        },
                        success : function (msg) {
                            location.href = "${g.createLink(controller: 'modificacionesPoa',action: 'historialUnidad')}"
                        }
                    });
                } else {
                    bootbox.alert({
                        title   : "Error",
                        message : msg,
                        class   : "modal-error"
                    });
                }

            });

            $("#guardar2").click(function () {
                var asgOrigen = $("#asignacion").val()
                var monto = $("#monto").val();
//        monto = monto.replace(new RegExp("\\.", 'g'), "");
                monto = monto.replace(new RegExp(",", 'g'), "");
                var max = $("#max").attr("valor")
                var msg = ""
                var concepto = $("#concepto_nueva").val()
//        console.log("nueva ",monto,max,"!"+concepto+"!")
                var fuente = $("#fuente").val()
                var presupuesto = $("#prsp_id").val()
                var anio = $("#anio_nueva").val()
                var actividad = $("#actividad_nueva").val()
                var inicio = $("#inicio").val()
                var fin = $("#fin").val()
                if (asgOrigen == "-1") {
                    msg += "<br>Por favor, seleccione una asignación de origen"
                }
                if (monto == "") {
                    msg += "<br>Por favor, ingrese un monto válido"
                }
                if (isNaN(monto)) {
                    msg += "<br>Por favor, ingrese un monto válido"
                } else {
                    if (monto * 1 <= 0) {
                        msg += "<br>El monto debe ser un número positivo mayor a cero"
                    }
                    if (monto * 1 > max * 1) {
                        msg += "<br>El monto no puede superar al máximo"
                    }
                }
                if (concepto.trim().length == 0) {
                    msg += "<br>Por favor, ingrese concepto"
                }
                if (actividad.trim().length == 0) {
                    msg += "<br>Por favor, insgrese una actividad para la nueva asignación"
                }
                if (actividad.trim().length == 1023) {
                    msg += "<br>La actividad debe tener un máximo de 1023 caracteres"
                }
                if (presupuesto == "") {
                    msg += "<br>Por favor, seleccione partida presupuestaria"
                }
                if (inicio == "") {
                    msg += "<br>Por favor, ingrese una fecha de inicio"
                }
                if (fin == "") {
                    msg += "<br>Por favor, ingrese una fecha de fin"
                }
                if (msg == "") {
                    $("#load").dialog("open")
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'guardarSolicitudNueva',controller:'modificacionesPoa')}",
                        data    : {
                            origen      : asgOrigen,
                            monto       : monto,
                            concepto    : concepto,
                            fuente      : fuente,
                            presupuesto : presupuesto,
                            actividad   : actividad,
                            inicio      : inicio,
                            fin         : fin,
                            firma       : $("#firma").val()
                        },
                        success : function (msg) {
                            location.href = "${g.createLink(controller: 'modificacionesPoa',action: 'historialUnidad')}"
                        }
                    });
                } else {
                    bootbox.alert({
                        title   : "Error",
                        message : msg,
                        class   : "modal-error"
                    });

                }

            });

            $("#guardar3").click(function () {

                var asgOrigen = $("#asignacion").val()
                var monto = $("#monto").val();
//        monto = monto.replace(new RegExp("\\.", 'g'), "");
                monto = monto.replace(new RegExp(",", 'g'), "");
                var max = $("#max").attr("valor")
                var msg = ""
                var concepto = $("#concepto_derivada").val()
//        console.log("dest ",asgDest,monto,max,"!"+concepto+"!")
                if (asgOrigen == "-1") {
                    msg += "<br>Por favor, seleccione una asignación de origen"
                }

                if (monto == "") {
                    msg += "<br>Por favor, ingrese un monto válido"
                }
                if (isNaN(monto)) {
                    msg += "<br>Por favor, ingrese un monto válido"
                } else {
                    if (monto * 1 <= 0) {
                        msg += "<br>El monto debe ser un número positivo mayor a cero"
                    }
                    if (monto * 1 > max * 1) {
                        msg += "<br>El monto no puede superar al máximo"
                    }
                }
                if (concepto.trim().length == 0) {
                    msg += "<br>Por favor, ingrese concepto"
                }
                if (msg == "") {
                    $("#load").dialog("open")
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'guardarSolicitudDerivada',controller:'modificacionesPoa')}",
                        data    : {
                            origen   : asgOrigen,
                            monto    : monto,
                            concepto : concepto,
                            firma    : $("#firma").val()
                        },
                        success : function (msg) {
                            location.href = "${g.createLink(controller: 'modificacionesPoa',action: 'historialUnidad')}"
                        }
                    });
                } else {
                    bootbox.alert({
                        title   : "Error",
                        message : msg,
                        class   : "modal-error"
                    });
                }

            });

            $("#guardar4").click(function () {

                var asgOrigen = $("#asignacion").val()

                var max = $("#max").attr("valor")
                var valor = $("#valor").val()
                var msg = ""
                var monto = $("#monto").val();
//        monto = monto.replace(new RegExp("\\.", 'g'), "");
                monto = monto.replace(new RegExp(",", 'g'), "");
                var concepto = $("#concepto_aumentar").val()
//        console.log("dest ",asgDest,monto,max,"!"+concepto+"!")
                if (asgOrigen == "-1") {
                    msg += "<br>Por favor, seleccione una asignación de origen"
                }
                if (monto == "") {
                    msg += "<br>Por favor, ingrese un monto válido"
                }
                if (isNaN(monto)) {
                    msg += "<br>Por favor, ingrese un monto válido"
                } else {
                    if (monto * 1 <= 0) {
                        msg += "<br>El monto debe ser un número positivo mayor a cero"
                    }

                }

                if (concepto.trim().length == 0) {
                    msg += "<br>Por favor, ingrese concepto"
                }
//        if(max!=valor){
//            msg+="No puede eliminar la asignación seleccionada porque tiene avales o solicitudes pendientes."
//        }
                if (msg == "") {
                    $("#load").dialog("open")
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'guardarSolicitudAumentar',controller:'modificacionesPoa')}",
                        data    : {
                            origen   : asgOrigen,
                            monto    : monto,
                            concepto : concepto,
                            firma    : $("#firma").val()
                        },
                        success : function (msg) {
                            location.href = "${g.createLink(controller: 'modificacionesPoa',action: 'historialUnidad')}"
                        }
                    });
                } else {
                    bootbox.alert({
                        title   : "Error",
                        message : msg,
                        class   : "modal-error"
                    });
                }

            });

            $("#guardar").button().click(function () {

            });
            $("#proyecto").change(function () {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'componentesProyecto')}",
                    data    : {
                        id : $("#proyecto").val()
                    },
                    success : function (msg) {
                        $("#div_comp").html(msg)
                    }
                });
            })
            //            .selectmenu({width : 600});
            //    $("#proyecto").selectmenu({width : 600});
            //    $("#comp").selectmenu({width : 600});
            //    $("#actividad").selectmenu({width : 600});
            //    $("#asignacion").selectmenu({width : 600});
            //    $("#compDest").selectmenu({width : 600});
            //    $("#proyectoDest").selectmenu({width : 600});
            //    $("#actividad_dest").selectmenu({width : 600});
            //    $("#asignacion_dest").selectmenu({width : 600});
            //    $("#firma").selectmenu({width : 300});
            //    $("#comp_nueva").selectmenu({width : 600});
            //    $("#actividad_nueva").selectmenu({width : 600});

            $("#proyectoDest").change(function () {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'componentesProyecto')}",
                    data    : {
                        id      : $("#proyectoDest").val(),
                        idCombo : "compDest",
                        div     : "divAct_dest"
                    },
                    success : function (msg) {
                        $("#div_comp_dest").html(msg)
                    }
                });
            })
        </script>
    </body>
</html>