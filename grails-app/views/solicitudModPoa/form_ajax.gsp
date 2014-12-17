<%@ page import="vesta.modificaciones.SolicitudModPoa" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!solicitudModPoaInstance}">
    <elm:notFound elem="SolicitudModPoa" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmSolicitudModPoa" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${solicitudModPoaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'fechaRevision', 'error')} ">
            <span class="grupo">
                <label for="fechaRevision" class="col-md-2 control-label">
                    Fecha Revision
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaRevision"  class="datepicker form-control" value="${solicitudModPoaInstance?.fechaRevision}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'origen', 'error')} required">
            <span class="grupo">
                <label for="origen" class="col-md-2 control-label">
                    Origen
                </label>
                <div class="col-md-7">
                    <g:select id="origen" name="origen.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" required="" value="${solicitudModPoaInstance?.origen?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'destino', 'error')} ">
            <span class="grupo">
                <label for="destino" class="col-md-2 control-label">
                    Destino
                </label>
                <div class="col-md-7">
                    <g:select id="destino" name="destino.id" from="${vesta.poa.Asignacion.list()}" optionKey="id" value="${solicitudModPoaInstance?.destino?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'anio', 'error')} ">
            <span class="grupo">
                <label for="anio" class="col-md-2 control-label">
                    Anio
                </label>
                <div class="col-md-7">
                    <g:select id="anio" name="anio.id" from="${vesta.parametros.poaPac.Anio.list()}" optionKey="id" value="${solicitudModPoaInstance?.anio?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'fuente', 'error')} ">
            <span class="grupo">
                <label for="fuente" class="col-md-2 control-label">
                    Fuente
                </label>
                <div class="col-md-7">
                    <g:select id="fuente" name="fuente.id" from="${vesta.parametros.poaPac.Fuente.list()}" optionKey="id" value="${solicitudModPoaInstance?.fuente?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'marcoLogico', 'error')} ">
            <span class="grupo">
                <label for="marcoLogico" class="col-md-2 control-label">
                    Marco Logico
                </label>
                <div class="col-md-7">
                    <g:select id="marcoLogico" name="marcoLogico.id" from="${vesta.proyectos.MarcoLogico.list()}" optionKey="id" value="${solicitudModPoaInstance?.marcoLogico?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'presupuesto', 'error')} ">
            <span class="grupo">
                <label for="presupuesto" class="col-md-2 control-label">
                    Presupuesto
                </label>
                <div class="col-md-7">
                    <g:select id="presupuesto" name="presupuesto.id" from="${vesta.parametros.poaPac.Presupuesto.list()}" optionKey="id" value="${solicitudModPoaInstance?.presupuesto?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'valor', 'error')} required">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label">
                    Valor
                </label>
                <div class="col-md-3">
                    <g:field name="valor" type="number" value="${fieldValue(bean: solicitudModPoaInstance, field: 'valor')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'concepto', 'error')} required">
            <span class="grupo">
                <label for="concepto" class="col-md-2 control-label">
                    Concepto
                </label>
                <div class="col-md-7">
                    <g:textArea name="concepto" cols="40" rows="5" maxlength="1024" required="" class="form-control required" value="${solicitudModPoaInstance?.concepto}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-3">
                    <g:field name="estado" type="number" value="${solicitudModPoaInstance.estado}" class="digits form-control required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'usuario', 'error')} required">
            <span class="grupo">
                <label for="usuario" class="col-md-2 control-label">
                    Usuario
                </label>
                <div class="col-md-7">
                    <g:select id="usuario" name="usuario.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" required="" value="${solicitudModPoaInstance?.usuario?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'revisor', 'error')} ">
            <span class="grupo">
                <label for="revisor" class="col-md-2 control-label">
                    Revisor
                </label>
                <div class="col-md-7">
                    <g:select id="revisor" name="revisor.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" value="${solicitudModPoaInstance?.revisor?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'tipo', 'error')} required">
            <span class="grupo">
                <label for="tipo" class="col-md-2 control-label">
                    Tipo
                </label>
                <div class="col-md-7">
                    <g:textField name="tipo" maxlength="1" required="" class="form-control required" value="${solicitudModPoaInstance?.tipo}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="1024" class="form-control" value="${solicitudModPoaInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'actividad', 'error')} ">
            <span class="grupo">
                <label for="actividad" class="col-md-2 control-label">
                    Actividad
                </label>
                <div class="col-md-7">
                    <g:textArea name="actividad" cols="40" rows="5" maxlength="1024" class="form-control" value="${solicitudModPoaInstance?.actividad}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'inicio', 'error')} ">
            <span class="grupo">
                <label for="inicio" class="col-md-2 control-label">
                    Inicio
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="inicio"  class="datepicker form-control" value="${solicitudModPoaInstance?.inicio}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'fin', 'error')} ">
            <span class="grupo">
                <label for="fin" class="col-md-2 control-label">
                    Fin
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fin"  class="datepicker form-control" value="${solicitudModPoaInstance?.fin}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'firmaSol', 'error')} ">
            <span class="grupo">
                <label for="firmaSol" class="col-md-2 control-label">
                    Firma Sol
                </label>
                <div class="col-md-7">
                    <g:select id="firmaSol" name="firmaSol.id" from="${vesta.seguridad.Firma.list()}" optionKey="id" value="${solicitudModPoaInstance?.firmaSol?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'firma1', 'error')} ">
            <span class="grupo">
                <label for="firma1" class="col-md-2 control-label">
                    Firma1
                </label>
                <div class="col-md-7">
                    <g:select id="firma1" name="firma1.id" from="${vesta.seguridad.Firma.list()}" optionKey="id" value="${solicitudModPoaInstance?.firma1?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'firma2', 'error')} ">
            <span class="grupo">
                <label for="firma2" class="col-md-2 control-label">
                    Firma2
                </label>
                <div class="col-md-7">
                    <g:select id="firma2" name="firma2.id" from="${vesta.seguridad.Firma.list()}" optionKey="id" value="${solicitudModPoaInstance?.firma2?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha"  class="datepicker form-control required" value="${solicitudModPoaInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'valorDestino', 'error')} required">
            <span class="grupo">
                <label for="valorDestino" class="col-md-2 control-label">
                    Valor Destino
                </label>
                <div class="col-md-3">
                    <g:field name="valorDestino" type="number" value="${fieldValue(bean: solicitudModPoaInstance, field: 'valorDestino')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'valorDestinoSolicitado', 'error')} required">
            <span class="grupo">
                <label for="valorDestinoSolicitado" class="col-md-2 control-label">
                    Valor Destino Solicitado
                </label>
                <div class="col-md-3">
                    <g:field name="valorDestinoSolicitado" type="number" value="${fieldValue(bean: solicitudModPoaInstance, field: 'valorDestinoSolicitado')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'valorOrigen', 'error')} required">
            <span class="grupo">
                <label for="valorOrigen" class="col-md-2 control-label">
                    Valor Origen
                </label>
                <div class="col-md-3">
                    <g:field name="valorOrigen" type="number" value="${fieldValue(bean: solicitudModPoaInstance, field: 'valorOrigen')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudModPoaInstance, field: 'valorOrigenSolicitado', 'error')} required">
            <span class="grupo">
                <label for="valorOrigenSolicitado" class="col-md-2 control-label">
                    Valor Origen Solicitado
                </label>
                <div class="col-md-3">
                    <g:field name="valorOrigenSolicitado" type="number" value="${fieldValue(bean: solicitudModPoaInstance, field: 'valorOrigenSolicitado')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmSolicitudModPoa").validate({
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