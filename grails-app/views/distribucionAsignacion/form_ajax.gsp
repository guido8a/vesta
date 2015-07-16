<%@ page import="vesta.avales.DistribucionAsignacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!distribucionAsignacionInstance}">
    <elm:notFound elem="DistribucionAsignacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmDistribucionAsignacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${distribucionAsignacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: distribucionAsignacionInstance, field: 'asignacion', 'error')} required">
            <span class="grupo">
                <label for="asignacion" class="col-md-2 control-label">
                    Asignacion
                </label>
                <div class="col-md-6">
                    <g:select id="asignacion" name="asignacion.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" required="" value="${distribucionAsignacionInstance?.asignacion?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: distribucionAsignacionInstance, field: 'unidadEjecutora', 'error')} required">
            <span class="grupo">
                <label for="unidadEjecutora" class="col-md-2 control-label">
                    Área de gestión
                </label>
                <div class="col-md-6">
                    <g:select id="unidadEjecutora" name="unidadEjecutora.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" required="" value="${distribucionAsignacionInstance?.unidadEjecutora?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: distribucionAsignacionInstance, field: 'valor', 'error')} required">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label">
                    Valor
                </label>
                <div class="col-md-2">
                    <g:field name="valor" type="number" value="${fieldValue(bean: distribucionAsignacionInstance, field: 'valor')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmDistribucionAsignacion").validate({
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