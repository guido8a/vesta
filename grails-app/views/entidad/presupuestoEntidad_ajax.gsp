<%@ page import="vesta.parametros.PresupuestoUnidad; vesta.parametros.poaPac.Anio" %>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:set var="anio" value="${new Date().format('yyyy')}"/>
<g:set var="anioObj" value="${Anio.findByAnio(anio)}"/>
<g:set var="presupuesto" value="${PresupuestoUnidad.findByAnioAndUnidad(anioObj, unidad)}"/>

<form class="form-horizontal" id="frmPresupuestoEntidad">
    <div class="form-group">
        <div class='grupo'>
            <label for="anio" class="col-md-3 control-label">Año</label>

            <div class="col-md-3">
                <g:select name="anio" from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio"
                          class="form-control input-sm" value="${anioObj.id}"/>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label for="maxInversion" class="col-md-3 control-label">Max. Inversión</label>

        <div class="col-md-4">
            <div class='grupo'>
                <div class='input-group input-group-sm'>
                    <g:textField name="maxInversion" class="form-control input-sm required number money"
                                 value="${presupuesto ? g.formatNumber(number: presupuesto.maxInversion, maxFractionDigits: 2, minFractionDigits: 2) : ''}"/>
                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                </div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label for="originalCorrientes" class="col-md-3 control-label">Inversión original</label>

        <div class="col-md-4">
            <div class='grupo'>
                <div class='input-group input-group-sm'>
                    <g:textField name="originalCorrientes" class="form-control input-sm required number money" readonly=""
                                 value="${presupuesto ? g.formatNumber(number: presupuesto.originalCorrientes, maxFractionDigits: 2, minFractionDigits: 2) : ''}"/>
                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                </div>
            </div>
        </div>
    </div>

</form>

<script type="text/javascript">
    $(function () {

        $("#frmPresupuestoEntidad").validate({
            errorClass    : "help-block",
            errorPlacement: function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success       : function (label) {
                label.parents(".grupo").removeClass('has-error');
label.remove();
            }
        });

        $("#anio").change(function () {
            var anioId = $("#anio").val();
            var unidadId = "${unidad?.id}";
            $.ajax({
                type   : "POST",
                url    : "${createLink(action: 'getPresupuestoAnio_ajax')}",
                data   : {
                    anio  : anioId,
                    unidad: unidadId
                },
                success: function (msg) {
                    var parts = msg.split("_");
                    $("#maxInversion").val(parts[0]);
                    $("#originalCorrientes").val(parts[1]);
                }
            });
        });
    });
</script>