<%@ page import="vesta.parametros.Localizacion; vesta.parametros.UnidadEjecutora; vesta.parametros.proyectos.Programa; vesta.proyectos.Portafolio; vesta.proyectos.Estrategia; vesta.proyectos.ObjetivoEstrategicoProyecto; vesta.proyectos.Proyecto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!proyectoInstance}">
    <elm:notFound elem="Proyecto" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmProyecto" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${proyectoInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'objetivoEstrategico', 'error')} ">
                <span class="grupo">
                    <label for="objetivoEstrategico" class="col-md-3 control-label">
                        Objetivo Estratégico
                    </label>

                    <div class="col-md-9">
                        <g:select id="objetivoEstrategico" name="objetivoEstrategico.id"
                                  from="${ObjetivoEstrategicoProyecto.list([sort: 'descripcion'])}"
                                  optionKey="id"
                                  value="${proyectoInstance?.objetivoEstrategico?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"
                                  title="Objetivo estratégico del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'estrategia', 'error')} ">
                <span class="grupo">
                    <label for="estrategia" class="col-md-3 control-label">
                        Estrategia
                    </label>

                    <div class="col-md-9" id="divEstrategia">
                        <g:select id="estrategia" name="estrategia.id" from="${Estrategia.list([sort: 'descripcion'])}"
                                  optionKey="id"
                                  value="${proyectoInstance?.estrategia?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"
                                  title="Estrategia del proyecto"/> %{--si se cambia este title cambiar tambien en ProyectoController/estrategiaPorObjetivo_ajax--}%
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'portafolio', 'error')} ">
                <span class="grupo">
                    <label for="portafolio" class="col-md-3 control-label">
                        Portafolio
                    </label>

                    <div class="col-md-9">
                        <g:select id="portafolio" name="portafolio.id" from="${Portafolio.list([sort: 'descripcion'])}"
                                  optionKey="id" optionValue="descripcion" value="${proyectoInstance?.portafolio?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"
                                  title="Portafolio del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'programa', 'error')} ">
                <span class="grupo">
                    <label for="programa" class="col-md-3 control-label">
                        Programa
                    </label>

                    <div class="col-md-9">
                        <g:select id="programa" name="programa.id" from="${Programa.list([sort: 'descripcion'])}"
                                  optionKey="id" optionValue="descripcion" value="${proyectoInstance?.programa?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"
                                  title="Programa del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-3 control-label">
                        Nombre
                    </label>

                    <div class="col-md-9">
                        <g:textField name="nombre" maxlength="255" required="" class="form-control input-sm required" value="${proyectoInstance?.nombre}"
                                     title="Nombre del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'unidadAdministradora', 'error')} ">
                <span class="grupo">
                    <label for="unidadAdministradora" class="col-md-3 control-label">
                        Área de gestión
                    </label>

                    <div class="col-md-9">
                        <g:select id="unidadAdministradora" name="unidadAdministradora.id" from="${UnidadEjecutora.list([sort: 'nombre'])}"
                                  optionKey="id" value="${proyectoInstance?.unidadAdministradora?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"
                                  title="Área de gestión encargada del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'unidadAdministradora', 'error')} ">
                <span class="grupo">
                    <label for="unidadAdministradora" class="col-md-3 control-label">
                        Localización
                    </label>

                    <div class="col-md-9">
                        <g:select id="localizacion" name="localizacion.id" from="${Localizacion.list([sort: 'descripcion'])}"
                                  optionKey="id" value="${proyectoInstance?.localizacion?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"
                                  title="Localización del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'codigo', 'error')} ${hasErrors(bean: proyectoInstance, field: 'codigoProyecto', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="codigo" class="col-md-6 control-label">
                            Código
                        </label>

                        <div class="col-md-6">
                            <g:textField name="codigo" class="form-control input-sm unique noEspacios" value="${proyectoInstance?.codigo}"
                                         title="Código"/>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="codigoProyecto" class="col-md-6 control-label">
                            Código Proyecto
                        </label>

                        <div class="col-md-6">
                            <g:textField name="codigoProyecto" maxlength="24" class="form-control input-sm unique noEspacios" value="${proyectoInstance?.codigoProyecto}"
                                         title="Código del proyecto"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'monto', 'error')} ${hasErrors(bean: proyectoInstance, field: 'codigoEsigef', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="monto" class="col-md-6 control-label">
                            Costo total
                        </label>

                        <div class="col-md-6">
                            <div class="input-group input-group-sm">
                                <g:textField name="monto" value="${fieldValue(bean: proyectoInstance, field: 'monto')}"
                                             class="number money form-control input-sm "
                                             title="Costo total del proyecto"/>
                                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                            </div>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="codigoEsigef" class="col-md-6 control-label">
                            Código financiero
                        </label>

                        <div class="col-md-6">
                            <g:textField name="codigoEsigef" maxlength="3" class="form-control input-sm unique noEspacios"
                                         value="${proyectoInstance?.codigoEsigef}"
                                         title="Código financiero del proyecto"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaInicioPlanificada', 'error')} ${hasErrors(bean: proyectoInstance, field: 'fechaInicio', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaInicioPlanificada" class="col-md-6 control-label">
                            Fecha Inicio Planificada
                        </label>

                        <div class="col-md-6">
                            <elm:datepicker name="fechaInicioPlanificada" class="datepicker form-control input-sm"
                                            value="${proyectoInstance?.fechaInicioPlanificada}" onChangeDate="validaFechasPlan"
                                            title="Fecha de inicio planificada para el proyecto"/>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaInicio" class="col-md-6 control-label">
                            Fecha Inicio
                        </label>

                        <div class="col-md-6">
                            <elm:datepicker name="fechaInicio" class="datepicker form-control input-sm"
                                            value="${proyectoInstance?.fechaInicio}" onChangeDate="validaFechas"
                                            title="Fecha de inicio real del proyecto"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'fechaInicioPlanificada', 'error')} ${hasErrors(bean: proyectoInstance, field: 'fechaInicio', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaInicioPlanificada" class="col-md-6 control-label">
                            Fecha Fin Planificada
                        </label>

                        <div class="col-md-6">
                            <elm:datepicker name="fechaFinPlanificada" class="datepicker form-control input-sm"
                                            value="${proyectoInstance?.fechaFinPlanificada}"
                                            title="Fecha de fin planificada para el proyecto"/>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaInicio" class="col-md-6 control-label">
                            Fecha Fin
                        </label>

                        <div class="col-md-6">
                            <elm:datepicker name="fechaFin" class="datepicker form-control input-sm"
                                            value="${proyectoInstance?.fechaFin}"
                                            title="Fecha de fin real del proyecto"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'problema', 'error')} ">
                <span class="grupo">
                    <label for="problema" class="col-md-3 control-label">
                        Diagnóstico e identificación
                    </label>

                    <div class="col-md-9">
                        <g:textArea name="problema" cols="40" rows="2" maxlength="1024" class="form-control input-sm" value="${proyectoInstance?.problema}"
                                    title="Diagnóstico e identificación del proyecto"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'justificacion', 'error')} ">
                <span class="grupo">
                    <label for="justificacion" class="col-md-3 control-label">
                        Justificación
                    </label>

                    <div class="col-md-9">
                        <g:textArea name="justificacion" cols="40" rows="2" maxlength="1023" class="form-control input-sm"
                                    value="${proyectoInstance?.justificacion}"
                                    title="Justificación del proyecto"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-3 control-label">
                        Descripción
                    </label>

                    <div class="col-md-9">
                        <g:textArea name="descripcion" cols="40" rows="2" maxlength="1024" class="form-control input-sm" value="${proyectoInstance?.descripcion}"
                                    title="Descripción del proyecto"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-3 control-label">
                        Población beneficiaria
                    </label>

                    <div class="col-md-9">
                        <g:textArea name="poblacion" cols="40" rows="2" maxlength="1023" class="form-control input-sm" value="${proyectoInstance?.poblacion}"
                                    title="Población beneficiada por el proyecto"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: proyectoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-3 control-label">
                        Objetivo general
                    </label>

                    <div class="col-md-9">
                        <g:textArea name="objetivoGeneral" cols="40" rows="2" maxlength="1023" class="form-control input-sm" value="${proyectoInstance?.objetivoGeneral}"
                                    title="Objetivo general del proyecto"/>
                    </div>

                </span>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        function validaFechasPlan($elm, e) {
            $("#fechaFinPlanificada_input").data("DateTimePicker").setMinDate(e.date);
        }
        function validaFechas($elm, e) {
            $("#fechaFin_input").data("DateTimePicker").setMinDate(e.date);
        }

        function loadEstrategias() {
            var spinnerUrl = "${resource(dir:'images', file:'spinner.gif')}";
            var spinner = "<img src='" + spinnerUrl + "'/>";
            $("#divEstrategia").html(spinner);
            var id = $("#objetivoEstrategico").val();
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'proyecto', action:'estrategiaPorObjetivo_ajax')}",
                data    : {
                    id       : id,
                    proy__id : $("#id").val()
                },
                success : function (msg) {
                    $("#divEstrategia").html(msg);
                },
                error   : function (jqXHR, textStatus, errorThrown) {
                    $("#divEstrategia").html("Ha ocurrido un error: <strong>" + errorThrown + "</strong>. Por favor inténtelo nuevamente.");
                }
            });
        }
        $(function () {
            loadEstrategias();
            var validator = $("#frmProyecto").validate({
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
                },
                rules          : {
                    codigoProyecto : {
                        remote : {
                            url  : "${createLink(action: 'validar_unique_codigoProyecto_ajax')}",
                            type : "post",
                            data : {
                                id : "${proyectoInstance?.id}"
                            }
                        }
                    },

                    codigoEsigef : {
                        remote : {
                            url  : "${createLink(action: 'validar_unique_codigoEsigef_ajax')}",
                            type : "post",
                            data : {
                                id : "${proyectoInstance?.id}"
                            }
                        }
                    },

                    codigo : {
                        remote : {
                            url  : "${createLink(action: 'validar_unique_codigo_ajax')}",
                            type : "post",
                            data : {
                                id : "${proyectoInstance?.id}"
                            }
                        }
                    }

                },
                messages       : {

                    codigoProyecto : {
                        remote : "Ya existe Codigo Proyecto"
                    },

                    codigoEsigef : {
                        remote : "Ya existe Codigo Esigef"
                    },

                    codigo : {
                        remote : "Ya existe Codigo"
                    }

                }

            });
            $(".form-control").keydown(function (ev) {
                if (ev.keyCode == 13) {
                    submitForm();
                    return false;
                }
                return true;
            });
            $("#objetivoEstrategico").change(function () {
                loadEstrategias();
            });
        });


    </script>

</g:else>