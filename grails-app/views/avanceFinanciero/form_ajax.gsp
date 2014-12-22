<%@ page import="vesta.hitos.AvanceFinanciero" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!avanceFinancieroInstance}">
    <elm:notFound elem="AvanceFinanciero" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAvanceFinanciero" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${avanceFinancieroInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'proceso', 'error')} ">
            <span class="grupo">
                <label for="proceso" class="col-md-2 control-label">
                    Proceso
                </label>
                <div class="col-md-6">
                    <g:select id="proceso" name="proceso.id" from="${vesta.avales.ProcesoAval.list()}" optionKey="id" value="${avanceFinancieroInstance?.proceso?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-6">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="1024" class="form-control" value="${avanceFinancieroInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'contrato', 'error')} required">
            <span class="grupo">
                <label for="contrato" class="col-md-2 control-label">
                    Contrato
                </label>
                <div class="col-md-6">
                    <g:textField name="contrato" maxlength="30" required="" class="form-control required" value="${avanceFinancieroInstance?.contrato}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'certificado', 'error')} ">
            <span class="grupo">
                <label for="certificado" class="col-md-2 control-label">
                    Certificado
                </label>
                <div class="col-md-6">
                    <g:textField name="certificado" maxlength="30" class="form-control" value="${avanceFinancieroInstance?.certificado}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'aval', 'error')} ">
            <span class="grupo">
                <label for="aval" class="col-md-2 control-label">
                    Aval
                </label>
                <div class="col-md-6">
                    <g:select id="aval" name="aval.id" from="${vesta.avales.Aval.list()}" optionKey="id" value="${avanceFinancieroInstance?.aval?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha"  class="datepicker form-control required" value="${avanceFinancieroInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'monto', 'error')} required">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto
                </label>
                <div class="col-md-2">
                    <g:field name="monto" type="number" value="${fieldValue(bean: avanceFinancieroInstance, field: 'monto')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceFinancieroInstance, field: 'valor', 'error')} required">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label">
                    Valor
                </label>
                <div class="col-md-2">
                    <g:field name="valor" type="number" value="${fieldValue(bean: avanceFinancieroInstance, field: 'valor')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAvanceFinanciero").validate({
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