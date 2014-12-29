<%@ page import="vesta.avales.ProcesoAval" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!procesoAvalInstance}">
    <elm:notFound elem="ProcesoAval" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmProcesoAval" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${procesoAvalInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAvalInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textArea name="nombre" cols="40" rows="5" maxlength="255" required="" class="form-control input-sm required" value="${procesoAvalInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAvalInstance, field: 'fechaFin', 'error')} required">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label">
                    Fecha Fin
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control input-sm required" value="${procesoAvalInstance?.fechaFin}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAvalInstance, field: 'fechaInicio', 'error')} required">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label">
                    Fecha Inicio
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control input-sm required" value="${procesoAvalInstance?.fechaInicio}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAvalInstance, field: 'informar', 'error')} required">
            <span class="grupo">
                <label for="informar" class="col-md-2 control-label">
                    Informar
                </label>
                <div class="col-md-2">
                    <g:field name="informar" type="number" value="${procesoAvalInstance.informar}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: procesoAvalInstance, field: 'proyecto', 'error')} required">
            <span class="grupo">
                <label for="proyecto" class="col-md-2 control-label">
                    Proyecto
                </label>
                <div class="col-md-6">
                    <g:select id="proyecto" name="proyecto.id" from="${vesta.proyectos.Proyecto.list()}" optionKey="id" required="" value="${procesoAvalInstance?.proyecto?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmProcesoAval").validate({
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