<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 11:45 AM
--%>

<g:form action="guardarReasignacionYachay" class="frm_modpoa" enctype="multipart/form-data">
    <input type="hidden" id="h_origen" name="origen">
    <input type="hidden" id="h_destino" name="destino">
    <input type="hidden" name="tipoPag" value="inv">
    <input type="hidden" id="proyecto" name="proyecto" value="${proyecto.id}">
    <div style="height: 40px">
        <div style="width: 170px;height: 35px;float: left"><b>Monto de la reasignación:</b></div> <input type="text" style="width: 100px;" id="monto" name="monto"> Máximo:<span id="max"></span>
    </div>

    <div style="margin-top: 10px;">
        <div style="width: 170px;height: 35px;float: left"><b> Autorización:</b></div> <input type="file" name="archivo" id="archivo">
    </div>
</g:form>

<div class="alert alert-danger">
    <b>Recuerde que despues de cada modificación las asignaciones de origen y destino deben REPROGRAMARSE</b>
</div>