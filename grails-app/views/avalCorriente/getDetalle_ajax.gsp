<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 03:24 PM
--%>

<script src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<table class="table table-condensed table-bordered table-striped table-hover" id="tblDetalle">
    <thead>
        <tr>
            <th>Año</th>
            <th>Obj. gasto corriente</th>
            <th>MacroActividad</th>
            <th>Actividad</th>
            <th>Tarea</th>
            <th>Asignación</th>
            <th>Monto</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <g:set var="total" value="${0}"/>
        <g:each in="${detalles}" var="det">
            <g:set var="total" value="${total + det.monto}"/>
            <tr>
                <td>${det.asignacion.tarea.actividad.anio.anio}</td>
                <td>${det.asignacion.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}</td>
                <td>${det.asignacion.tarea.actividad.macroActividad.descripcion}</td>
                <td>${det.asignacion.tarea.actividad.descripcion}</td>
                <td>${det.asignacion.tarea.descripcion}</td>
                <td>${det.asignacion.stringCorriente}</td>
                <td class="text-right"><g:formatNumber number="${det.monto}" type="currency" currencySymbol=""/></td>
                <td>
                    <a href="#" class="btn btn-danger btn-xs btnDelete" data-id="${det.id}" title="Eliminar">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
    </tbody>
    <tfoot>
        <tr>
            <th colspan="6">TOTAL</th>
            <th class="text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></th>
            <th></th>
        </tr>
    </tfoot>
</table>

<script type="text/javascript">
    $(function () {

        $("#tblDetalle").fixedHeaderTable({
            height     : 200,
            autoResize : true,
            footer     : true
        });

        $(".btnDelete").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'deleteDetalle_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0]);
                    getDetalle();
                }
            });
            return false;
        });
    });
</script>