<%@ page import="vesta.parametros.PresupuestoUnidad; vesta.parametros.poaPac.Anio" %>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:set var="anio" value="${new Date().format('yyyy')}"/>
<g:set var="anioObj" value="${Anio.findByAnio(anio)}"/>
<g:set var="presupuesto" value="${PresupuestoUnidad.findByAnioAndUnidad(anioObj, unidad)}"/>

<form class="form-horizontal">
    <div class="form-group">
        <label for="anio" class="col-md-3 control-label">Año</label>

        <div class="col-md-3">
            <g:select name="anio" from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio"
                      class="form-control input-sm" value="${anioObj.id}"/>
        </div>
    </div>

    <div class="form-group">
        <label for="maxInversion" class="col-md-3 control-label">Max. Inversión</label>

        <div class="col-md-4">
            <div class='input-group input-group-sm'>
                <g:textField name="maxInversion" class="form-control input-sm required number money"
                             value="${presupuesto ? g.formatNumber(number: presupuesto.maxInversion, maxFractionDigits: 2, minFractionDigits: 2) : ''}"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label for="inversionOriginal" class="col-md-3 control-label">Inversión original</label>

        <div class="col-md-4">
            <div class='input-group input-group-sm'>
                <g:textField name="inversionOriginal" class="form-control input-sm required number money"
                             value="${presupuesto ? g.formatNumber(number: presupuesto.originalCorrientes, maxFractionDigits: 2, minFractionDigits: 2) : ''}"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>
    </div>

</form>

<script type="text/javascript">

</script>