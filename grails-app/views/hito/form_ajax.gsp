<%@ page import="vesta.hitos.Hito" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!hitoInstance}">
    <elm:notFound elem="Hito" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmHito" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${hitoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm required" value="${hitoInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'fechaCumplimiento', 'error')} ">
            <span class="grupo">
                <label for="fechaCumplimiento" class="col-md-2 control-label">
                    Fecha Cumplimiento
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaCumplimiento"  class="datepicker form-control input-sm" value="${hitoInstance?.fechaCumplimiento}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'fechaPlanificada', 'error')} ">
            <span class="grupo">
                <label for="fechaPlanificada" class="col-md-2 control-label">
                    Fecha Planificada
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaPlanificada"  class="datepicker form-control input-sm" value="${hitoInstance?.fechaPlanificada}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'inicio', 'error')} ">
            <span class="grupo">
                <label for="inicio" class="col-md-2 control-label">
                    Inicio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="inicio"  class="datepicker form-control input-sm" value="${hitoInstance?.inicio}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="1024" required="" class="form-control input-sm required" value="${hitoInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'avanceFinanciero', 'error')} required">
            <span class="grupo">
                <label for="avanceFinanciero" class="col-md-2 control-label">
                    Avance Financiero
                </label>
                <div class="col-md-2">
                    <g:field name="avanceFinanciero" type="number" value="${fieldValue(bean: hitoInstance, field: 'avanceFinanciero')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'avanceFisico', 'error')} required">
            <span class="grupo">
                <label for="avanceFisico" class="col-md-2 control-label">
                    Avance Fisico
                </label>
                <div class="col-md-2">
                    <g:field name="avanceFisico" type="number" value="${fieldValue(bean: hitoInstance, field: 'avanceFisico')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: hitoInstance, field: 'tipo', 'error')} required">
            <span class="grupo">
                <label for="tipo" class="col-md-2 control-label">
                    Tipo
                </label>
                <div class="col-md-6">
                    <g:textField name="tipo" required="" class="form-control input-sm required" value="${hitoInstance?.tipo}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmHito").validate({
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