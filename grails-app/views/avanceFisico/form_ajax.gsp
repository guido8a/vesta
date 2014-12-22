<%@ page import="vesta.hitos.AvanceFisico" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!avanceFisicoInstance}">
    <elm:notFound elem="AvanceFisico" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAvanceFisico" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${avanceFisicoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'proceso', 'error')} required">
            <span class="grupo">
                <label for="proceso" class="col-md-2 control-label">
                    Proceso
                </label>
                <div class="col-md-6">
                    <g:select id="proceso" name="proceso.id" from="${vesta.avales.ProcesoAval.list()}" optionKey="id" required="" value="${avanceFisicoInstance?.proceso?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-6">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="1024" class="form-control" value="${avanceFisicoInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'completado', 'error')} ">
            <span class="grupo">
                <label for="completado" class="col-md-2 control-label">
                    Completado
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="completado"  class="datepicker form-control" value="${avanceFisicoInstance?.completado}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'inicio', 'error')} ">
            <span class="grupo">
                <label for="inicio" class="col-md-2 control-label">
                    Inicio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="inicio"  class="datepicker form-control" value="${avanceFisicoInstance?.inicio}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'fin', 'error')} ">
            <span class="grupo">
                <label for="fin" class="col-md-2 control-label">
                    Fin
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fin"  class="datepicker form-control" value="${avanceFisicoInstance?.fin}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'avance', 'error')} required">
            <span class="grupo">
                <label for="avance" class="col-md-2 control-label">
                    Avance
                </label>
                <div class="col-md-2">
                    <g:field name="avance" type="number" value="${fieldValue(bean: avanceFisicoInstance, field: 'avance')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFisicoInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha"  class="datepicker form-control required" value="${avanceFisicoInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAvanceFisico").validate({
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