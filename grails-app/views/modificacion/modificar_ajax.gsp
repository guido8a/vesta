<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 11:45 AM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:form action="guardarReasignacionYachay" class="frm_modpoa" enctype="multipart/form-data">

    <input type="hidden" id="h_origen" name="origen" value="${asgOrigen.id}">
    <input type="hidden" id="h_destino" name="destino" value="${asgDestino.id}">
    <input type="hidden" name="tipoPag" value="inv">
    <input type="hidden" id="proyecto" name="proyecto" value="${proyecto.id}">
    <input type="hidden" id="unidad" name="unidad" value="${unidad}">

    <div style="height: 40px">
        <div style="width: 170px;height: 35px;float: left"><b>Monto de la reasignación:</b></div> <g:textField name="monto" id="monto" class="number" style="width: 100px"/>
        %{--<input type="text" style="width: 100px;" id="monto" name="monto"> --}%
        Máximo:<span id="max"></span>
    </div>

    <div style="margin-top: 10px;">
        <div style="width: 170px;height: 35px;float: left"><b> Autorización:</b></div> <input type="file" name="archivo" id="archivo">
    </div>
</g:form>

<div class="alert alert-danger" style="margin-top: 20px">
    <b>Recuerde que despues de cada modificación las asignaciones de origen y destino deben REPROGRAMARSE</b>
</div>