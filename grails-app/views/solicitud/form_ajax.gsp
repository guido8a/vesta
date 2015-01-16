<%@ page import="vesta.contratacion.Solicitud" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!solicitudInstance}">
    <elm:notFound elem="Solicitud" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmSolicitud" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${solicitudInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${solicitudInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'revisadoAdministrativaFinanciera', 'error')} ">
            <span class="grupo">
                <label for="revisadoAdministrativaFinanciera" class="col-md-2 control-label">
                    Revisado Administrativa Financiera
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="revisadoAdministrativaFinanciera"  class="datepicker form-control input-sm" value="${solicitudInstance?.revisadoAdministrativaFinanciera}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'revisadoJuridica', 'error')} ">
            <span class="grupo">
                <label for="revisadoJuridica" class="col-md-2 control-label">
                    Revisado Juridica
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="revisadoJuridica"  class="datepicker form-control input-sm" value="${solicitudInstance?.revisadoJuridica}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'revisadoDireccionProyectos', 'error')} ">
            <span class="grupo">
                <label for="revisadoDireccionProyectos" class="col-md-2 control-label">
                    Revisado Direccion Proyectos
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="revisadoDireccionProyectos"  class="datepicker form-control input-sm" value="${solicitudInstance?.revisadoDireccionProyectos}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'observacionesAdministrativaFinanciera', 'error')} ">
            <span class="grupo">
                <label for="observacionesAdministrativaFinanciera" class="col-md-2 control-label">
                    Observaciones Administrativa Financiera
                </label>
                <div class="col-md-7">
                    <g:textArea name="observacionesAdministrativaFinanciera" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${solicitudInstance?.observacionesAdministrativaFinanciera}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'observacionesJuridica', 'error')} ">
            <span class="grupo">
                <label for="observacionesJuridica" class="col-md-2 control-label">
                    Observaciones Juridica
                </label>
                <div class="col-md-7">
                    <g:textArea name="observacionesJuridica" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${solicitudInstance?.observacionesJuridica}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'observacionesDireccionProyectos', 'error')} ">
            <span class="grupo">
                <label for="observacionesDireccionProyectos" class="col-md-2 control-label">
                    Observaciones Direccion Proyectos
                </label>
                <div class="col-md-7">
                    <g:textArea name="observacionesDireccionProyectos" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${solicitudInstance?.observacionesDireccionProyectos}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathPdfTdr', 'error')} ">
            <span class="grupo">
                <label for="pathPdfTdr" class="col-md-2 control-label">
                    Path Pdf Tdr
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathPdfTdr" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${solicitudInstance?.pathPdfTdr}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'estado', 'error')} ">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-7">
                    <g:select name="estado" from="${solicitudInstance.constraints.estado.inList}" class="form-control input-sm" value="${solicitudInstance?.estado}" valueMessagePrefix="solicitud.estado" noSelection="['': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathOferta1', 'error')} ">
            <span class="grupo">
                <label for="pathOferta1" class="col-md-2 control-label">
                    Path Oferta1
                </label>
                <div class="col-md-7">
                    <g:textField name="pathOferta1" class="form-control input-sm" value="${solicitudInstance?.pathOferta1}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathOferta2', 'error')} ">
            <span class="grupo">
                <label for="pathOferta2" class="col-md-2 control-label">
                    Path Oferta2
                </label>
                <div class="col-md-7">
                    <g:textField name="pathOferta2" class="form-control input-sm" value="${solicitudInstance?.pathOferta2}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathOferta3', 'error')} ">
            <span class="grupo">
                <label for="pathOferta3" class="col-md-2 control-label">
                    Path Oferta3
                </label>
                <div class="col-md-7">
                    <g:textField name="pathOferta3" class="form-control input-sm" value="${solicitudInstance?.pathOferta3}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathCuadroComparativo', 'error')} ">
            <span class="grupo">
                <label for="pathCuadroComparativo" class="col-md-2 control-label">
                    Path Cuadro Comparativo
                </label>
                <div class="col-md-7">
                    <g:textField name="pathCuadroComparativo" class="form-control input-sm" value="${solicitudInstance?.pathCuadroComparativo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathAnalisisCostos', 'error')} ">
            <span class="grupo">
                <label for="pathAnalisisCostos" class="col-md-2 control-label">
                    Path Analisis Costos
                </label>
                <div class="col-md-7">
                    <g:textField name="pathAnalisisCostos" class="form-control input-sm" value="${solicitudInstance?.pathAnalisisCostos}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'incluirReunion', 'error')} ">
            <span class="grupo">
                <label for="incluirReunion" class="col-md-2 control-label">
                    Incluir Reunion
                </label>
                <div class="col-md-7">
                    <g:textField name="incluirReunion" class="form-control input-sm" value="${solicitudInstance?.incluirReunion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathRevisionGAF', 'error')} ">
            <span class="grupo">
                <label for="pathRevisionGAF" class="col-md-2 control-label">
                    Path Revision GAF
                </label>
                <div class="col-md-7">
                    <g:textField name="pathRevisionGAF" class="form-control input-sm" value="${solicitudInstance?.pathRevisionGAF}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathRevisionGJ', 'error')} ">
            <span class="grupo">
                <label for="pathRevisionGJ" class="col-md-2 control-label">
                    Path Revision GJ
                </label>
                <div class="col-md-7">
                    <g:textField name="pathRevisionGJ" class="form-control input-sm" value="${solicitudInstance?.pathRevisionGJ}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathRevisionGDP', 'error')} ">
            <span class="grupo">
                <label for="pathRevisionGDP" class="col-md-2 control-label">
                    Path Revision GDP
                </label>
                <div class="col-md-7">
                    <g:textField name="pathRevisionGDP" class="form-control input-sm" value="${solicitudInstance?.pathRevisionGDP}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'validadoAdministrativaFinanciera', 'error')} ">
            <span class="grupo">
                <label for="validadoAdministrativaFinanciera" class="col-md-2 control-label">
                    Validado Administrativa Financiera
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="validadoAdministrativaFinanciera"  class="datepicker form-control input-sm" value="${solicitudInstance?.validadoAdministrativaFinanciera}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'validadoJuridica', 'error')} ">
            <span class="grupo">
                <label for="validadoJuridica" class="col-md-2 control-label">
                    Validado Juridica
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="validadoJuridica"  class="datepicker form-control input-sm" value="${solicitudInstance?.validadoJuridica}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'fechaPeticionReunion', 'error')} ">
            <span class="grupo">
                <label for="fechaPeticionReunion" class="col-md-2 control-label">
                    Fecha Peticion Reunion
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaPeticionReunion"  class="datepicker form-control input-sm" value="${solicitudInstance?.fechaPeticionReunion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'aprobacion', 'error')} ">
            <span class="grupo">
                <label for="aprobacion" class="col-md-2 control-label">
                    Aprobacion
                </label>
                <div class="col-md-7">
                    <g:select id="aprobacion" name="aprobacion.id" from="${vesta.contratacion.Aprobacion.list()}" optionKey="id" value="${solicitudInstance?.aprobacion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'tipoAprobacion', 'error')} ">
            <span class="grupo">
                <label for="tipoAprobacion" class="col-md-2 control-label">
                    Tipo Aprobacion
                </label>
                <div class="col-md-7">
                    <g:select id="tipoAprobacion" name="tipoAprobacion.id" from="${vesta.parametros.TipoAprobacion.list()}" optionKey="id" value="${solicitudInstance?.tipoAprobacion?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'observacionesAprobacion', 'error')} ">
            <span class="grupo">
                <label for="observacionesAprobacion" class="col-md-2 control-label">
                    Observaciones Aprobacion
                </label>
                <div class="col-md-7">
                    <g:textField name="observacionesAprobacion" class="form-control input-sm" value="${solicitudInstance?.observacionesAprobacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'pathAprobacion', 'error')} ">
            <span class="grupo">
                <label for="pathAprobacion" class="col-md-2 control-label">
                    Path Aprobacion
                </label>
                <div class="col-md-7">
                    <g:textField name="pathAprobacion" class="form-control input-sm" value="${solicitudInstance?.pathAprobacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'revisionDireccionPlanificacionInversion', 'error')} ">
            <span class="grupo">
                <label for="revisionDireccionPlanificacionInversion" class="col-md-2 control-label">
                    Revision Direccion Planificacion Inversion
                </label>
                <div class="col-md-7">
                    <g:textField name="revisionDireccionPlanificacionInversion" class="form-control input-sm" value="${solicitudInstance?.revisionDireccionPlanificacionInversion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'asistentesAprobacion', 'error')} ">
            <span class="grupo">
                <label for="asistentesAprobacion" class="col-md-2 control-label">
                    Asistentes Aprobacion
                </label>
                <div class="col-md-7">
                    <g:textArea name="asistentesAprobacion" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${solicitudInstance?.asistentesAprobacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'fechaParaRevision', 'error')} ">
            <span class="grupo">
                <label for="fechaParaRevision" class="col-md-2 control-label">
                    Fecha Para Revision
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaParaRevision"  class="datepicker form-control input-sm" value="${solicitudInstance?.fechaParaRevision}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'actividad', 'error')} required">
            <span class="grupo">
                <label for="actividad" class="col-md-2 control-label">
                    Actividad
                </label>
                <div class="col-md-7">
                    <g:select id="actividad" name="actividad.id" from="${vesta.proyectos.MarcoLogico.list()}" optionKey="id" required="" value="${solicitudInstance?.actividad?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'detallesMonto', 'error')} ">
            <span class="grupo">
                <label for="detallesMonto" class="col-md-2 control-label">
                    Detalles Monto
                </label>
                <div class="col-md-7">
                    
<ul class="one-to-many">
<g:each in="${solicitudInstance?.detallesMonto?}" var="d">
    <li><g:link controller="detalleMontoSolicitud" action="show" id="${d.id}">${d?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="detalleMontoSolicitud" action="create" params="['solicitud.id': solicitudInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'detalleMontoSolicitud.label', default: 'DetalleMontoSolicitud')])}</g:link>
</li>
</ul>

                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm required" value="${solicitudInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'formaPago', 'error')} required">
            <span class="grupo">
                <label for="formaPago" class="col-md-2 control-label">
                    Forma Pago
                </label>
                <div class="col-md-7">
                    <g:textField name="formaPago" required="" class="form-control input-sm required" value="${solicitudInstance?.formaPago}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'montoSolicitado', 'error')} required">
            <span class="grupo">
                <label for="montoSolicitado" class="col-md-2 control-label">
                    Monto Solicitado
                </label>
                <div class="col-md-3">
                    <g:field name="montoSolicitado" type="number" value="${fieldValue(bean: solicitudInstance, field: 'montoSolicitado')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'nombreProceso', 'error')} required">
            <span class="grupo">
                <label for="nombreProceso" class="col-md-2 control-label">
                    Nombre Proceso
                </label>
                <div class="col-md-7">
                    <g:textField name="nombreProceso" required="" class="form-control input-sm required" value="${solicitudInstance?.nombreProceso}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'objetoContrato', 'error')} required">
            <span class="grupo">
                <label for="objetoContrato" class="col-md-2 control-label">
                    Objeto Contrato
                </label>
                <div class="col-md-7">
                    <g:textField name="objetoContrato" required="" class="form-control input-sm required" value="${solicitudInstance?.objetoContrato}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'plazoEjecucion', 'error')} required">
            <span class="grupo">
                <label for="plazoEjecucion" class="col-md-2 control-label">
                    Plazo Ejecucion
                </label>
                <div class="col-md-3">
                    <g:field name="plazoEjecucion" type="number" value="${solicitudInstance.plazoEjecucion}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'tipoBien', 'error')} required">
            <span class="grupo">
                <label for="tipoBien" class="col-md-2 control-label">
                    Tipo Bien
                </label>
                <div class="col-md-7">
                    <g:select id="tipoBien" name="tipoBien.id" from="${vesta.parametros.TipoBien.list()}" optionKey="id" required="" value="${solicitudInstance?.tipoBien?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'tipoContrato', 'error')} required">
            <span class="grupo">
                <label for="tipoContrato" class="col-md-2 control-label">
                    Tipo Contrato
                </label>
                <div class="col-md-7">
                    <g:select id="tipoContrato" name="tipoContrato.id" from="${vesta.parametros.TipoContrato.list()}" optionKey="id" required="" value="${solicitudInstance?.tipoContrato?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'unidadEjecutora', 'error')} required">
            <span class="grupo">
                <label for="unidadEjecutora" class="col-md-2 control-label">
                    Unidad Ejecutora
                </label>
                <div class="col-md-7">
                    <g:select id="unidadEjecutora" name="unidadEjecutora.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" required="" value="${solicitudInstance?.unidadEjecutora?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudInstance, field: 'usuario', 'error')} required">
            <span class="grupo">
                <label for="usuario" class="col-md-2 control-label">
                    Usuario
                </label>
                <div class="col-md-7">
                    <g:select id="usuario" name="usuario.id" from="${vesta.seguridad.Persona.list()}" optionKey="id" required="" value="${solicitudInstance?.usuario?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmSolicitud").validate({
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