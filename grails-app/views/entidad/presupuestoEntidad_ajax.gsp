<%@ page import="vesta.parametros.poaPac.Anio" %>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/jquery-inputmask-3.1.49/dist', file: 'jquery.inputmask.bundle.min.js')}"></script>

<form class="form-horizontal">
    <div class="form-group">
        <label for="anio" class="col-md-3 control-label">Año</label>

        <div class="col-md-3">
            <g:select name="anio" from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio"
                      class="form-control input-sm"/>
        </div>
    </div>

    <div class="form-group">
        <label for="maxInversion" class="col-md-3 control-label">Max. Inversión</label>

        <div class="col-md-4">
            <div class='input-group input-group-sm'>
                <g:textField name="maxInversion" class="form-control input-sm required number money"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label for="inversionOriginal" class="col-md-3 control-label">Inversión original</label>

        <div class="col-md-4">
            <div class='input-group input-group-sm'>
                <g:textField name="inversionOriginal" class="form-control input-sm required number money"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>
    </div>

</form>

<script type="text/javascript">
    $(".money").inputmask({
        alias         : 'numeric',
        placeholder   : '0',
        digitsOptional: false,
        digits        : 2,
        autoGroup     : true,
        groupSeparator: ','
    });
</script>