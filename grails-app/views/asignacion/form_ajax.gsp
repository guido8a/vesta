<%@ page import="vesta.poa.Asignacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!asignacionInstance}">
    <elm:notFound elem="Asignacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAsignacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${asignacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'anio', 'error')} ">
            <span class="grupo">
                <label for="anio" class="col-md-2 control-label">
                    Anio
                </label>
                <div class="col-md-7">
                    <g:select id="anio" name="anio.id" from="${vesta.parametros.poaPac.Anio.list()}" optionKey="id" value="${asignacionInstance?.anio?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'fuente', 'error')} ">
            <span class="grupo">
                <label for="fuente" class="col-md-2 control-label">
                    Fuente
                </label>
                <div class="col-md-7">
                    <g:select id="fuente" name="fuente.id" from="${vesta.parametros.poaPac.Fuente.list()}" optionKey="id" value="${asignacionInstance?.fuente?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'marcoLogico', 'error')} ">
            <span class="grupo">
                <label for="marcoLogico" class="col-md-2 control-label">
                    Marco Logico
                </label>
                <div class="col-md-7">
                    <g:select id="marcoLogico" name="marcoLogico.id" from="${vesta.proyectos.MarcoLogico.list()}" optionKey="id" value="${asignacionInstance?.marcoLogico?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'actividad', 'error')} ">
            <span class="grupo">
                <label for="actividad" class="col-md-2 control-label">
                    Actividad
                </label>
                <div class="col-md-7">
                    <g:textArea name="actividad" cols="40" rows="5" maxlength="1024" class="form-control" value="${asignacionInstance?.actividad}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'presupuesto', 'error')} ">
            <span class="grupo">
                <label for="presupuesto" class="col-md-2 control-label">
                    Presupuesto
                </label>
                <div class="col-md-7">
                    <g:select id="presupuesto" name="presupuesto.id" from="${vesta.parametros.poaPac.Presupuesto.list()}" optionKey="id" value="${asignacionInstance?.presupuesto?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'tipoGasto', 'error')} ">
            <span class="grupo">
                <label for="tipoGasto" class="col-md-2 control-label">
                    Tipo Gasto
                </label>
                <div class="col-md-7">
                    <g:select id="tipoGasto" name="tipoGasto.id" from="${vesta.parametros.TipoGasto.list()}" optionKey="id" value="${asignacionInstance?.tipoGasto?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'componente', 'error')} ">
            <span class="grupo">
                <label for="componente" class="col-md-2 control-label">
                    Componente
                </label>
                <div class="col-md-7">
                    <g:select id="componente" name="componente.id" from="${vesta.poa.Componente.list()}" optionKey="id" value="${asignacionInstance?.componente?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'planificado', 'error')} required">
            <span class="grupo">
                <label for="planificado" class="col-md-2 control-label">
                    Planificado
                </label>
                <div class="col-md-3">
                    <g:field name="planificado" type="number" value="${fieldValue(bean: asignacionInstance, field: 'planificado')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'redistribucion', 'error')} required">
            <span class="grupo">
                <label for="redistribucion" class="col-md-2 control-label">
                    Redistribucion
                </label>
                <div class="col-md-3">
                    <g:field name="redistribucion" type="number" value="${fieldValue(bean: asignacionInstance, field: 'redistribucion')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'unidad', 'error')} ">
            <span class="grupo">
                <label for="unidad" class="col-md-2 control-label">
                    Unidad
                </label>
                <div class="col-md-7">
                    <g:select id="unidad" name="unidad.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${asignacionInstance?.unidad?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'reubicada', 'error')} ">
            <span class="grupo">
                <label for="reubicada" class="col-md-2 control-label">
                    Reubicada
                </label>
                <div class="col-md-7">
                    <g:textField name="reubicada" maxlength="2" class="form-control" value="${asignacionInstance?.reubicada}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'programa', 'error')} ">
            <span class="grupo">
                <label for="programa" class="col-md-2 control-label">
                    Programa
                </label>
                <div class="col-md-7">
                    <g:select id="programa" name="programa.id" from="${vesta.parametros.poaPac.ProgramaPresupuestario.list()}" optionKey="id" value="${asignacionInstance?.programa?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'meta', 'error')} ">
            <span class="grupo">
                <label for="meta" class="col-md-2 control-label">
                    Meta
                </label>
                <div class="col-md-7">
                    <g:textArea name="meta" cols="40" rows="5" maxlength="255" class="form-control" value="${asignacionInstance?.meta}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'indicador', 'error')} ">
            <span class="grupo">
                <label for="indicador" class="col-md-2 control-label">
                    Indicador
                </label>
                <div class="col-md-7">
                    <g:textArea name="indicador" cols="40" rows="5" maxlength="255" class="form-control" value="${asignacionInstance?.indicador}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'padre', 'error')} required">
            <span class="grupo">
                <label for="padre" class="col-md-2 control-label">
                    Padre
                </label>
                <div class="col-md-7">
                    <g:select id="padre" name="padre.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" required="" value="${asignacionInstance?.padre?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: asignacionInstance, field: 'priorizado', 'error')} required">
            <span class="grupo">
                <label for="priorizado" class="col-md-2 control-label">
                    Priorizado
                </label>
                <div class="col-md-3">
                    <g:field name="priorizado" type="number" value="${fieldValue(bean: asignacionInstance, field: 'priorizado')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAsignacion").validate({
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