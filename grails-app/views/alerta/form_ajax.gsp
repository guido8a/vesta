<%@ page import="vesta.alertas.Alerta" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!alertaInstance}">
    <elm:notFound elem="Alerta" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAlerta" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${alertaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'from', 'error')} required">
            <span class="grupo">
                <label for="from" class="col-md-2 control-label">
                    From
                </label>
                <div class="col-md-6">
                    <g:select id="from" name="from.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" required="" value="${alertaInstance?.from?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'persona', 'error')} required">
            <span class="grupo">
                <label for="usro" class="col-md-2 control-label">
                    Usro
                </label>
                <div class="col-md-6">
                    <g:select id="usro" name="usro.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" required="" value="${alertaInstance?.persona?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'fechaEnvio', 'error')} required">
            <span class="grupo">
                <label for="fec_envio" class="col-md-2 control-label">
                    Fecenvio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fec_envio"  class="datepicker form-control required" value="${alertaInstance?.fechaEnvio}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'fechaRecibido', 'error')} ">
            <span class="grupo">
                <label for="fec_recibido" class="col-md-2 control-label">
                    Fecrecibido
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fec_recibido"  class="datepicker form-control" value="${alertaInstance?.fechaRecibido}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'mensaje', 'error')} required">
            <span class="grupo">
                <label for="mensaje" class="col-md-2 control-label">
                    Mensaje
                </label>
                <div class="col-md-6">
                    <g:textField name="mensaje" maxlength="200" required="" class="form-control required" value="${alertaInstance?.mensaje}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'controlador', 'error')} ">
            <span class="grupo">
                <label for="controlador" class="col-md-2 control-label">
                    Controlador
                </label>
                <div class="col-md-6">
                    <g:textField name="controlador" class="form-control" value="${alertaInstance?.controlador}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'accion', 'error')} ">
            <span class="grupo">
                <label for="accion" class="col-md-2 control-label">
                    Accion
                </label>
                <div class="col-md-6">
                    <g:textField name="accion" class="form-control" value="${alertaInstance?.accion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: alertaInstance, field: 'id_remoto', 'error')} required">
            <span class="grupo">
                <label for="id_remoto" class="col-md-2 control-label">
                    Idremoto
                </label>
                <div class="col-md-2">
                    <g:field name="id_remoto" type="number" value="${alertaInstance.id_remoto}" class="digits form-control required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAlerta").validate({
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