<%@ page import="vesta.parametros.poaPac.Mes" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!mesInstance}">
    <elm:notFound elem="Mes" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmMes" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${mesInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: mesInstance, field: 'numero', 'error')} required">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label">
                    Numero
                </label>
                <div class="col-md-2">
                    <g:field name="numero" type="number" value="${mesInstance.numero}" class="digits form-control required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: mesInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="15" class="form-control" value="${mesInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmMes").validate({
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