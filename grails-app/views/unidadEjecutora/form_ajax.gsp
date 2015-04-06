<%@ page import="vesta.parametros.UnidadEjecutora" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!unidadEjecutoraInstance}">
    <elm:notFound elem="UnidadEjecutora" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmUnidadEjecutora" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${unidadEjecutoraInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>

                    <div class="col-md-10">
                        <g:textField name="nombre" maxlength="127" required="" class="form-control input-sm required" value="${unidadEjecutoraInstance?.nombre}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'padre', 'error')} ">
                <span class="grupo">
                    <label for="padre" class="col-md-2 control-label">
                        Depende de
                    </label>

                    <div class="col-md-6" style="width: 530px">
                        <g:select id="padre" name="padre.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id"
                                  value="${unidadEjecutoraInstance?.padre?.id}" class="many-to-one form-control input-sm"
                                  noSelection="['null': '']" style="width: 530px"/>
                    </div>

                </span>
                <span class="grupo">
                    <label for="orden" class="col-md-1 control-label" style="margin-left: 30px">
                        Orden
                    </label>

                    <div class="col-md-1">
                        <g:field name="orden" type="number" value="${unidadEjecutoraInstance.orden}"
                                 class="digits form-control input-sm required" required="" style="width: 60px;" />
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'objetivo', 'error')} ">
                <span class="grupo">
                    <label for="objetivo" class="col-md-2 control-label">
                        Misión
                    </label>

                    <div class="col-md-10">
                        <g:textArea name="objetivo" cols="40" rows="2" maxlength="1023" class="form-control input-sm" value="${unidadEjecutoraInstance?.objetivo}"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'objetivoUnidad', 'error')} ">
                <span class="grupo">
                    <label for="objetivoUnidad" class="col-md-2 control-label">
                        Objetivo
                    </label>

                    <div class="col-md-10">
                        <g:select id="objetivoUnidad" name="objetivoUnidad.id" from="${vesta.parametros.proyectos.ObjetivoUnidad.list()}"
                                  optionKey="id" optionValue="descripcion"
                                  value="${unidadEjecutoraInstance?.objetivoUnidad?.id}" class="many-to-one form-control input-sm"
                                  noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'tipoInstitucion', 'error')} ${hasErrors(bean: unidadEjecutoraInstance, field: 'codigo', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="tipoInstitucion" class="col-md-4 control-label">
                            Área de gestión
                        </label>

                        <div class="col-md-8">
                            <g:select id="tipoInstitucion" name="tipoInstitucion.id" from="${vesta.parametros.TipoInstitucion.list()}" optionKey="id" required="" value="${unidadEjecutoraInstance?.tipoInstitucion?.id}" class="many-to-one form-control input-sm"/>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="codigo" class="col-md-4 control-label">
                            Código
                        </label>

                        <div class="col-md-8">
                            <g:textField name="codigo" maxlength="6" class="form-control input-sm unique noEspacios allCaps"  value="${unidadEjecutoraInstance?.codigo}"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'direccion', 'error')} ">
                <span class="grupo">
                    <label for="direccion" class="col-md-2 control-label">
                        Ubicación
                    </label>

                    <div class="col-md-10">
                        <g:textArea name="direccion" maxlength="127" class="form-control input-sm" value="${unidadEjecutoraInstance?.direccion}"
                                    style="height: 40px;"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'telefono', 'error')} ${hasErrors(bean: unidadEjecutoraInstance, field: 'fax', 'error')} ">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="telefono" class="col-md-4 control-label">
                            Teléfono
                        </label>

                        <div class="col-md-8">
                            <g:textField name="telefono" maxlength="63" class="form-control input-sm" value="${unidadEjecutoraInstance?.telefono}"/>
                        </div>

                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fax" class="col-md-4 control-label">
                            Fax
                        </label>

                        <div class="col-md-8">
                            <g:textField name="fax" maxlength="63" class="form-control input-sm" value="${unidadEjecutoraInstance?.fax}"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'email', 'error')} ">
                <span class="grupo">
                    <label for="email" class="col-md-2 control-label">
                        E-mail
                    </label>

                    <div class="col-md-10">
                        <div class="input-group input-group-sm"><span class="input-group-addon"><i class="fa fa-envelope"></i>
                        </span><g:field type="email" name="email" maxlength="63" class="form-control input-sm unique noEspacios" value="${unidadEjecutoraInstance?.email}"/>
                        </div>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'fechaInicio', 'error')} ${hasErrors(bean: unidadEjecutoraInstance, field: 'fechaFin', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaInicio" class="col-md-4 control-label">
                            Fecha Creación
                        </label>

                        <div class="col-md-8">
                            <elm:datepicker name="fechaInicio" mensaje="Fecha de creación" class="datepicker form-control input-sm" value="${unidadEjecutoraInstance?.fechaInicio}"/>
                        </div>

                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="fechaFin" class="col-md-4 control-label">
                            Fecha Fin
                        </label>

                        <div class="col-md-8">
                            <elm:datepicker name="fechaFin" mensaje="Fecha de cierre o final" class="datepicker form-control input-sm" value="${unidadEjecutoraInstance?.fechaFin}"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'observaciones', 'error')} ">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>

                    <div class="col-md-10">
                        %{--<g:textArea name="observaciones" maxlength="127" class="form-control input-sm" value="${unidadEjecutoraInstance?.observaciones}"/>--}%
                        <g:textField name="observaciones" maxlength="127" class="form-control input-sm" value="${unidadEjecutoraInstance?.observaciones}"/>
                    </div>

                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmUnidadEjecutora").validate({
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
            }, rules       : {
                codigo : {
                    remote : {
                        url  : "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type : "post",
                        data : {
                            id : "${unidadEjecutoraInstance?.id}"
                        }
                    }
                },
                email  : {
                    remote : {
                        url  : "${createLink(action: 'validar_unique_email_ajax')}",
                        type : "post",
                        data : {
                            id : "${unidadEjecutoraInstance?.id}"
                        }
                    }
                }

            },
            messages       : {

                codigo : {
                    remote : "Ya existe Código"
                },

                email : {
                    remote : "Ya existe E-mail"
                }

            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormUnidad();
                return false;
            }
            return true;
        });
    </script>

</g:else>