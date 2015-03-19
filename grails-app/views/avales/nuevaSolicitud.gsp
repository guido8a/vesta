<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 18/03/15
  Time: 03:17 PM
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
        <g:set var="monto" value="${proceso?.getMonto() ?: 0}"/>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="wizard-container row">
            <div class="col-md-4 wizard-step wizard-next-step corner-left wizard-current">
                <span class="badge wizard-badge">1</span> Proceso de aval
            </div>

            <g:if test="${proceso?.id}">
                <div class="col-md-4 wizard-step wizard-next-step wizard-available">
                    <span class="badge wizard-badge">2</span>
                    <g:link action="solicitudAsignaciones" id="${proceso.id}" title="Continuar sin guardar cambios">
                        Asignaciones
                    </g:link>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-4 wizard-step wizard-next-step wizard-not-completed">
                    <span class="badge wizard-badge">2</span> Asignaciones
                </div>
            </g:else>

            <g:if test="${monto > 0}">
                <div class="col-md-4 wizard-step corner-right wizard-available">
                    <span class="badge wizard-badge">3</span>
                    <g:link action="solicitudProceso" id="${proceso.id}" title="Continuar sin guardar cambios">
                        Solicitud
                    </g:link>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-4 wizard-step corner-right wizard-not-completed">
                    <span class="badge wizard-badge">3</span> Solicitud
                </div>
            </g:else>
        </div>

        <g:form action="saveProcesoWizard" class="form-horizontal wizard-form corner-bottom" name="frmProceso" role="form" method="POST">
            <input type="hidden" name="id" value="${proceso?.id}">

            <div class="row">
                <span class="grupo">
                    <label class="col-md-2 control-label">
                        Proyecto
                    </label>

                    <div class="col-md-9">
                        %{--<g:select name="proyecto.id" from="${proyectos}" class="form-control input-sm required" value="${proceso?.proyecto?.id}" optionKey="id" optionValue="descripcion" id="proyecto"/>--}%
                        <g:select name="proyecto.id" from="${proyectos}" class="form-control input-sm required" optionKey="id" optionValue="nombre" id="proyecto"/>
                    </div>
                </span>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>

                    <div class="col-md-9">
                        <g:textArea class="form-control input-sm required"
                                    name="nombre" value="${proceso?.nombre}" id="nombre"/>
                    </div>
                </span>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>

                    <div class="col-md-3">
                        <g:set var="hoy" value="${new Date().format('dd/MM/yyyy')}"/>
                        <elm:datepicker name="fechaInicio" class="datepicker form-control input-sm required" value="${proceso?.fechaInicio}"
                                        onChangeDate="validarFechaIni" minDate="${new Date()}"/>
                    </div>
                </span>
                %{--</div>--}%


                %{--<div class="row">--}%
                <span class="grupo">
                    <label for="fechaFin" class="col-md-2 control-label">
                        Fecha Fin
                    </label>

                    <div class="col-md-3">
                        <elm:datepicker name="fechaFin" class="datepicker form-control input-sm required" value="${proceso?.fechaFin}"
                                        onChangeDate="validarFechaFin" minDate="${new Date()}"/>
                    </div>
                </span>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="informar" class="col-md-2 control-label">
                        Informar cada
                    </label>

                    <div class="col-md-2">
                        <div class="input-group">
                            <g:textField class="form-control input-sm required"
                                         name="informar" title="Plazo de Ejecución" value="${proceso?.informar}" id="informar"/>
                            <span class="input-group-addon" id="basic-addon2">Días</span>
                        </div>
                    </div>

                </span>
            </div>

            <div class="row">
                <div class="col-md-3 col-md-offset-8 text-right">
                    <a href="#" class="btn btn-success" id="btnOk">
                        <i class="fa fa-save"></i> Guardar y Continuar <i class="fa fa-chevron-right"></i>
                    </a>
                </div>
            </div>
        </g:form>

        <script type="text/javascript">
            function validarFechaIni($elm, e) {
                $("#fechaFin_input").data("DateTimePicker").setMinDate(e.date);
            }
            function validarFechaFin($elm, e) {
                $('#fechaInicio_input').data("DateTimePicker").setMaxDate(e.date);
            }

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

                $("#btnOk").click(function () {
                    $("#frmProceso").submit();
                });

            });
        </script>

    </body>
</html>