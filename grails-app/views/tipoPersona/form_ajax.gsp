<%@ page import="vesta.parametros.TipoPersona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoPersonaInstance}">
    <elm:notFound elem="TipoPersona" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmTipoPersona" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${tipoPersonaInstance?.id}"/>


            <div class="form-group keeptogether ${hasErrors(bean: tipoPersonaInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripcion
                    </label>

                    <div class="col-md-6">
                        <g:textField name="descripcion" class="form-control input-sm" value="${tipoPersonaInstance?.descripcion}"/>
                    </div>

                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmTipoPersona").validate({
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