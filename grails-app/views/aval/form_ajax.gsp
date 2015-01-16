<%@ page import="vesta.avales.Aval" %>



<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!avalInstance}">
    <elm:notFound elem="Aval" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAval" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${avalInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'proceso', 'error')} required">
            <span class="grupo">
                <label for="proceso" class="col-md-2 control-label">
                    Proceso
                </label>
                <div class="col-md-7">
                    <g:select id="proceso" name="proceso.id" from="${vesta.avales.ProcesoAval.list()}" optionKey="id" optionValue="nombre" required="" value="${avalInstance?.proceso?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'fechaAprobacion', 'error')} ">
            <span class="grupo">
                <label for="fechaAprobacion" class="col-md-2 control-label">
                    Fecha Aprobación
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaAprobacion"  class="datepicker form-control input-sm" value="${avalInstance?.fechaAprobacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'fechaLiberacion', 'error')} ">
            <span class="grupo">
                <label for="fechaLiberacion" class="col-md-2 control-label">
                    Fecha Liberación
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaLiberacion"  class="datepicker form-control input-sm" value="${avalInstance?.fechaLiberacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'fechaAnulacion', 'error')} ">
            <span class="grupo">
                <label for="fechaAnulacion" class="col-md-2 control-label">
                    Fecha Anulación
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaAnulacion"  class="datepicker form-control input-sm" value="${avalInstance?.fechaAnulacion}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-7">
                    <g:select id="estado" name="estado.id" from="${vesta.avales.EstadoAval.list()}" optionKey="id" optionValue="descripcion" required="" value="${avalInstance?.estado?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'memo', 'error')} ">
            <span class="grupo">
                <label for="memo" class="col-md-2 control-label">
                    Memo
                </label>
                <div class="col-md-7">
                    <g:textField name="memo" maxlength="30" class="form-control input-sm" value="${avalInstance?.memo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'path', 'error')} ">
            <span class="grupo">
                <label for="path" class="col-md-2 control-label">
                    Path
                </label>
                <div class="col-md-7">
                    <g:textArea name="path" cols="40" rows="5" maxlength="350" class="form-control input-sm" value="${avalInstance?.path}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'pathLiberacion', 'error')} ">
            <span class="grupo">
                <label for="pathLiberacion" class="col-md-2 control-label">
                    Path Liberación
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathLiberacion" cols="40" rows="5" maxlength="350" class="form-control input-sm" value="${avalInstance?.pathLiberacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'pathAnulacion', 'error')} ">
            <span class="grupo">
                <label for="pathAnulacion" class="col-md-2 control-label">
                    Path Anulación
                </label>
                <div class="col-md-7">
                    <g:textArea name="pathAnulacion" cols="40" rows="5" maxlength="350" class="form-control input-sm" value="${avalInstance?.pathAnulacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'contrato', 'error')} ">
            <span class="grupo">
                <label for="contrato" class="col-md-2 control-label">
                    Contrato
                </label>
                <div class="col-md-7">
                    <g:textField name="contrato" maxlength="30" class="form-control input-sm" value="${avalInstance?.contrato}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'numero', 'error')} ">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label">
                    Número
                </label>
                <div class="col-md-7">
                    <g:textField name="numero" maxlength="10" class="form-control input-sm" value="${avalInstance?.numero}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'concepto', 'error')} ">
            <span class="grupo">
                <label for="concepto" class="col-md-2 control-label">
                    Concepto
                </label>
                <div class="col-md-7">
                    <g:textArea name="concepto" cols="40" rows="5" maxlength="500" class="form-control input-sm" value="${avalInstance?.concepto}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'certificacion', 'error')} ">
            <span class="grupo">
                <label for="certificacion" class="col-md-2 control-label">
                    Certificacion
                </label>
                <div class="col-md-7">
                    <g:textField name="certificacion" maxlength="50" class="form-control input-sm" value="${avalInstance?.certificacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'firma1', 'error')} ">
            <span class="grupo">
                <label for="firma1" class="col-md-2 control-label">
                    Firma1
                </label>
                <div class="col-md-7">
                    <g:select id="firma1" name="firma1.id" from="${vesta.seguridad.Firma.list()}" optionKey="id" value="${avalInstance?.firma1?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'firma2', 'error')} ">
            <span class="grupo">
                <label for="firma2" class="col-md-2 control-label">
                    Firma2
                </label>
                <div class="col-md-7">
                    <g:select id="firma2" name="firma2.id" from="${vesta.seguridad.Firma.list()}" optionKey="id" value="${avalInstance?.firma2?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'liberacion', 'error')} required">
            <span class="grupo">
                <label for="liberacion" class="col-md-2 control-label">
                    Liberacion
                </label>
                <div class="col-md-3">
                    <g:field name="liberacion" type="number" value="${fieldValue(bean: avalInstance, field: 'liberacion')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avalInstance, field: 'monto', 'error')} required">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-3">
                    <g:field name="monto" type="number" value="${fieldValue(bean: avalInstance, field: 'monto')}" class="number form-control input-sm  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAval").validate({
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