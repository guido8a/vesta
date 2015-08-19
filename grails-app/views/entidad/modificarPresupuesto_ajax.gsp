<%@ page import="vesta.parametros.PresupuestoUnidad; vesta.parametros.poaPac.Anio" %>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:set var="anio" value="${new Date().format('yyyy')}"/>
<g:set var="anioObj" value="${Anio.findByAnio(anio)}"/>
<g:set var="presupuesto" value="${PresupuestoUnidad.findByAnioAndUnidad(anioObj, unidad)}"/>

<form class="form-horizontal" id="frmModificarPresupuesto">
    <g:hiddenField name="id" value="${techo.id}"/>

    <div class="form-group">
        <label for="inversiones" class="col-md-7 control-label">Presupuesto de inversiones</label>

        <div class="col-md-5">
            <div class='grupo'>
                <div class='input-group input-group-sm'>
                    <g:textField name="inversiones" class="form-control input-sm required number money"
                                 value="${techo ? g.formatNumber(number: techo.maxInversion, maxFractionDigits: 2, minFractionDigits: 2) : ''}"/>
                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                </div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label for="inversiones" class="col-md-7 control-label">Presupuesto de gasto permanente</label>

        <div class="col-md-5">
            <div class='grupo'>
                <div class='input-group input-group-sm'>
                    <g:textField name="corrientes" class="form-control input-sm required number money"
                                 value="${techo ? g.formatNumber(number: techo.maxCorrientes, maxFractionDigits: 2, minFractionDigits: 2) : ''}"/>
                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                </div>
            </div>
        </div>
    </div>
</form>

<script type="text/javascript">
    $(function () {

        $("#frmModificarPresupuesto").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
label.remove();
            }
        });
    });
</script>