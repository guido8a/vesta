<%@ page import="vesta.parametros.Auxiliar" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!auxiliarInstance}">
    <elm:notFound elem="Auxiliar" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAuxiliar" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${auxiliarInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: auxiliarInstance, field: 'presupuesto', 'error')} required">
            <span class="grupo">
                <label for="presupuesto" class="col-md-2 control-label">
                    Presupuesto
                </label>
                <div class="col-md-2">
                    <g:field name="presupuesto" type="number" value="${fieldValue(bean: auxiliarInstance, field: 'presupuesto')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAuxiliar").validate({
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