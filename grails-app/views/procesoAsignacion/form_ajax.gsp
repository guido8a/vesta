<%@ page import="vesta.avales.ProcesoAsignacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!procesoAsignacionInstance}">
    <elm:notFound elem="ProcesoAsignacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmProcesoAsignacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${procesoAsignacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAsignacionInstance, field: 'asignacion', 'error')} required">
            <span class="grupo">
                <label for="asignacion" class="col-md-2 control-label">
                    Asignacion
                </label>
                <div class="col-md-6">
                    <g:select id="asignacion" name="asignacion.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" required="" value="${procesoAsignacionInstance?.asignacion?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAsignacionInstance, field: 'monto', 'error')} required">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-2">
                    <g:field name="monto" type="number" value="${fieldValue(bean: procesoAsignacionInstance, field: 'monto')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAsignacionInstance, field: 'proceso', 'error')} required">
            <span class="grupo">
                <label for="proceso" class="col-md-2 control-label">
                    Proceso
                </label>
                <div class="col-md-6">
                    <g:select id="proceso" name="proceso.id" from="${vesta.avales.ProcesoAval.list()}" optionKey="id" required="" value="${procesoAsignacionInstance?.proceso?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmProcesoAsignacion").validate({
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