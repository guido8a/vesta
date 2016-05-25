<div class="form-group keeptogether required">
    <div class="row">
        <label for="fuente" class="col-md-2 control-label">
            Fuente
        </label>
        <div class="col-md-9">
            <g:select from="${vesta.parametros.poaPac.Fuente.list()}" optionKey="id" optionValue="descripcion"
                      name="fuente" class="form-control input-sm required requiredCmb fuente"/>
        </div>
        <div class="col-md-1">
            *
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            <label>Fecha Incio</label>
        </div>

        <div class="col-md-4 grupo">
            <elm:datepicker class="form-control input-sm fechaInicio required"
                            name="fechaInicio"
                            title="Fecha inicio"
                            id="fchaInicio"
                            value="${Date.parse("yyyy-MM-dd", new Date().format('yyyy') + "-01-01")}"/>

        </div>

        <div class="col-md-2">
            <label>Fecha Fin</label>
        </div>

        <div class="col-md-4 grupo">
            <elm:datepicker class="form-control input-sm fechaFin required"
                            name="fechaFin"
                            title="Fecha fin"
                            id="fchaFin"
                            format="dd-MM-yyyy"/>
        </div>
    </div>
</div>