<%@ page import="vesta.poa.Asignacion" %>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        <g:message code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/>
    </div>
</g:if>
<g:hasErrors bean="${asignacionInstance}">
    <div class="errors ui-state-error ui-corner-all">
        <g:renderErrors bean="${asignacionInstance}" as="list"/>
    </div>
</g:hasErrors>
<g:form action="creaHijosPrio" class="frmAsignacionPrio form-horizontal" method="post" enctype="multipart/form-data">
    <g:hiddenField name="padre" value="${asignacionInstance?.id}"/>

    <g:hiddenField name="maximo" value="${asignacionInstance.priorizado}"/>


    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="fuente" class="col-md-2 control-label">
                Fuente
            </label>
            <div class="col-md-7">
                <g:select class="form-control input-sm required" name="fuente"
                          title="Fuente de financiamiento" from="${fuentes}" optionKey="id"
                          value="${asignacionInstance?.fuente?.id}" />
            </div>

        </span>
    </div>
    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="fuente" class="col-md-2 control-label">
                Partida
            </label>
            <div class="col-md-7">
                <bsc:buscador name="partida" id="prsp" controlador="asignacion" accion="buscarPresupuesto" tipo="search" titulo="Busque una partida" campos="${campos}"  clase="required" />
            </div>

        </span>
    </div>
    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="valor" class="col-md-2 control-label">
                Valor
            </label>
            <div class="col-md-7">
                <g:textField class="form-control input-sm required money number" name="valor"
                             title="Planificado" id="vlor" style="text-align:right;padding-right: 10px;"
                             value='${formatNumber(number:asignacionInstance.priorizado,format:"###,##0",minFractionDigits:2,maxFractionDigits:2)}'/>
            </div>

        </span>
    </div>


</g:form>
<script type="text/javascript">
    var validator = $(".frmAsignacionPrio").validate({
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