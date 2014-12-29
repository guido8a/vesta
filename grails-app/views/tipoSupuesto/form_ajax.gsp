<%@ page import="vesta.parametros.TipoSupuesto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoSupuestoInstance}">
    <elm:notFound elem="TipoSupuesto" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTipoSupuesto" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${tipoSupuestoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: tipoSupuestoInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${tipoSupuestoInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTipoSupuesto").validate({
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