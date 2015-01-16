<%@ page import="vesta.proyectos.MarcoLogico" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!marcoLogicoInstance}">
    <elm:notFound elem="MarcoLogico" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmComponente" role="form" action="save_componente_ajax" method="POST">
            <g:hiddenField name="id" value="${marcoLogicoInstance?.id}"/>
            <g:hiddenField name="proyecto.id" value="${marcoLogicoInstance.proyectoId}"/>
            <g:hiddenField name="tipoElemento.id" value="${marcoLogicoInstance.tipoElementoId}"/>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'numeroComp', 'error')} ">
                <span class="grupo">
                    <label for="numeroComp" class="col-md-2 control-label">
                        Número
                    </label>

                    <div class="col-md-2">
                        <g:textField name="numeroComp" class="form-control input-sm required" value="${marcoLogicoInstance?.numeroComp}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'objeto', 'error')} ">
                <span class="grupo">
                    <label for="objeto" class="col-md-2 control-label">
                        Objeto
                    </label>

                    <div class="col-md-10">
                        <g:textArea name="objeto" cols="70" rows="5" maxlength="1023" class="form-control input-sm required" value="${marcoLogicoInstance?.objeto}"/>
                    </div>
                </span>
            </div>
        </g:form>
    </div>
    <script type="text/javascript">
        var validator = $("#frmComponente").validate({
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
                submitFormComponente("${show}");
                return false;
            }
            return true;
        });
    </script>
</g:else>