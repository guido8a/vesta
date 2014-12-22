<%@ page import="vesta.hitos.AvanceAvance" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!avanceAvanceInstance}">
    <elm:notFound elem="AvanceAvance" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAvanceAvance" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${avanceAvanceInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: avanceAvanceInstance, field: 'avance', 'error')} required">
            <span class="grupo">
                <label for="avance" class="col-md-2 control-label">
                    Avance
                </label>
                <div class="col-md-2">
                    <g:field name="avance" type="number" value="${fieldValue(bean: avanceAvanceInstance, field: 'avance')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceAvanceInstance, field: 'avanceFisico', 'error')} required">
            <span class="grupo">
                <label for="avanceFisico" class="col-md-2 control-label">
                    Avance Fisico
                </label>
                <div class="col-md-6">
                    <g:select id="avanceFisico" name="avanceFisico.id" from="${vesta.hitos.AvanceFisico.list()}" optionKey="id" required="" value="${avanceAvanceInstance?.avanceFisico?.id}" class="many-to-one form-control"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: avanceAvanceInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-4">
                    <elm:datepicker name="fecha"  class="datepicker form-control required" value="${avanceAvanceInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAvanceAvance").validate({
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