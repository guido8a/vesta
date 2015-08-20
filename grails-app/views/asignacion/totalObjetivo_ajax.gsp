<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 08/07/15
  Time: 03:03 PM
--%>

    <div style="position: absolute;top:45px;right:10px;font-size: 15px;">
        <b>Total objetivo actual:</b>
        <g:formatNumber number="${totalObjetivo.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:65px;right:10px;font-size: 15px;">
        <b>Total Unidad:</b>
        <g:formatNumber number="${totalUnidad}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:85px;right:10px;font-size: 15px;">
        <b>Máximo Corrientes:</b>
        <g:formatNumber number="${maximo?.maxCorrientes ?: 0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:105px;right:10px;font-size: 15px;">
        <b>Total Asignado:</b>
        <g:formatNumber number="${totalTodas ?: 0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:125px;right:10px;font-size: 17px;" data-res="${restante}" id="divRestante">
        <b>Restante:</b>
        <g:formatNumber number="${restante}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
    </div>
