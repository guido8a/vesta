<%@ page import="vesta.contratacion.DetalleMontoSolicitud" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!detalleMontoSolicitudInstance}">
    <elm:notFound elem="DetalleMontoSolicitud" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmDetalleMontoSolicitud" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${detalleMontoSolicitudInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: detalleMontoSolicitudInstance, field: 'anio', 'error')} required">
            <span class="grupo">
                <label for="anio" class="col-md-2 control-label">
                    Anio
                </label>
                <div class="col-md-6">
                    <g:select id="anio" name="anio.id" from="${vesta.parametros.poaPac.Anio.list()}" optionKey="id" required="" value="${detalleMontoSolicitudInstance?.anio?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: detalleMontoSolicitudInstance, field: 'monto', 'error')} required">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-2">
                    <g:field name="monto" type="number" value="${fieldValue(bean: detalleMontoSolicitudInstance, field: 'monto')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: detalleMontoSolicitudInstance, field: 'solicitud', 'error')} required">
            <span class="grupo">
                <label for="solicitud" class="col-md-2 control-label">
                    Solicitud
                </label>
                <div class="col-md-6">
                    <g:select id="solicitud" name="solicitud.id" from="${vesta.contratacion.Solicitud.list()}" optionKey="id" required="" value="${detalleMontoSolicitudInstance?.solicitud?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmDetalleMontoSolicitud").validate({
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