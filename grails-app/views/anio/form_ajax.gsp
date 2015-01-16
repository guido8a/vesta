<%@ page import="vesta.parametros.poaPac.Anio" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!anioInstance}">
    <elm:notFound elem="Anio" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmAnio" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${anioInstance?.id}"/>


            <div class="form-group keeptogether ${hasErrors(bean: anioInstance, field: 'anio', 'error')} required">
                <span class="grupo">
                    <label for="anio" class="col-md-2 control-label">
                        Año
                    </label>

                    <div class="col-md-6">
                        <g:textField name="anio" maxlength="31" required="" class="form-control digits required" value="${anioInstance?.anio}"/>
                    </div>
                    *
                </span>
            </div>

        %{--<div class="form-group keeptogether ${hasErrors(bean: anioInstance, field: 'estado', 'error')} required">--}%
        %{--<span class="grupo">--}%
        %{--<label for="estado" class="col-md-2 control-label">--}%
        %{--Estado--}%
        %{--</label>--}%
        %{--<div class="col-md-2">--}%
        %{--<g:field name="estado" type="number" value="${anioInstance.estado}" class="digits form-control required" required=""/>--}%
        %{--</div>--}%
        %{--*--}%
        %{--</span>--}%
        %{--</div>--}%

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmAnio").validate({
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