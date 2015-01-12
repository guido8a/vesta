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
<g:form action="agregaAsignacionMod" class="frmAsignacion form-horizontal" method="post" enctype="multipart/form-data">
    <g:hiddenField name="padre" value="${asignacionInstance?.id}"/>
    <g:if test="${dist}">
        <g:hiddenField name="maximo" value="${dist?.getValorReal()}"/>
    </g:if>
    <g:else>
        <g:if test="${asignacionInstance.reubicada=='S'}">
            <g:hiddenField name="maximo" value="${asignacionInstance?.getValorReal()}"/>
        </g:if>
        <g:else>
            <g:hiddenField name="maximo" value="${asignacionInstance?.planificado}"/>
        </g:else>

    </g:else>

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
                             value='${formatNumber(number:asignacionInstance.planificado,format:"###,##0",minFractionDigits:2,maxFractionDigits:2)}'/>
            </div>

        </span>
    </div>
    %{--<div id="buscar">--}%
        %{--<input type="hidden" id="id_txt">--}%
        %{--<input type="hidden" id="id_desc">--}%
        %{--<div>--}%
            %{--Buscar por:--}%
            %{--<select id="tipo">--}%
                %{--<option value="1">Número</option>--}%
                %{--<option value="2">Descripción</option>--}%
            %{--</select>--}%
            %{--<input type="text" id="par" style="width: 160px;"><a href="#" class="btn" id="btn_buscar">Buscar</a>--}%
        %{--</div>--}%

        %{--<div id="resultado" style="width: 480px;margin-top: 10px;" class="ui-corner-all"></div>--}%
    %{--</div>--}%

</g:form>
<script type="text/javascript">

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