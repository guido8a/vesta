<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 26/01/15
  Time: 12:41 PM
--%>


<div class="fila">
    <input type="hidden" id="maxAvance">
    <input type="hidden" id="idAvance">

    <div class="form-group keeptogether">
         <span class="grupo">
                <label class="col-md-2 control-label">
            Avance:</label>

             <div class="fieldSvt-small">
                 <g:textField name="avance" id="avanceAvance" class="ui-widget-content ui-corner-all number" style="width: 50px;"/> %
             </div>
        </span>
    </div>

    <div class="form-group keeptogether">
        <span class="grupo">
            <label class="col-md-2 control-label">Fecha:</label>

    <div class="fieldSvt-small">
        ${new java.util.Date().format("dd/MM/yyyy")}
    </div>
            </span>
     </div>
</div>

<div class="form-group keeptogether">
    <span class="grupo">
        <label class="col-md-2 control-label">Descripción:</label>

    <div class="fieldSvt-large">
        <g:textArea name="descripcionAvance" class="ui-widget-content ui-corner-all" rows="2" cols="45" style="resize: none"/>
    </div>
</span>
</div>
<fieldset style="width:95%;margin-top: 15px;">
    <legend>Avances registrados</legend>

    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <tr>
            <th>
                Fecha
            </th>
            <th>
                Descripción
            </th>
            <th>
                Avance
            </th>
        </tr>
        </thead>
        <tbody>

        <g:each in="${avances}" var="a">
            <tr>
                <td style="text-align: center">
                    ${a.fecha.format("dd/MM/yyyy")}
                </td>
                <td>
                    ${a.descripcion}
                </td>
                <td style="text-align: right;">
                    <g:formatNumber number="${a.avance}" minFractionDigits="2" maxFractionDigits="2"/>%
                </td>
            </tr>
        </g:each>
        <tr>
            <td colspan="2" style="text-align: right;font-weight: bold">Avance total:</td>
            <g:if test="${avances.size() > 0}">
                <td style="text-align: right;font-weight: bold"><g:formatNumber number="${avances.pop().avance}" minFractionDigits="2" maxFractionDigits="2"/>%</td>
            </g:if>
            <g:else>
                <td style="text-align: right;font-weight: bold"><g:formatNumber number="0" minFractionDigits="2" maxFractionDigits="2"/>%</td>
            </g:else>

        </tr>
        </tbody>
    </table>

</fieldset>