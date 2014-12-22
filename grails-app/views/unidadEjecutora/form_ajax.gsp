<%@ page import="vesta.parametros.UnidadEjecutora" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!unidadEjecutoraInstance}">
    <elm:notFound elem="UnidadEjecutora" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmUnidadEjecutora" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${unidadEjecutoraInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'tipoInstitucion', 'error')} required">
            <span class="grupo">
                <label for="tipoInstitucion" class="col-md-2 control-label">
                    Tipo Institucion
                </label>
                <div class="col-md-7">
                    <g:select id="tipoInstitucion" name="tipoInstitucion.id" from="${vesta.parametros.TipoInstitucion.list()}" optionKey="id" required="" value="${unidadEjecutoraInstance?.tipoInstitucion?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'provincia', 'error')} ">
            <span class="grupo">
                <label for="provincia" class="col-md-2 control-label">
                    Provincia
                </label>
                <div class="col-md-7">
                    <g:select id="provincia" name="provincia.id" from="${vesta.parametros.geografia.Provincia.list()}" optionKey="id" value="${unidadEjecutoraInstance?.provincia?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-7">
                    <g:textField name="codigo" maxlength="4" class="form-control unique noEspacios" value="${unidadEjecutoraInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'fechaInicio', 'error')} ">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label">
                    Fecha Inicio
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaInicio" mensaje="Fecha de creación"  class="datepicker form-control" value="${unidadEjecutoraInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'fechaFin', 'error')} ">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label">
                    Fecha Fin
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaFin" mensaje="Fecha de cierre o final"  class="datepicker form-control" value="${unidadEjecutoraInstance?.fechaFin}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'padre', 'error')} ">
            <span class="grupo">
                <label for="padre" class="col-md-2 control-label">
                    Padre
                </label>
                <div class="col-md-7">
                    <g:select id="padre" name="padre.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${unidadEjecutoraInstance?.padre?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-7">
                    <g:textField name="nombre" maxlength="127" required="" class="form-control required" value="${unidadEjecutoraInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label for="direccion" class="col-md-2 control-label">
                    Direccion
                </label>
                <div class="col-md-7">
                    <g:textField name="direccion" maxlength="127" class="form-control" value="${unidadEjecutoraInstance?.direccion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'sigla', 'error')} ">
            <span class="grupo">
                <label for="sigla" class="col-md-2 control-label">
                    Sigla
                </label>
                <div class="col-md-7">
                    <g:textField name="sigla" maxlength="7" class="form-control" value="${unidadEjecutoraInstance?.sigla}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'objetivo', 'error')} ">
            <span class="grupo">
                <label for="objetivo" class="col-md-2 control-label">
                    Objetivo
                </label>
                <div class="col-md-7">
                    <g:textArea name="objetivo" cols="40" rows="5" maxlength="1023" class="form-control" value="${unidadEjecutoraInstance?.objetivo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label">
                    Telefono
                </label>
                <div class="col-md-7">
                    <g:textField name="telefono" maxlength="63" class="form-control" value="${unidadEjecutoraInstance?.telefono}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'fax', 'error')} ">
            <span class="grupo">
                <label for="fax" class="col-md-2 control-label">
                    Fax
                </label>
                <div class="col-md-7">
                    <g:textField name="fax" maxlength="63" class="form-control" value="${unidadEjecutoraInstance?.fax}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'email', 'error')} ">
            <span class="grupo">
                <label for="email" class="col-md-2 control-label">
                    Email
                </label>
                <div class="col-md-7">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="email" maxlength="63" class="form-control unique noEspacios" value="${unidadEjecutoraInstance?.email}"/></div>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textField name="observaciones" maxlength="127" class="form-control" value="${unidadEjecutoraInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'objetivoUnidad', 'error')} ">
            <span class="grupo">
                <label for="objetivoUnidad" class="col-md-2 control-label">
                    Objetivo Unidad
                </label>
                <div class="col-md-7">
                    <g:select id="objetivoUnidad" name="objetivoUnidad.id" from="${vesta.parametros.proyectos.ObjetivoUnidad.list()}" optionKey="id" value="${unidadEjecutoraInstance?.objetivoUnidad?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'orden', 'error')} required">
            <span class="grupo">
                <label for="orden" class="col-md-2 control-label">
                    Orden
                </label>
                <div class="col-md-3">
                    <g:field name="orden" type="number" value="${unidadEjecutoraInstance.orden}" class="digits form-control required" required=""/>
                </div>
                 *
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
            }
            
            , rules          : {
                
                codigo: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${unidadEjecutoraInstance?.id}"
                        }
                    }
                },
                
                email: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_email_ajax')}",
                        type: "post",
                        data: {
                            id: "${unidadEjecutoraInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigo: {
                    remote: "Ya existe Codigo"
                },
                
                email: {
                    remote: "Ya existe Email"
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
    </script>

</g:else>