<%@ page import="vesta.parametros.TipoElemento" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoElementoInstance}">
    <elm:notFound elem="TipoElemento" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTipoElemento" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${tipoElementoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: tipoElementoInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="15" class="form-control input-sm" value="${tipoElementoInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTipoElemento").validate({
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