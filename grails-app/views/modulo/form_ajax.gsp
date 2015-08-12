<%@ page import="vesta.seguridad.Modulo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!moduloInstance}">
    <elm:notFound elem="Modulo" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmModulo" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${moduloInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: moduloInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-4 control-label">
                    Descripción
                </label>
                <div class="col-md-8">
                    <g:textField name="descripcion" required="" class="form-control input-sm required" value="${moduloInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: moduloInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-4 control-label">
                    Nombre
                </label>
                <div class="col-md-8">
                    <g:textField name="nombre" required="" class="form-control input-sm required" value="${moduloInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: moduloInstance, field: 'orden', 'error')} required">
            <span class="grupo">
                <label for="orden" class="col-md-4 control-label">
                    Orden
                </label>
                <div class="col-md-2">
                    <g:field name="orden" type="number" value="${moduloInstance.orden}" class="digits form-control input-sm required"
                             required="" min="0"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmModulo").validate({
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