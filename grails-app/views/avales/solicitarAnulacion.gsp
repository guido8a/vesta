<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 21/01/15
  Time: 03:08 PM
--%>

<%--
  Created by IntelliJ IDEA.
  User: svt
  Date: 8/12/2014
  Time: 4:07 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Solicitud de anulación del aval ${aval.fechaAprobacion.format("yyyy")}-GP No.${aval.numero}</title>
</head>

<body>
<div class="breadCrumbHolder module">
    <div id="breadCrumb" class="breadCrumb module">
        <ul>
            <li>
                <g:link class="bc" controller="avales" action="avalesProceso" id="${aval.proceso.id}">
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
        <g:message code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" />
    </div>
</g:if>
<g:uploadForm action="guardarSolicitud" controller="avales">
    <input type="hidden" name="aval" value="${aval.id}">
    <input type="hidden" name="tipo" value="A">
    <input type="hidden" name="monto" value="${aval.monto}">
    <input type="hidden" name="proceso" value="${aval.proceso.id}">
    <div style="width: 100%;margin-top: 10px;">
        <div class="label">Monto:</div>
        <input type="text" name="montoText" id="monto" style="width: 140px;margin-right: 30px;text-align: right" class="ui-corner-all ui-widget-content" value="${aval.monto}" disabled>

    </div>

    <div style="width: 100%;margin-top: 10px;height: 40px">
        <div class="label">Memorando No:</div>
        <div style="width: 150px;height: 30px;margin-top: 10px;display: inline-block;;margin-right: 30px;">
            <input type="text" name="memorando" id="memorando" style="width: 140px;margin-right: 10px;" class="ui-corner-all ui-widget-content">
        </div>
        <b> Documento de respaldo:</b>
        <input type="file" name="file" id="file" >
    </div>

    <div style="width: 100%;margin-top: 10px;">
        <div class="label">Concepto:</div>
        <textarea id="concepto" name="concepto" style="resize: none;width: 600px;height: 80px" class="ui-corner-all ui-widget-content" title="Máximo 1024 caracteres"></textarea>

    </div>
    <div style="margin-left: 20px;margin-top: 20px;">
        <a href="#" id="enviar" class="btn_arbol" style="margin-top: 10px">Guardar y Enviar</a>
        <a href="${g.createLink(action: 'listaProcesos')}" id="cancelar" class="btn_arbol" style="margin-top: 10px">Cancelar</a>
    </div>
</g:uploadForm>
<script>
    $(".btn_arbol").button()
    $("#enviar").click(function(){

        var memorando  = $("#memorando").val()
        var concepto = $("#concepto").val()
        var file = $("#file").val()
        var msg=""


        if(concepto.length>1024){
            msg+="<br>El concepto debe tener máximo 1024 caracteres. Tamaño actual "+concepto.length+"."
        }
        if(concepto.trim().length<1){
            msg+="<br>Por favor ingrese un concepto."
        }
        if(memorando.trim().length<1){
            msg+="<br>Por favor ingrese un número de memorando."
        }

        if(file.length<1){
            msg+="<br>Por favor seleccione un archivo."
        }else{
            var ext = file.split('.').pop();
            if(ext!="pdf"){
                msg+="<br>Por favor seleccione un archivo de formato pdf. El formato "+ext+" no es aceptado por el sistema"
            }
        }

        if(msg=="") {
            $("form").submit()
        }else{
            $.box({
                title:"Error",
                text:msg,
                dialog: {
                    resizable: false,
                    buttons  : {
                        "Cerrar":function(){

                        }
                    }
                }
            });
        }
    });
</script>
</body>
</html>