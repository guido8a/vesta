<%@ page import="vesta.hitos.ComposicionHito" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!composicionHitoInstance}">
    <elm:notFound elem="ComposicionHito" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmComposicionHito" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${composicionHitoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'hito', 'error')} required">
            <span class="grupo">
                <label for="hito" class="col-md-2 control-label">
                    Hito
                </label>
                <div class="col-md-6">
                    <g:select id="hito" name="hito.id" from="${vesta.hitos.Hito.list()}" optionKey="id" required="" value="${composicionHitoInstance?.hito?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'marcoLogico', 'error')} ">
            <span class="grupo">
                <label for="marcoLogico" class="col-md-2 control-label">
                    Marco Logico
                </label>
                <div class="col-md-6">
                    <g:select id="marcoLogico" name="marcoLogico.id" from="${vesta.proyectos.MarcoLogico.list()}" optionKey="id" value="${composicionHitoInstance?.marcoLogico?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'proyecto', 'error')} ">
            <span class="grupo">
                <label for="proyecto" class="col-md-2 control-label">
                    Proyecto
                </label>
                <div class="col-md-6">
                    <g:select id="proyecto" name="proyecto.id" from="${vesta.proyectos.Proyecto.list()}" optionKey="id" value="${composicionHitoInstance?.proyecto?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'proceso', 'error')} ">
            <span class="grupo">
                <label for="proceso" class="col-md-2 control-label">
                    Proceso
                </label>
                <div class="col-md-6">
                    <g:select id="proceso" name="proceso.id" from="${vesta.avales.ProcesoAval.list()}" optionKey="id" value="${composicionHitoInstance?.proceso?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm required" value="${composicionHitoInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'avanceFinanciero', 'error')} required">
            <span class="grupo">
                <label for="avanceFinanciero" class="col-md-2 control-label">
                    Avance Financiero
                </label>
                <div class="col-md-2">
                    <g:field name="avanceFinanciero" type="number" value="${fieldValue(bean: composicionHitoInstance, field: 'avanceFinanciero')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: composicionHitoInstance, field: 'avanceFisico', 'error')} required">
            <span class="grupo">
                <label for="avanceFisico" class="col-md-2 control-label">
                    Avance Fisico
                </label>
                <div class="col-md-2">
                    <g:field name="avanceFisico" type="number" value="${fieldValue(bean: composicionHitoInstance, field: 'avanceFisico')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmComposicionHito").validate({
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