<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/01/15
  Time: 11:00 AM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:if test="${band}">
    <input type="hidden" id="dlgId">

    <div class="form-group keeptogether">
        <span class="grupo">
            <label for="dlgMonto" class="col-md-2 control-label">
                Monto:
            </label>

            <div class="col-md-3">
                <div class="input-group">
                    <g:textField class="form-control input-sm number money" name="montoName" style="text-align: right; margin-right: 10px" id="dlgMonto" value="${asg?.monto}"/>
                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                </div>
            </div>

            <div class="col-md-3">
                <p class="form-control-static">
                    Máximo <span id="dlgMax" style="display: inline-block"></span>
                    <g:formatNumber number="${max.toDouble()}" type="currency"/>
                </p>
            </div>
        </span>
    </div>

</g:if>
<g:else>
    <div class="fila">
        No puede editar este proceso porque ya tiene un aval o una solicitud pendiente
    </div>

</g:else>