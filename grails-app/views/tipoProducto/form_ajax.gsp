<%@ page import="vesta.parametros.TipoProducto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoProductoInstance}">
    <elm:notFound elem="TipoProducto" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTipoProducto" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${tipoProductoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: tipoProductoInstance, field: 'tipoProducto', 'error')} required">
            <span class="grupo">
                <label for="tipoProducto" class="col-md-2 control-label">
                    Tipo Producto
                </label>
                <div class="col-md-6">
                    <g:textField name="tipoProducto" maxlength="31" required="" class="form-control input-sm required" value="${tipoProductoInstance?.tipoProducto}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTipoProducto").validate({
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