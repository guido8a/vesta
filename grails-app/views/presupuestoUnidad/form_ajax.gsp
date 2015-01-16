<%@ page import="vesta.parametros.PresupuestoUnidad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!presupuestoUnidadInstance}">
    <elm:notFound elem="PresupuestoUnidad" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmPresupuestoUnidad" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${presupuestoUnidadInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'unidad', 'error')} required">
            <span class="grupo">
                <label for="unidad" class="col-md-2 control-label">
                    Unidad
                </label>
                <div class="col-md-7">
                    <g:select id="unidad" name="unidad.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" required="" value="${presupuestoUnidadInstance?.unidad?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'anio', 'error')} required">
            <span class="grupo">
                <label for="anio" class="col-md-2 control-label">
                    Anio
                </label>
                <div class="col-md-7">
                    <g:select id="anio" name="anio.id" from="${vesta.parametros.poaPac.Anio.list()}" optionKey="id" required="" value="${presupuestoUnidadInstance?.anio?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'maxInversion', 'error')} required">
            <span class="grupo">
                <label for="maxInversion" class="col-md-2 control-label">
                    Max Inversion
                </label>
                <div class="col-md-3">
                    <g:field name="maxInversion" type="number" value="${fieldValue(bean: presupuestoUnidadInstance, field: 'maxInversion')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'maxCorrientes', 'error')} required">
            <span class="grupo">
                <label for="maxCorrientes" class="col-md-2 control-label">
                    Max Corrientes
                </label>
                <div class="col-md-3">
                    <g:field name="maxCorrientes" type="number" value="${fieldValue(bean: presupuestoUnidadInstance, field: 'maxCorrientes')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'ejeProgramatico', 'error')} ">
            <span class="grupo">
                <label for="ejeProgramatico" class="col-md-2 control-label">
                    Eje Programatico
                </label>
                <div class="col-md-7">
                    <g:select id="ejeProgramatico" name="ejeProgramatico.id" from="${vesta.proyectos.EjeProgramatico.list()}" optionKey="id" value="${presupuestoUnidadInstance?.ejeProgramatico?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'objetivoEstrategico', 'error')} ">
            <span class="grupo">
                <label for="objetivoEstrategico" class="col-md-2 control-label">
                    Objetivo Estrategico
                </label>
                <div class="col-md-7">
                    <g:select id="objetivoEstrategico" name="objetivoEstrategico.id" from="${vesta.proyectos.ObjetivoEstrategicoProyecto.list()}" optionKey="id" value="${presupuestoUnidadInstance?.objetivoEstrategico?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'objetivoGobiernoResultado', 'error')} ">
            <span class="grupo">
                <label for="objetivoGobiernoResultado" class="col-md-2 control-label">
                    Objetivo Gobierno Resultado
                </label>
                <div class="col-md-7">
                    <g:select id="objetivoGobiernoResultado" name="objetivoGobiernoResultado.id" from="${vesta.parametros.proyectos.ObjetivoGobiernoResultado.list()}" optionKey="id" value="${presupuestoUnidadInstance?.objetivoGobiernoResultado?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'politica', 'error')} ">
            <span class="grupo">
                <label for="politica" class="col-md-2 control-label">
                    Politica
                </label>
                <div class="col-md-7">
                    <g:select id="politica" name="politica.id" from="${vesta.parametros.proyectos.Politica.list()}" optionKey="id" value="${presupuestoUnidadInstance?.politica?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'aprobadoCorrientes', 'error')} required">
            <span class="grupo">
                <label for="aprobadoCorrientes" class="col-md-2 control-label">
                    Aprobado Corrientes
                </label>
                <div class="col-md-3">
                    <g:field name="aprobadoCorrientes" type="number" value="${presupuestoUnidadInstance.aprobadoCorrientes}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'aprobadoInversion', 'error')} required">
            <span class="grupo">
                <label for="aprobadoInversion" class="col-md-2 control-label">
                    Aprobado Inversion
                </label>
                <div class="col-md-3">
                    <g:field name="aprobadoInversion" type="number" value="${presupuestoUnidadInstance.aprobadoInversion}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'originalCorrientes', 'error')} required">
            <span class="grupo">
                <label for="originalCorrientes" class="col-md-2 control-label">
                    Original Corrientes
                </label>
                <div class="col-md-3">
                    <g:field name="originalCorrientes" type="number" value="${fieldValue(bean: presupuestoUnidadInstance, field: 'originalCorrientes')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: presupuestoUnidadInstance, field: 'originalInversion', 'error')} required">
            <span class="grupo">
                <label for="originalInversion" class="col-md-2 control-label">
                    Original Inversion
                </label>
                <div class="col-md-3">
                    <g:field name="originalInversion" type="number" value="${fieldValue(bean: presupuestoUnidadInstance, field: 'originalInversion')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmPresupuestoUnidad").validate({
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