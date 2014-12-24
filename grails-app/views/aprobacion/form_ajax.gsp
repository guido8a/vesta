<%@ page import="vesta.contratacion.Aprobacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!aprobacionInstance}">
    <elm:notFound elem="Aprobacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAprobacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${aprobacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'fecha', 'error')} ">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm" value="${aprobacionInstance?.fecha}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'fechaRealizacion', 'error')} ">
            <span class="grupo">
                <label for="fechaRealizacion" class="col-md-2 control-label">
                    Fecha Realizacion
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaRealizacion"  class="datepicker form-control input-sm" value="${aprobacionInstance?.fechaRealizacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${aprobacionInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'asistentes', 'error')} ">
            <span class="grupo">
                <label for="asistentes" class="col-md-2 control-label">
                    Asistentes
                </label>
                <div class="col-md-7">
                    <g:textArea name="asistentes" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${aprobacionInstance?.asistentes}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'pathPdf', 'error')} ">
            <span class="grupo">
                <label for="pathPdf" class="col-md-2 control-label">
                    Path Pdf
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathPdf" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${aprobacionInstance?.pathPdf}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'numero', 'error')} ">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label">
                    Numero
                </label>
                <div class="col-md-7">
                    <g:textField name="numero" class="form-control input-sm" value="${aprobacionInstance?.numero}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'aprobada', 'error')} ">
            <span class="grupo">
                <label for="aprobada" class="col-md-2 control-label">
                    Aprobada
                </label>
                <div class="col-md-7">
                    <g:textField name="aprobada" class="form-control input-sm" value="${aprobacionInstance?.aprobada}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'creadoPor', 'error')} ">
            <span class="grupo">
                <label for="creadoPor" class="col-md-2 control-label">
                    Creado Por
                </label>
                <div class="col-md-7">
                    <g:select id="creadoPor" name="creadoPor.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" value="${aprobacionInstance?.creadoPor?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'firmaDireccionPlanificacion', 'error')} ">
            <span class="grupo">
                <label for="firmaDireccionPlanificacion" class="col-md-2 control-label">
                    Firma Direccion Planificacion
                </label>
                <div class="col-md-7">
                    <g:select id="firmaDireccionPlanificacion" name="firmaDireccionPlanificacion.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" value="${aprobacionInstance?.firmaDireccionPlanificacion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'firmaGerenciaTecnica', 'error')} ">
            <span class="grupo">
                <label for="firmaGerenciaTecnica" class="col-md-2 control-label">
                    Firma Gerencia Tecnica
                </label>
                <div class="col-md-7">
                    <g:select id="firmaGerenciaTecnica" name="firmaGerenciaTecnica.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" value="${aprobacionInstance?.firmaGerenciaTecnica?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'firmaGerenciaPlanificacion', 'error')} ">
            <span class="grupo">
                <label for="firmaGerenciaPlanificacion" class="col-md-2 control-label">
                    Firma Gerencia Planificacion
                </label>
                <div class="col-md-7">
                    <g:select id="firmaGerenciaPlanificacion" name="firmaGerenciaPlanificacion.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" value="${aprobacionInstance?.firmaGerenciaPlanificacion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: aprobacionInstance, field: 'solicitudes', 'error')} ">
            <span class="grupo">
                <label for="solicitudes" class="col-md-2 control-label">
                    Solicitudes
                </label>
                <div class="col-md-7">
                    
<ul class="one-to-many">
<g:each in="${aprobacionInstance?.solicitudes?}" var="s">
    <li><g:link controller="solicitud" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="solicitud" action="create" params="['aprobacion.id': aprobacionInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'solicitud.label', default: 'Solicitud')])}</g:link>
</li>
</ul>

                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAprobacion").validate({
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