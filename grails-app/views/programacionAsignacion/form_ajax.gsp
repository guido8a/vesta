<%@ page import="vesta.poa.ProgramacionAsignacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!programacionAsignacionInstance}">
    <elm:notFound elem="ProgramacionAsignacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmProgramacionAsignacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${programacionAsignacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'asignacion', 'error')} ">
            <span class="grupo">
                <label for="asignacion" class="col-md-2 control-label">
                    Asignacion
                </label>
                <div class="col-md-6">
                    <g:select id="asignacion" name="asignacion.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" value="${programacionAsignacionInstance?.asignacion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'distribucion', 'error')} ">
            <span class="grupo">
                <label for="distribucion" class="col-md-2 control-label">
                    Distribucion
                </label>
                <div class="col-md-6">
                    <g:select id="distribucion" name="distribucion.id" from="${vesta.avales.DistribucionAsignacion.list()}" optionKey="id" value="${programacionAsignacionInstance?.distribucion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'mes', 'error')} required">
            <span class="grupo">
                <label for="mes" class="col-md-2 control-label">
                    Mes
                </label>
                <div class="col-md-6">
                    <g:select id="mes" name="mes.id" from="${vesta.parametros.poaPac.Mes.list()}" optionKey="id" required="" value="${programacionAsignacionInstance?.mes?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'padre', 'error')} ">
            <span class="grupo">
                <label for="padre" class="col-md-2 control-label">
                    Padre
                </label>
                <div class="col-md-6">
                    <g:select id="padre" name="padre.id" from="${vesta.poa.ProgramacionAsignacion.list()}" optionKey="id" value="${programacionAsignacionInstance?.padre?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'modificacion', 'error')} ">
            <span class="grupo">
                <label for="modificacion" class="col-md-2 control-label">
                    Modificacion
                </label>
                <div class="col-md-6">
                    <g:select id="modificacion" name="modificacion.id" from="${vesta.proyectos.ModificacionProyecto.list()}" optionKey="id" value="${programacionAsignacionInstance?.modificacion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'valor', 'error')} required">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label">
                    Valor
                </label>
                <div class="col-md-2">
                    <g:field name="valor" type="number" value="${fieldValue(bean: programacionAsignacionInstance, field: 'valor')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-2">
                    <g:field name="estado" type="number" value="${programacionAsignacionInstance.estado}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: programacionAsignacionInstance, field: 'cronograma', 'error')} ">
            <span class="grupo">
                <label for="cronograma" class="col-md-2 control-label">
                    Cronograma
                </label>
                <div class="col-md-6">
                    <g:select id="cronograma" name="cronograma.id" from="${vesta.proyectos.Cronograma.list()}" optionKey="id" value="${programacionAsignacionInstance?.cronograma?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmProgramacionAsignacion").validate({
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
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>