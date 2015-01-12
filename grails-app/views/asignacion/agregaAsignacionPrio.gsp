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
<g:form action="agregaAsignacionMod" class="frmAsignacion" method="post" enctype="multipart/form-data">
    <g:hiddenField name="padre" value="${asignacionInstance?.id}"/>

    <g:hiddenField name="maximo" value="${asignacionInstance?.priorizado}"/>
    <table style="width: 400px;" class="show ui-widget-content ui-corner-all">
        <tr><td colspan="6" class="blanco">&nbsp;</td></tr>
        <tr>
            <td class="label " valign="middle">
                Fuente:
                %{----}%
            </td>
            <td class="indicator">&nbsp;</td>
            <td class="" valign="middle">
                <g:select class="field ui-widget-content ui-corner-all" name="fuente"
                          title="Fuente de financiamiento" from="${fuentes}" optionKey="id"
                          value="${asignacionInstance?.fuente?.id}" noSelection="['null': '']"/>
                %{----}%
            </td>

        </tr>
        <tr class="prop ${hasErrors(bean: asignacionInstance, field: 'presupuesto', 'error')}">

            <td class="label " valign="middle">
                Partida:
                %{----}%
            </td>
            <td class="indicator">
                &nbsp;
            </td>
            <td class="" valign="middle">
                <input type="hidden" class="prsp" value="${asignacionInstance?.presupuesto?.id}" id="prsp2" name="presupuesto.id">
                <input type="text" id="prsp_desc2" desc="desc2" style="width: 100px;border: 1px solid black" class="buscar ui-corner-all">
                <span style="font-size: smaller;">Haga clic para consultar</span>
                <div id="desc2" style="width: 300px;font-size: 10px;text-align: left"></div>
                %{--<g:select class="field ui-widget-content ui-corner-all" name=""--}%
                %{--title="Partida presupuestaria" from="${yachay.parametros.poaPac.Presupuesto.list()}" optionKey="id"--}%
                %{--noSelection="['null': '']"/>--}%
                %{----}%
            </td>

        </tr>

        <tr class="prop ${hasErrors(bean: asignacionInstance, field: 'planificado', 'error')}">

            <td class="label  mandatory" valign="middle">
                Valor:
            </td>
            <td class="indicator mandatory">
                <span class="indicator">*</span>
            </td>
            <td>
                <g:textField class="field number required ui-widget-content ui-corner-all" name="valor"
                             title="Planificado" id="vlor" style="text-align:right;padding-right: 10px;"
                             value='${formatNumber(number:asignacionInstance.redistribucion,format:"###,##0",minFractionDigits:2,maxFractionDigits:2)}'/>
            </td>
        </tr>


        <tr>
            <td colspan="6" class="blanco">&nbsp;</td>
        </tr>
    </table>
    <div id="buscar">
        <input type="hidden" id="id_txt">
        <input type="hidden" id="id_desc">
        <div>
            Buscar por:
            <select id="tipo">
                <option value="1">Número</option>
                <option value="2">Descripción</option>
            </select>
            <input type="text" id="par" style="width: 160px;"><a href="#" class="btn" id="btn_buscar">Buscar</a>
        </div>

        <div id="resultado" style="width: 480px;margin-top: 10px;" class="ui-corner-all"></div>
    </div>
    <script type="text/javascript">
        $(".btn").button()
        $(".buscar").click(function() {
            $("#id_txt").val($(this).attr("id"))
            $("#id_desc").val($(this).attr("desc"))
            $("#buscar").dialog("open")
        });
        $("#btn_buscar").click(function() {
            $.ajax({
                type: "POST",
                url: "${createLink(action:'buscarPresupuesto',controller:'asignacion')}",
                data: "parametro=" + $("#par").val() + "&tipo=" + $("#tipo").val(),
                success: function(msg) {
                    $("#resultado").html(msg)
                }
            });
        });
        $("#buscar").dialog({
            title:"Cuentas presupuestarias",
            width:520,
            height:480,
            autoOpen:false,
            modal:true
        })
    </script>
</g:form>
