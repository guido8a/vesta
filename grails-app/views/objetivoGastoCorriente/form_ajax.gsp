<%@ page import="vesta.poaCorrientes.ObjetivoGastoCorriente" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!objetivoGastoCorrienteInstance}">
    <elm:notFound elem="ObjetivoGastoCorriente" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmObjetivoGastoCorriente" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${objetivoGastoCorrienteInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: objetivoGastoCorrienteInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Objetivo de Gasto Corriente
                </label>
                <div class="col-md-10">
                    <g:textArea name="descripcion" cols="80" rows="7" maxlength="511" required=""
                                class="form-control input-sm required" value="${objetivoGastoCorrienteInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmObjetivoGastoCorriente").validate({
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
                submitFormObjetivoGastoCorriente();
                return false;
            }
            return true;
        });
    </script>

</g:else>