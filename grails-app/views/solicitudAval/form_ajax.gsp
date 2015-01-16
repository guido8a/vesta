<%@ page import="vesta.avales.SolicitudAval" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!solicitudAvalInstance}">
    <elm:notFound elem="SolicitudAval" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmSolicitudAval" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${solicitudAvalInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'concepto', 'error')} ">
            <span class="grupo">
                <label for="concepto" class="col-md-2 control-label">
                    Concepto
                </label>
                <div class="col-md-7">
                    <g:textArea name="concepto" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${solicitudAvalInstance?.concepto}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'proceso', 'error')} required">
            <span class="grupo">
                <label for="proceso" class="col-md-2 control-label">
                    Proceso
                </label>
                <div class="col-md-7">
                    <g:select id="proceso" name="proceso.id" from="${vesta.avales.ProcesoAval.list()}" optionKey="id" required="" value="${solicitudAvalInstance?.proceso?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'aval', 'error')} ">
            <span class="grupo">
                <label for="aval" class="col-md-2 control-label">
                    Aval
                </label>
                <div class="col-md-7">
                    <g:select id="aval" name="aval.id" from="${vesta.avales.Aval.list()}" optionKey="id" value="${solicitudAvalInstance?.aval?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'fechaRevision', 'error')} ">
            <span class="grupo">
                <label for="fechaRevision" class="col-md-2 control-label">
                    Fecha Revision
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaRevision"  class="datepicker form-control input-sm" value="${solicitudAvalInstance?.fechaRevision}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-7">
                    <g:select id="estado" name="estado.id" from="${vesta.avales.EstadoAval.list()}" optionKey="id" required="" value="${solicitudAvalInstance?.estado?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'path', 'error')} ">
            <span class="grupo">
                <label for="path" class="col-md-2 control-label">
                    Path
                </label>
                <div class="col-md-7">
                    <g:textArea name="path" cols="40" rows="5" maxlength="350" class="form-control input-sm" value="${solicitudAvalInstance?.path}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'contrato', 'error')} ">
            <span class="grupo">
                <label for="contrato" class="col-md-2 control-label">
                    Contrato
                </label>
                <div class="col-md-7">
                    <g:textField name="contrato" maxlength="30" class="form-control input-sm" value="${solicitudAvalInstance?.contrato}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'memo', 'error')} ">
            <span class="grupo">
                <label for="memo" class="col-md-2 control-label">
                    Memo
                </label>
                <div class="col-md-7">
                    <g:textField name="memo" maxlength="30" class="form-control input-sm" value="${solicitudAvalInstance?.memo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textField name="observaciones" class="form-control input-sm" value="${solicitudAvalInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'numero', 'error')} required">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label">
                    Numero
                </label>
                <div class="col-md-3">
                    <g:field name="numero" type="number" value="${solicitudAvalInstance.numero}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'tipo', 'error')} ">
            <span class="grupo">
                <label for="tipo" class="col-md-2 control-label">
                    Tipo
                </label>
                <div class="col-md-7">
                    <g:textField name="tipo" maxlength="1" class="form-control input-sm" value="${solicitudAvalInstance?.tipo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'firma', 'error')} ">
            <span class="grupo">
                <label for="firma" class="col-md-2 control-label">
                    Firma
                </label>
                <div class="col-md-7">
                    <g:select id="firma" name="firma.id" from="${vesta.seguridad.Firma.list()}" optionKey="id" value="${solicitudAvalInstance?.firma?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'unidad', 'error')} ">
            <span class="grupo">
                <label for="unidad" class="col-md-2 control-label">
                    Unidad
                </label>
                <div class="col-md-7">
                    <g:select id="unidad" name="unidad.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${solicitudAvalInstance?.unidad?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha"  class="datepicker form-control input-sm required" value="${solicitudAvalInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'monto', 'error')} required">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-3">
                    <g:field name="monto" type="number" value="${fieldValue(bean: solicitudAvalInstance, field: 'monto')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: solicitudAvalInstance, field: 'usuario', 'error')} required">
            <span class="grupo">
                <label for="usuario" class="col-md-2 control-label">
                    Usuario
                </label>
                <div class="col-md-7">
                    <g:select id="usuario" name="usuario.id" from="${vesta.seguridad.Usro.list()}" optionKey="id" required="" value="${solicitudAvalInstance?.usuario?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmSolicitudAval").validate({
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