<%@ page import="vesta.parametros.poaPac.Anio" %>
<form class="form-inline">
    <div class="form-group">
        <label for="anio">Año</label>
        <g:select from="${Anio.list(sort: 'anio')}" name="anio" class="form-control input-sm"
                  optionKey="id" optionValue="anio" value="${anio.id}"/>
    </div>
    <a href="#" class="btn btn-sm btn-success" id="btnVerPac">Ver</a>
</form>

<div id="divTablaPac" style="height: 350px; overflow-y: auto;">

</div>

<script type="application/javascript">
    function reloadTablaPac() {

    }

    $(function () {
        $("#btnVerPac").click(function () {

            return false;
        });
    });
</script>
