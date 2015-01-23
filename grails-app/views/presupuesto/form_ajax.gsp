<%@ page import="vesta.parametros.poaPac.Presupuesto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!presupuestoInstance}">
    <elm:notFound elem="Presupuesto" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPresupuesto" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${presupuestoInstance?.id}"/>
            <g:hiddenField name="presupuesto.id" value="${presupuestoInstance?.presupuestoId}"/>
            <g:hiddenField name="nivel" value="${presupuestoInstance?.nivel}"/>

            <div class="form-group keeptogether ${hasErrors(bean: presupuestoInstance, field: 'presupuesto', 'error')} ">
                <span class="grupo">
                    <label for="presupuesto" class="col-md-2 control-label">
                        Padre
                    </label>

                    <div class="col-md-10">
                        <p class="form-control-static">
                            ${presupuestoInstance?.presupuesto?.toString()}
                        </p>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: presupuestoInstance, field: 'nivel', 'error')} required">
                <span class="grupo">
                    <label for="nivel" class="col-md-2 control-label">
                        Nivel
                    </label>

                    <div class="col-md-2">
                        <p class="form-control-static">
                            ${presupuestoInstance?.nivel}
                        </p>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: presupuestoInstance, field: 'numero', 'error')} ">
                <span class="grupo">
                    <label for="numero" class="col-md-2 control-label">
                        Número
                    </label>

                    <div class="col-md-6">
                        <g:if test="${presupuestoInstance.id}">
                            <p class="form-control-static">
                                ${presupuestoInstance?.numero}
                            </p>
                        </g:if>
                        <g:else>
                            <g:textField name="numero" maxlength="15" class="form-control input-sm" value="${presupuestoInstance?.numero}"/>
                        </g:else>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: presupuestoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>

                    <div class="col-md-10">
                        <g:textArea name="descripcion" cols="40" rows="5" maxlength="255" class="form-control input-sm"
                                    value="${presupuestoInstance?.descripcion}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: presupuestoInstance, field: 'movimiento', 'error')} required">
                <span class="grupo">
                    <label for="movimiento" class="col-md-2 control-label">
                        Movimiento
                    </label>

                    <div class="col-md-2">
                        <g:select name="movimiento" from="[1: 'Sí', 0: 'No']" optionKey="key" optionValue="value"
                                  class="form-control input-sm" value="${presupuestoInstance?.movimiento}"/>
                        %{--<g:field name="movimiento" type="number" value="${presupuestoInstance.movimiento}" class="digits form-control required" required=""/>--}%
                    </div>
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmPresupuesto").validate({
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
                submitFormPresupuesto();
                return false;
            }
            return true;
        });
    </script>

</g:else>