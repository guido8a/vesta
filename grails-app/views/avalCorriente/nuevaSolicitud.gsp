<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 09:59 AM
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Anio; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Nueva solicitud de aval: 1-Proceso de aval</title>

        <link href="${resource(dir: 'css/custom', file: 'wizard.css')}" rel="stylesheet"/>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link action="listaProcesos" class="btn btn-default">
                    <i class="fa fa-bars"></i> Regresar a lista de procesos de avales
                </g:link>
            </div>
        </div>

        <elm:wizardAvalesCorrientes paso="1" proceso="${proceso}" a="${a}"/>

        <g:uploadForm action="saveProcesoWizard" class="form-horizontal wizard-form corner-bottom" name="frmProceso" role="form" method="POST">
            <input type="hidden" name="id" value="${proceso?.id}">
            <input type="hidden" name="a" value="${a}">

            <div class="row grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre del proceso
                </label>

                <div class="col-md-9">
                    <g:if test="${!readOnly}">
                        <g:textArea class="form-control input-sm required"
                                    name="nombreProceso" value="${proceso?.nombreProceso}" id="nombre" title="Nombre del Proceso"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            ${proceso?.nombreProceso}
                        </p>
                    </g:else>
                </div>
            </div>

            <div class="row grupo">
                <label for="fechaInicioProceso" class="col-md-2 control-label">
                    Fecha Inicio (requerimiento de aval)
                </label>

                <div class="col-md-3">
                    <g:if test="${!readOnly}">
                        <elm:datepicker name="fechaInicioProceso" class="datepicker form-control input-sm required" value="${proceso?.fechaInicioProceso}"
                                        onChangeDate="validarFechaIni" minDate="${minDate}" maxDate="${maxDate}"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            ${proceso?.fechaInicioProceso?.format("dd-MM-yyyy")}
                        </p>
                    </g:else>
                </div>


                <label for="fechaFinProceso" class="col-md-2 control-label">
                    Fecha fin de la actividad
                </label>

                <div class="col-md-3">
                    <g:if test="${!readOnly}">
                        <elm:datepicker name="fechaFinProceso" class="datepicker form-control input-sm required" value="${proceso?.fechaFinProceso}"
                                        onChangeDate="validarFechaFin" minDate="${minDate}" maxDate="${maxDate}"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            ${proceso?.fechaFinProceso?.format("dd-MM-yyyy")}
                        </p>
                    </g:else>
                </div>
            </div>

            <div class="row grupo">
                <label for="memo" class="col-md-2 control-label">
                    Doc. de soporte
                </label>

                <div class="col-md-2">
                    <g:if test="${!readOnly}">
                        <g:textField name="memo" class="form-control input-sm " maxlength="63" style="width: 250px"
                                     value="${proceso?.memo}" title="Documento de respaldo"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            ${proceso?.memo}
                        </p>
                    </g:else>
                </div>

                <label for="path" class="col-md-2 control-label" style="margin-left: 10px;">
                    Doc. de respaldo
                </label>

                <div class="col-md-5">
                    <g:if test="${!readOnly}">
                        <g:if test="${proceso?.path}">
                            <input type="hidden" name="path" id="path" value="${proceso?.path}" readonly style="margin-left: -10px"/>
                            Archivo subido:
                            <a href="${resource(dir: 'pdf/solicitudAvalCorriente', file: proceso?.path)}" target="_blank">
                                <i class="fa fa-download"></i> ${proceso?.path}
                            </a>
                        </g:if>
                        <input type="file" name="file" id="file" class="form-control input-sm " style="margin-left: -10px"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            <g:if test="${proceso?.path}">
                                <a href="${resource(dir: 'pdf/solicitudAvalCorriente', file: proceso?.path)}" target="_blank" style="margin-left: -10px">
                                    <i class="fa fa-download"></i> ${proceso?.path}
                                </a>
                            </g:if>
                            <g:else>
                                No ha subido un archivo
                            </g:else>
                        </p>
                    </g:else>
                </div>
            </div>

            <div class="row grupo">
                <label for="concepto" class="col-md-2 control-label">
                    Descripción del proceso (justificación)
                </label>

                <div class="col-md-9">
                    <g:if test="${!readOnly}">
                        <g:textArea name="concepto" maxlength="1024" required="" class="form-control input-sm required"
                                    style="height: 80px;resize: none" value="${proceso?.concepto}" title="Descripción del proceso"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            ${proceso?.concepto}
                        </p>
                    </g:else>
                </div>
            </div>

            <div class="row grupo">
                <label for="director" class="col-md-2 control-label">
                    Pedir revisión de
                </label>

                <div class="col-md-4">
                    <g:if test="${modificar}">
                        <p class="form-control-static">
                            ${proceso?.director}
                        </p>
                    </g:if>
                    <g:else>
                        <g:if test="${!readOnly}">
                            <g:if test="${proceso?.estado?.codigo == 'D01'}">
                                <p class="form-control-static">
                                    ${proceso?.director}
                                </p>
                            </g:if>
                            <g:else>
                            %{--*${solicitud?.directorId}*--}%
                                <g:select from="${personas}" optionKey="id" class="form-control input-sm required"
                                          optionValue="${{
                                              it.nombre + ' ' + it.apellido
                                          }}" name="director" value="${proceso?.directorId}" noSelection="['': '.. Seleccione ..']"/>
                            </g:else>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                ${proceso?.director}
                            </p>
                        </g:else>
                    </g:else>
                </div>
            </div>

            <div class="row grupo">
                <label for="notaTecnica" class="col-md-2 control-label">
                    Nota Técnica
                </label>

                <div class="col-md-9">
                    <g:if test="${!readOnly}">
                        <g:textArea name="notaTecnica" style="resize: none" maxlength="350" class="form-control input-sm"
                                    value="${proceso?.notaTecnica}" title="Nota técnica"/>
                    </g:if>
                    <g:else>
                        <p class="form-control-static">
                            ${proceso?.notaTecnica}
                        </p>
                    </g:else>
                </div>
            </div>

            <g:if test="${!readOnly}">
                <div class="row">
                    <div class="col-md-3 col-md-offset-8 text-right">
                        <a href="#" class="btn btn-success" id="btnOk" title="Guardar y pasar a asignaciones">
                            <i class="fa fa-save"></i> Guardar y Continuar <i class="fa fa-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </g:if>
        </g:uploadForm>

        <script type="text/javascript">
            function validarFechaIni($elm, e) {
                $("#fechaFinProceso_input").data("DateTimePicker").setMinDate(e.date);
            }
            function validarFechaFin($elm, e) {
                $('#fechaInicioProceso_input').data("DateTimePicker").setMaxDate(e.date);
            }

            $(function () {
                $("#frmProceso").validate({
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

                $("#btnOk").click(function () {
                    openLoader("Guardando");
                    $("#frmProceso").submit();
                    return false;
                });

            });
        </script>

    </body>
</html>