<%@ page import="vesta.avales.Certificacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!certificacionInstance}">
    <elm:notFound elem="Certificacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmCertificacion" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${certificacionInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'usuario', 'error')} required">
            <span class="grupo">
                <label for="usuario" class="col-md-2 control-label">
                    Usuario
                </label>
                <div class="col-md-7">
                    <g:select id="usuario" name="usuario.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" required="" value="${certificacionInstance?.usuario?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'asignacion', 'error')} required">
            <span class="grupo">
                <label for="asignacion" class="col-md-2 control-label">
                    Asignacion
                </label>
                <div class="col-md-7">
                    <g:select id="asignacion" name="asignacion.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" required="" value="${certificacionInstance?.asignacion?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm required" value="${certificacionInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'fechaRevision', 'error')} ">
            <span class="grupo">
                <label for="fechaRevision" class="col-md-2 control-label">
                    Fecha Revision
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaRevision"  class="datepicker form-control input-sm" value="${certificacionInstance?.fechaRevision}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'monto', 'error')} required">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-3">
                    <g:field name="monto" type="number" value="${fieldValue(bean: certificacionInstance, field: 'monto')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'concepto', 'error')} required">
            <span class="grupo">
                <label for="concepto" class="col-md-2 control-label">
                    Concepto
                </label>
                <div class="col-md-7">
                    <g:textArea name="concepto" cols="40" rows="5" maxlength="1024" required="" class="form-control input-sm required" value="${certificacionInstance?.concepto}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${certificacionInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-3">
                    <g:field name="estado" type="number" value="${certificacionInstance.estado}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'memorandoSolicitud', 'error')} required">
            <span class="grupo">
                <label for="memorandoSolicitud" class="col-md-2 control-label">
                    Memorando Solicitud
                </label>
                <div class="col-md-7">
                    <g:textField name="memorandoSolicitud" maxlength="40" required="" class="form-control input-sm required" value="${certificacionInstance?.memorandoSolicitud}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'memorandoCertificado', 'error')} ">
            <span class="grupo">
                <label for="memorandoCertificado" class="col-md-2 control-label">
                    Memorando Certificado
                </label>
                <div class="col-md-7">
                    <g:textField name="memorandoCertificado" maxlength="40" class="form-control input-sm" value="${certificacionInstance?.memorandoCertificado}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'acuerdo', 'error')} ">
            <span class="grupo">
                <label for="acuerdo" class="col-md-2 control-label">
                    Acuerdo
                </label>
                <div class="col-md-7">
                    <g:textField name="acuerdo" maxlength="40" class="form-control input-sm" value="${certificacionInstance?.acuerdo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'archivo', 'error')} ">
            <span class="grupo">
                <label for="archivo" class="col-md-2 control-label">
                    Archivo
                </label>
                <div class="col-md-7">
                    <g:textArea name="archivo" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${certificacionInstance?.archivo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'pathSolicitud', 'error')} ">
            <span class="grupo">
                <label for="pathSolicitud" class="col-md-2 control-label">
                    Path Solicitud
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathSolicitud" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${certificacionInstance?.pathSolicitud}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'pathAnulacion', 'error')} ">
            <span class="grupo">
                <label for="pathAnulacion" class="col-md-2 control-label">
                    Path Anulacion
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathAnulacion" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${certificacionInstance?.pathAnulacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'fechaAnulacion', 'error')} ">
            <span class="grupo">
                <label for="fechaAnulacion" class="col-md-2 control-label">
                    Fecha Anulacion
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaAnulacion"  class="datepicker form-control input-sm" value="${certificacionInstance?.fechaAnulacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'fechaLiberacion', 'error')} ">
            <span class="grupo">
                <label for="fechaLiberacion" class="col-md-2 control-label">
                    Fecha Liberacion
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaLiberacion"  class="datepicker form-control input-sm" value="${certificacionInstance?.fechaLiberacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'conceptoAnulacion', 'error')} ">
            <span class="grupo">
                <label for="conceptoAnulacion" class="col-md-2 control-label">
                    Concepto Anulacion
                </label>
                <div class="col-md-7">
                    <g:textArea name="conceptoAnulacion" cols="40" rows="5" maxlength="1024" class="form-control input-sm" value="${certificacionInstance?.conceptoAnulacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'pathSolicitudAnulacion', 'error')} ">
            <span class="grupo">
                <label for="pathSolicitudAnulacion" class="col-md-2 control-label">
                    Path Solicitud Anulacion
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathSolicitudAnulacion" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${certificacionInstance?.pathSolicitudAnulacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'pathLiberacion', 'error')} ">
            <span class="grupo">
                <label for="pathLiberacion" class="col-md-2 control-label">
                    Path Liberacion
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathLiberacion" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${certificacionInstance?.pathLiberacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'numeroContrato', 'error')} ">
            <span class="grupo">
                <label for="numeroContrato" class="col-md-2 control-label">
                    Numero Contrato
                </label>
                <div class="col-md-7">
                    <g:textField name="numeroContrato" maxlength="20" class="form-control input-sm" value="${certificacionInstance?.numeroContrato}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'fechaRevisionAnulacion', 'error')} ">
            <span class="grupo">
                <label for="fechaRevisionAnulacion" class="col-md-2 control-label">
                    Fecha Revision Anulacion
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaRevisionAnulacion"  class="datepicker form-control input-sm" value="${certificacionInstance?.fechaRevisionAnulacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: certificacionInstance, field: 'montoLiberacion', 'error')} required">
            <span class="grupo">
                <label for="montoLiberacion" class="col-md-2 control-label">
                    Monto Liberacion
                </label>
                <div class="col-md-3">
                    <g:field name="montoLiberacion" type="number" value="${fieldValue(bean: certificacionInstance, field: 'montoLiberacion')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmCertificacion").validate({
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