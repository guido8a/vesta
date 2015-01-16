<%@ page import="vesta.proyectos.Estrategia" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!estrategiaInstance}">
    <elm:notFound elem="Estrategia" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmEstrategia" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${estrategiaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: estrategiaInstance, field: 'orden', 'error')} required">
            <span class="grupo">
                <label for="orden" class="col-md-2 control-label">
                    Orden
                </label>
                <div class="col-md-2">
                    <g:field name="orden" type="positive number" value="${estrategiaInstance.orden}" class="digits form-control required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: estrategiaInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripción
                </label>
                <div class="col-md-9">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="511" required="" class="form-control required" style="resize: none" value="${estrategiaInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: estrategiaInstance, field: 'objetivoEstrategico', 'error')} required">
            <span class="grupo">
                <label for="objetivoEstrategico" class="col-md-2 control-label">
                    Objetivo Estratégico
                </label>
                <div class="col-md-9">
                    <g:select id="objetivoEstrategico" name="objetivoEstrategico.id" from="${vesta.proyectos.ObjetivoEstrategicoProyecto.list()}" optionKey="id" required="" value="${estrategiaInstance?.objetivoEstrategico?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmEstrategia").validate({
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