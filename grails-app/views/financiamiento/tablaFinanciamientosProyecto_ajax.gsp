<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<table id="tblFinanciamiento" class="table table-condensed table-hover table-striped table-bordered">
    <thead>
        <tr>
            <th>Fuente</th>
            <th>Monto</th>
            <th>Procentaje</th>
            <th>Año</th>
            <th>Eliminar</th>
        </tr>
    </thead>
    <tbody id="tbFin">
        <g:set var="suma" value="${0}"/>
        <g:set var="prct" value="${0}"/>
        <g:each in="${financiamientos}" status="i" var="fin">
            <g:set var="suma" value="${suma + fin.monto}"/>
            <g:set var="finPorcentaje" value="${(fin.monto * 100) / proyecto.monto}"/>
            <g:set var="prct" value="${prct + finPorcentaje}"/>
            <tr data-anio="${fin.anio.id}" data-fuente="${fin.fuente.id}">
                <td>
                    ${fin.fuente.descripcion}
                </td>
                <td class="text-right">
                    <g:formatNumber number="${fin.monto}" type="currency" currencySymbol=" "/>
                </td>
                <td class="text-right">
                    <g:formatNumber number="${finPorcentaje / 100}" type="percent"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"/>
                </td>
                <td>
                    ${fin.anio.anio}
                </td>
                <td class="text-center">
                    <a id="${fin.id}" href="#" class="btn btn-sm btn-danger btn-delete-fin">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
        </g:each>
    </tbody>
    <tfoot>
        <tr>
            <th class="text-center">
                TOTAL
            </th>
            <th class="text-right" id="tfSuma">
                <g:formatNumber number="${suma}" type="currency" currencySymbol=" "/>
            </th>
            <th class="text-right" id="tfPorc">
                <g:formatNumber number="${prct / 100}" type="percent" minFractionDigits="2"
                                maxFractionDigits="2"/>
            </th>
            <th></th>
            <th></th>
        </tr>
    </tfoot>
</table>

<script type="text/javascript">

    var total = parseFloat("${proyecto.monto}");
    var suma = parseFloat("${suma}");
    var restante = total - suma;
    $(function () {
        setSuma(suma);
        setRestante(restante);

        setTimeout(function () {
            $("#tblFinanciamiento").fixedHeaderTable({
                height : 250,
                footer : true
            });
        }, 500);

        $(".btn-delete-fin").click(function () {
            var id = $(this).attr("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'financiamiento', action:'delete_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    if (parts[0] == "SUCCESS") {
//                        $("#tr_" + id).remove();
                        reloadTabla();
                    }
                }
            });
        });
    });
</script>