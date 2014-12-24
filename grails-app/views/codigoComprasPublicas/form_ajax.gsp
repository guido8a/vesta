<%@ page import="vesta.parametros.CodigoComprasPublicas" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!codigoComprasPublicasInstance}">
    <elm:notFound elem="CodigoComprasPublicas" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmCodigoComprasPublicas" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${codigoComprasPublicasInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: codigoComprasPublicasInstance, field: 'padre', 'error')} ">
            <span class="grupo">
                <label for="padre" class="col-md-2 control-label">
                    Padre
                </label>
                <div class="col-md-6">
                    <g:select id="padre" name="padre.id" from="${vesta.parametros.CodigoComprasPublicas.list()}" optionKey="id" value="${codigoComprasPublicasInstance?.padre?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: codigoComprasPublicasInstance, field: 'numero', 'error')} ">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label">
                    Numero
                </label>
                <div class="col-md-6">
                    <g:textField name="numero" maxlength="15" class="form-control input-sm" value="${codigoComprasPublicasInstance?.numero}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: codigoComprasPublicasInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${codigoComprasPublicasInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: codigoComprasPublicasInstance, field: 'nivel', 'error')} ">
            <span class="grupo">
                <label for="nivel" class="col-md-2 control-label">
                    Nivel
                </label>
                <div class="col-md-6">
                    <g:textField name="nivel" class="form-control input-sm" value="${codigoComprasPublicasInstance?.nivel}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: codigoComprasPublicasInstance, field: 'fecha', 'error')} ">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha" mensaje="Fecha de creación"  class="datepicker form-control input-sm" value="${codigoComprasPublicasInstance?.fecha}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: codigoComprasPublicasInstance, field: 'movimiento', 'error')} required">
            <span class="grupo">
                <label for="movimiento" class="col-md-2 control-label">
                    Movimiento
                </label>
                <div class="col-md-2">
                    <g:field name="movimiento" type="number" value="${codigoComprasPublicasInstance.movimiento}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmCodigoComprasPublicas").validate({
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