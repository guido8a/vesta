<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/06/15
  Time: 11:31 AM
--%>

<div class="form-group keeptogether required">
    <span class="grupo">
        <label for="fuente" class="col-md-2 control-label">
            Fuente
        </label>
        <div class="col-md-6">
            <g:select from="${vesta.parametros.poaPac.Fuente.list()}" optionKey="id" optionValue="descripcion"
                      name="fuente" class="form-control input-sm required requiredCmb fuente"/>
        </div>
        *
    </span>
</div>