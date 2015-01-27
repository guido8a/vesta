<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/01/15
  Time: 11:00 AM
--%>

<g:if test="${band}">
  <input type="hidden" id="dlgId">

  <div class="form-group keeptogether">
    <span class="grupo">
      <label for="dlgMonto" class="col-md-2 control-label">
        Monto:
      </label>
      <div class="col-md-3">
        <g:textField class="form-control input-sm number money" name="montoName" style="text-align: right; margin-right: 10px" id="dlgMonto" value="${asg?.monto}"/>
      </div>
      <div class="col-md-3">
        <label> Máximo <span id="dlgMax" style="display: inline-block"></span> ${max} $ </label>
      </div>
    </span>
  </div>

</g:if>
<g:else>
  <div class="fila">
    No puede editar este proceso porque ya tiene un aval o una solicitud pendiente
  </div>



</g:else>