<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 05/02/15
  Time: 12:32 PM
--%>

%{--<g:if test="${proceso}">--}%
    <div class="fila">

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 col-md-offset-1 control-label">Aporte:</label>

                <div class="col-md-4">
                    <div class="input-group">
                        <g:textField name="aporte" class="form-control number money required"/>
                        <span class="input-group-addon">%</span>
                    </div>
                </div>
            </span>
        </div>


        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 col-md-offset-1 control-label">Avance:</label>

                <div class="col-md-4">
                    <div class="input-group">
                        <g:textField name="avance" class="form-control number money required"/>
                        <span class="input-group-addon">%</span>
                    </div>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 col-md-offset-1 control-label">Fecha Inicio:</label>

                <div class="col-md-4">
                    <elm:datepicker name="inicioSub" class="datepicker form-control input-sm"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 col-md-offset-1 control-label">Fecha Fin:</label>

                <div class="col-md-4">
                    <elm:datepicker name="finSub" class="datepicker form-control input-sm"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 col-md-offset-1 control-label">Descripción:</label>

                <div class="col-md-8">
                    <g:if test="${proceso}">
                        <g:textArea name="observaciones" rows="5" cols="68" style="height: 100px; resize: none" class="form-control input-sm required"/>
                    </g:if>
                </div>
            </span>
        </div>
    </div>
%{--</g:if>--}%