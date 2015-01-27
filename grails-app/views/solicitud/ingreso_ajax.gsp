<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 31/12/14
  Time: 10:54 AM
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 11/08/14
  Time: 12:10 PM
--%>

<%@ page import="vesta.parametros.TipoBien; vesta.parametros.FormaPago; vesta.parametros.TipoContrato; vesta.poa.Actividad; vesta.poa.Componente; vesta.proyectos.Proyecto" contentType="text/html;charset=UTF-8" %>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<g:if test="${!solicitud}">
    <elm:notFound elem="Solicitud" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

    <g:form class="form-horizontal" name="frmSolicitud" role="form" action="save" method="POST" id="${solicitud?.id}">

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="unidad" class="col-md-2 control-label">
                    Unidad Requirente
                </label>
                <div class="col-md-7">
                    <g:textField name="unidad" class="form-control input-sm" readonly="" value="${unidadRequirente?.nombre}"/>
                </div>

            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="proyecto.id" class="col-md-2 control-label">
                    Proyecto
                </label>
                <div class="col-md-7">
                    <g:select name="proyecto.id" from="${proyectos}" class="form-control input-sm" value="${solicitud.actividad?.proyectoId}" optionKey="id" optionValue="nombre" required="" id="selProyecto"/>
                </div>

            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="tdComponente" class="col-md-2 control-label">
                    Componente
                </label>
                <div class="col-md-7" id="tdComponente">
                </div>

            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="actividad" class="col-md-2 control-label">
                    Actividad
                </label>
                <div class="col-md-7" id="tdActividad">
                </div>

            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="nombreProceso" class="col-md-2 control-label">
                    Nombre del proceso
                </label>
                <div class="col-md-7">
                    <g:textField class="form-control input-sm"
                                 name="nombreProceso" title="Nombre del proceso" value="${solicitud.nombreProceso}"/>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="formaPago" class="col-md-2 control-label required">
                    Forma de Pago
                </label>
                <div class="col-md-3">
                    <g:textField class="form-control input-sm required"
                                 name="formaPago" title="Forma de Pago" value="${solicitud?.formaPago}"/>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="plazoEjecucion" class="col-md-2 control-label">
                    Plazo de Ejecución
                </label>
                <div class="col-md-3">
                    <g:textField class="form-control input-sm"
                                 name="plazoEjecucion" title="Plazo de Ejecución" value="${solicitud?.plazoEjecucion}"/>
                </div>
                <div>
                    <label>Días</label>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-3">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm" value="${new Date()}"/>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="montoSolicitado" class="col-md-2 control-label">
                    Monto Solicitado
                </label>
                <g:if test="${solicitud.id}">
                    <div class="col-md-3">
                        <g:textField class="form-control input-sm number money"
                                     name="montoSolicitado" title="Monto Solicitado" value="${solicitud?.montoSolicitado}" readonly=""/>
                    </div>
                <a href="#" class="btn btn-info btnMontoDetalle">Detalle</a>
                </g:if>
                <g:else>
                    <div class="col-md-3">
                        <g:textField class="form-control input-sm number money"
                                     name="montoSolicitado" title="Monto Solicitado" value="${solicitud?.montoSolicitado}"/>
                    </div>
                </g:else>
                <label>(Detallado: <span id="spanAsg">${asignado}</span>)</label>
            </span>
        </div>
        <div class="form-group keeptogether">
            <div class="col-md-4">
            <span class="grupo">
                <label class="col-md-6 control-label">
                    Tipo de Bien
                </label>
                <div class="col-md-6">
                    <g:select name="tipoBien.id" from="${vesta.parametros.TipoBien.list()}" class="form-control input-sm" value="${solicitud.tipoBienId}" optionKey="id" optionValue="descripcion" id="selBien"/>
                </div>
            </span>
        </div>
        <div class="col-md-6">
            <span class="grupo">
                <label class="col-md-4 control-label">
                    Modalidad de contratación
                </label>
                <div class="col-md-6">
                    <g:select name="tipoContrato.id" from="${TipoContrato.list()}" class="form-control input-sm" value="${solicitud.tipoContratoId}" optionKey="id" optionValue="descripcion" id="selContrato"/>
                </div>
            </span>
        </div>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="objetoContrato" class="col-md-2 control-label">
                   Objeto del Contrato
                </label>
                <div class="col-md-7">
                    <g:textArea name="objetoContrato" cols="4" rows="6" maxlength="1023" class="form-control input-sm required" value="${solicitud?.objetoContrato}" style="resize: none"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    T.D.R.
                </label>
                <div class="col-md-7">
                    <input type="file" name="tdr" class="${solicitud.pathPdfTdr ? '' : 'required'}"/>
                    <g:if test="${solicitud.pathPdfTdr}">
                        <br/>
                        Archivo actual:
                        ${solicitud.pathPdfTdr}
                    </g:if>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Oferta 1
                </label>
                <div class="col-md-7">
                    <input type="file" name="oferta1"/>
                    <g:if test="${solicitud.pathOferta1}">
                        <br/>
                        Archivo actual:
                        ${solicitud.pathOferta1}
                    </g:if>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Oferta 2
                </label>
                <div class="col-md-7">
                    <input type="file" name="oferta2"/>
                    <g:if test="${solicitud.pathOferta2}">
                        <br/>
                        Archivo actual:
                        ${solicitud.pathOferta2}
                    </g:if>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Oferta 3
                </label>
                <div class="col-md-7">
                    <input type="file" name="oferta3"/>
                    <g:if test="${solicitud.pathOferta3}">
                        <br/>
                        Archivo actual:
                        ${solicitud.pathOferta3}
                    </g:if>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Cuadro Comparativo
                </label>
                <div class="col-md-7">
                    <input type="file" name="comparativo"/>
                    <g:if test="${solicitud.pathCuadroComparativo}">
                        <br/>
                        Archivo actual:
                        ${solicitud.pathCuadroComparativo}
                    </g:if>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Análisis de costos
                </label>
                <div class="col-md-7">
                    <input type="file" name="analisis"/>
                    <g:if test="${solicitud.pathAnalisisCostos}">
                        <br/>
                        Archivo actual:
                        ${solicitud.pathAnalisisCostos}
                    </g:if>
                </div>
            </span>
        </div>
    </g:form>
    </div>
</g:else>


<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div id="dlgDetalleMonto" title="Detalle anual del monto solicitado">
    <div id="dlgDetalleMontoContent">
    </div>
</div>

<script type="text/javascript">


    function loadComponentes() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'getComponentesByProyecto')}",
            data    : {
                id    : $("#selProyecto").val(),
                val   : "${solicitud.actividad?.marcoLogicoId}"
            },
            success : function (msg) {
                $("#tdComponente").html(msg);
                loadActividades();
            }
        });
    }
    function loadActividades() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'getActividadesByComponente')}",
            data    : {
                id    : $("#selComponente").val(),
                val   : "${solicitud.actividadId}"
            },
            success : function (msg) {
                $("#tdActividad").html(msg);
                $("#btnAddActividad").remove();
                var btn = $("<div class='col-md-2'><a href='#' id='btnAddActividad' class='button btn btn-success btn-sm' style='margin-left: 3px;'><i class='fa fa-plus'></i></a></div>");
                $("#tdActividad").after(btn);
                btn.click(function () {
                    crearActividad();
                });

                loadDatosActividad();
            }
        });
    }

    function loadDatosActividad() {
        var actividadId = $("#selActividad").val();
        if ("${solicitud.actividadId}" == actividadId) {
            $("#nombreProceso").val("${solicitud.nombreProceso}");
            $("#montoSolicitado").val(number_format("${solicitud.montoSolicitado}", 2, '.', ''))
                    .attr("max2", number_format("${solicitud.montoSolicitado}", 2, '.', ''));
        } else {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'getDatosActividad')}",
                data    : {
                    id : actividadId
                },
                success : function (msg) {
                    var parts = msg.split("||");
                    $("#nombreProceso").val(parts[0]);
                    $("#montoSolicitado").val(number_format(parts[1], 2, '.', ''))
                            .attr("max2", number_format(parts[1], 2, '.', ''));
                    if (parts[2] == "0") {
                        $("#divPoa").show();
                    } else {
                        $("#divPoa").hide();
                    }
                    $("#plazoEjecucion").val(parts[3]);
                }
            });
        }
    }

    function crearActividad() {
        var proySt = $("#selProyecto").find("option:selected").text();
        var compSt = $("#selComponente").find("option:selected").text();

        var proyId = $("#selProyecto").val();
        var compId = $("#selComponente").val();

        $("#proyectoLabel").text(proySt);
        $("#componenteLabel").text(compSt);

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'nuevaActividad')}",
            data    : {
                proy : proyId,
                comp : compId
            },
            success : function (msg) {

                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Crear nueva Actividad",

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
                                return submitFormActividad();
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

    function resetActividadForm() {
        $("#nuevaActividad").val("");
        $("#nuevaCategoria").val("");
        $("#fechaInicio").val("");
        $("#fechaFin").val("");
        $("#nuevoMonto").val("");
        $("#nuevoAporte").val("");
    }

    function dayDiff(d1, d2) {
        var t2 = d2.getTime();
        var t1 = d1.getTime();

        return parseInt((t2 - t1) / (24 * 3600 * 1000));
    }

    function editarMonto () {
        $.ajax({
           type : "POST",
           url  :  "${createLink(action: 'detalleMonto')}",
           data :  {
               id: "${solicitud?.id}",
               actividad : $("#selActividad").val()
           },
           success : function (msg){
               var b = bootbox.dialog({
                   id : "dlgMonto",
                   title: "Detalle anual del monto solicitado",
                   class :"modal-lg",
                   message : msg,
                   buttons : {
                       cancelar : {
                           label : "Cancelar",
                           className: "btn-primary",
                           callback : function () {}
                       },
                       guardar : {
                           id : "btnSave",
                           label : "<i class='fa fa-save'></i> Guardar ",
                           className : "btn-success",
                           callback   : function () {
                               var $dlg = $(this);
                               var total = 0;
                               var maximo = parseFloat($("#spanMax").attr("max"));
                               var data = "";
                               $("#tb").children().each(function () {
                                   var val = parseFloat($(this).attr("val"));
                                   var anio = parseFloat($(this).attr("class"));
                                   data += anio + "_" + val + ";";
                                   total += val;
                               });
                               if (total != maximo) {
                                   log("Por favor ingrese valores cuya sumatoria sea igual a $" + number_format(maximo, 2, ".", ","), 'error')
                                   return false
                               } else {
                                   $.ajax({
                                       type    : "POST",
                                       url     : "${createLink(action:'updateDetalleMonto_ajax')}",
                                       data    : {
                                           id      : "${solicitud.id}",
                                           valores : data
                                       },
                                       success : function (msg) {
                                               var parts1 = msg.split("*");
                                               var solicitado = parts1[2];
                                               var asignado = parts1[3];

                                               $("#spanAsg").text(asignado);
                                               $("#montoSolicitado").val(solicitado);
                                           var parts = msg.split("*");
                                           log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                           if (parts[0] == "SUCCESS") {
//                                               setTimeout(function() {
//                                                   location.reload(true);
//                                               }, 1000);
                                           } else {
                                               closeLoader();
                                           }


                                       }
                                   });
                               }


                           }//callback
                       }//guardar
                   }//buttons
               });//dialog
               setTimeout(function () {
                   b.find(".form-control").first().focus()
               }, 500);
           }//success
        });//ajax
    }//createEdit

    function submitFormActividad() {
        var $form = $("#frmNuevaActividad");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Actividad");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        closeLoader();
                        if (parts[0] == "SUCCESS") {
//                            location.reload(true);
                            loadActividades();
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
                }
            });
        } else {
            return false;
        } //else
    }

    $(function () {

        var validator = $("#frmSolicitud").validate({
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

        $("#btnPrint").click(function () {
            var url = "${createLink(controller: 'reporteSolicitud', action: 'imprimirSolicitud')}/?id=${solicitud.id}";
//                    console.log(url);
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf";
            return false;
        });

        %{--<g:if test="${solicitud.id}">--}%
        $(".btnMontoDetalle").click(function () {
           editarMonto()
           return false;
        });
        %{--</g:if>--}%

        $("#btnIncluir").click(function () {
            var txt = "¿Está seguro de querer ";
            if ($(this).data("tipo") == "S") {
                txt += "incluir esta solicitud en la próxima reunión de aprobación?";
            } else {
                txt += "quitar esta solicitud de la próxima reunión de aprobación?";
            }
            $.box({
                imageClass : "box_info",
                text       : txt,
                title      : "Confirmación",
                iconClose  : false,
                dialog     : {
                    resizable     : false,
                    draggable     : false,
                    closeOnEscape : false,
                    buttons       : {
                        "Aceptar"  : function () {
                            location.href = "${createLink(action:'incluirReunion')}/${solicitud.id}"
                        },
                        "Cancelar" : function () {
                        }
                    }
                }
            });
            return false;
        });



        $("#selProyecto").change(function () {
            loadComponentes();
        })
        loadComponentes();


    });
</script>

