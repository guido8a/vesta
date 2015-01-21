<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 21/01/15
  Time: 03:09 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Solicitud de aval -- Proceso: ${proceso.nombre}</title>
</head>

<body>
<div class="breadCrumbHolder module">
    <div id="breadCrumb" class="breadCrumb module">
        <ul>
            <li>
                <g:link class="bc" controller="avales" action="avalesProceso" id="${proceso.id}">
                    Avales
                </g:link>
            </li>
            <li>
                Solicitud
            </li>
        </ul>
    </div>
</div>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        <g:message code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/>
    </div>
</g:if>
<g:uploadForm action="guardarSolicitud" controller="avales">
    <input type="hidden" name="proceso" value="${proceso.id}">
    <input type="hidden" name="disp" id="disponible" value="${disponible}">

    <div style="width: 100%;margin-top: 10px;">
        <div class="label">Número:</div>
        <input type="text" name="numero_text" id="numero" style="width: 100px;margin-right: 30px;text-align: right"
               class="ui-corner-all ui-widget-content" value="${numero}" disabled>
        <input type="hidden" name="numero" value="${numero}">
    </div>

    <div style="width: 100%;margin-top: 10px;">
        <div class="label">Monto:</div>
        <input type="text" name="montoTxt" id="montoTxt" style="width: 140px;margin-right: 30px;text-align: right"
               class="ui-corner-all ui-widget-content decimal"
               value="${g.formatNumber(number: disponible, minFractionDigits: 2, maxFractionDigits: 2)}" disabled>
        <input type="hidden" name="monto" id="monto" style="width: 140px;margin-right: 30px;text-align: right"
               class="ui-corner-all ui-widget-content decimal"
               value="${g.formatNumber(number: disponible, minFractionDigits: 2, maxFractionDigits: 2)}">
        <b>Disponible:</b> <g:formatNumber number="${disponible}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="width: 100%;margin-top: 10px;height: 40px">
        <div class="label">Documento de soporte:</div>

        <div style="width: 150px;height: 30px;margin-top: 10px;display: inline-block;;margin-right: 30px;">
            <input type="text" name="memorando" id="memorando" style="width: 140px;margin-right: 10px;"
                   class="ui-corner-all ui-widget-content"
                   title="Memorando de aprobación, oficio, correo electrónico, otros.">
        </div>
        <b>Documento de respaldo:</b>
        <input type="file" name="file" id="file">
    </div>

    <div style="width: 100%;margin-top: 20px;">
        <div class="label">Concepto:</div>
        <textarea id="concepto" name="concepto" style="resize: none;width: 600px;height: 80px" class="ui-corner-all ui-widget-content" title="Máximo 1024 caracteres"></textarea>
    </div>

    <div style="width: 100%;margin-top: 10px;">
        <div class="label">Autorización electrónica:</div>
        <g:select from="${personas}" optionKey="id" optionValue="${{
            it.persona.nombre + ' ' + it.persona.apellido
        }}" name="firma1"/>
    </div>

    <div style="margin-left: 20px;margin-top: 20px;">
        <a href="#" id="enviar" class="btn_arbol" style="margin-top: 10px">Guardar y Enviar</a>
        <a href="${g.createLink(action: 'listaProcesos')}" id="cancelar" class="btn_arbol" style="margin-top: 10px">Cancelar</a>
    </div>
    <input type="hidden" name="referencial" value="${refencial}">
</g:uploadForm>
<script>


    $(".btn_arbol").button();

    $(".decimal").setMask("decimal");

    $("#enviar").click(function () {
        var monto = $("#monto").val();

        monto = monto.replace(new RegExp("\\.", 'g'), "");
        monto = monto.replace(new RegExp(",", 'g'), ".");

        var memorando = $("#memorando").val();
        var concepto = $("#concepto").val();
        var file = $("#file").val();
        var msg = "";
        var disponible = $("#disponible").val();

        if (isNaN(monto)) {
            msg += "<br>El monto debe ser un número positivo";
        } else {
            monto = monto * 1;
        }
        if (monto < 0.00001) {
            msg += "<br>El monto debe ser un número positivo mayor que cero.";
        }
        if (monto > disponible * 1) {
            msg += "<br>El monto debe ser menor o igual que " + number_format(disponible, 2, ",", ".") + ".";
        }
        if (concepto.length > 1024) {
            msg += "<br>El concepto debe tener máximo 1024 caracteres. Tamaño actual " + concepto.length + ".";
        }
        if (concepto.trim().length < 1) {
            msg += "<br>Por favor ingrese un concepto.";
        }

        if (msg == "") {
            $("form").submit()
        } else {
            $.box({
                title  : "Error",
                text   : msg,
                dialog : {
                    resizable : false,
                    width     : 400,
                    buttons   : {
                        "Cerrar" : function () {

                        }
                    }
                }
            });
        }
    });
</script>
</body>
</html>