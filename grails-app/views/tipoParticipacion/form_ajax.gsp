<%@ page import="vesta.parametros.TipoParticipacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoParticipacionInstance}">
    <elm:notFound elem="TipoParticipacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTipoParticipacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${tipoParticipacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: tipoParticipacionInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="31" required="" class="form-control input-sm required" value="${tipoParticipacionInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTipoParticipacion").validate({
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