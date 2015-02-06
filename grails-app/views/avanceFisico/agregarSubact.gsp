<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 05/02/15
  Time: 12:32 PM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:if test="${proceso}">
    <div class="fila">


        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">Aporte:</label>

                <div class="col-md-3">
                    <g:textField name="aporte" class="ui-widget-content ui-corner-all number money" style="width: 150px;"/> %
                </div>
            </span>
        </div>


        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">Avance:</label>

                <div class="col-md-3">
                    <g:textField name="avance" class="ui-widget-content ui-corner-all number money" style="width: 150px;"/> %
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">Fecha Inicio:</label>

                <div class="col-md-3">
                    <elm:datepicker name="inicioSub" class="datepicker form-control input-sm"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">Fecha Fin:</label>

                <div class="col-md-3">
                    <elm:datepicker name="finSub" class="datepicker form-control input-sm"/>
                </div>
            </span>
        </div>

    <div class="form-group keeptogether">
        <span class="grupo">
            <label class="col-md-2 control-label">Descripción:</label>

            <div class="col-md-3">
                <g:if test="${proceso}">
                    <g:textArea name="observaciones" rows="5" cols="68" style="width: 500px; height: 100px; resize: none" class="form-control input-sm"/>
                </g:if>
            </div>
        </span>
    </div>
    </div>
</g:if>