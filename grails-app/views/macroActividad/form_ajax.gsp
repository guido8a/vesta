<%@ page import="vesta.poaCorrientes.MacroActividad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!macroActividadInstance}">
    <elm:notFound elem="MacroActividad" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmMacroActividad" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${macroActividadInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: macroActividadInstance, field: 'objetivoGastoCorriente', 'error')} required">
                <span class="grupo">
                    <label for="objetivoGastoCorriente" class="col-md-5 control-label">
                        Objetivo de Gasto Corriente
                    </label>

                    <div class="col-md-6">
                        <g:select id="objetivoGastoCorriente" name="objetivoGastoCorriente.id" from="${vesta.poaCorrientes.ObjetivoGastoCorriente.list()}" optionKey="id" required="" value="${macroActividadInstance?.objetivoGastoCorriente?.id}" class="many-to-one form-control input-sm"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: macroActividadInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-5 control-label">
                        Descripción
                    </label>

                    <div class="col-md-6">
                        <g:textArea name="descripcion" cols="40" rows="5" maxlength="511" required="" class="form-control input-sm required" value="${macroActividadInstance?.descripcion}"/>
                    </div>
                    *
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmMacroActividad").validate({
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
                submitFormMacroActividad();
                return false;
            }
            return true;
        });
    </script>

</g:else>