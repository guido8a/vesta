<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<table id="tblMeta" class="table table-condensed table-hover table-striped table-bordered">
    <thead>
        <tr>
            <th>Objetivo</th>
            <th>Política</th>
            <th>Meta</th>
            <th>Eliminar</th>
        </tr>
    </thead>
    <tbody id="tbMeta">
        <g:each in="${metas}" var="meta">
            <tr data-obj="${meta.metaBuenVivir.politica.objetivoId}"
                data-pol="${meta.metaBuenVivir.politicaId}"
                data-met="${meta.metaBuenVivirId}">
                <td>
                    ${meta.metaBuenVivir.politica.objetivo}
                </td>
                <td>
                    ${meta.metaBuenVivir.politica}
                </td>
                <td>
                    ${meta.metaBuenVivir}
                </td>
                <td class="text-center">
                    <a href="#" class="btn btn-sm btn-danger">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">
    $(function () {
        setTimeout(function () {
            $("#tblMeta").fixedHeaderTable({
                height : 250,
                footer : true
            });
        }, 500);
    });
</script>