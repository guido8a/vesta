<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 26/02/15
  Time: 12:59 PM
--%>

<div class="form-group keeptogether">
    <span class="grupo">
        Ingrese la fecha deseada para la reunión seleccionada
    </span>
</div>
<div class="form-group keeptogether">
    <span class="grupo">
        <label for="fechaReunion" class="col-md-2 control-label">
            Fecha
        </label>
        <div class="col-md-5">
            <elm:datepicker name="fechaReunion" id="fechaReunionId"  class="datepicker form-control input-sm" noSelection="['': '']" showTime="true" />
        </div>

    </span>
</div>
