<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 03:56 PM
--%>

<link href="/js/plugins/fixed-header-table-1.3/css/defaultTheme.css" rel="stylesheet" media="screen" />
<link href="/js/plugins/fixed-header-table-1.3/css/myTheme.css" rel="stylesheet" media="screen" />

<table class="table table-condensed table-bordered table-striped table-hover hidden" id="tblPresupuesto" style="width: 480px">
    <thead>
    <th>Número</th>
    <th>Descripcion</th>
    <th>Nivel</th>
    <th></th>
    </thead>
    <tbody>
    <g:each in="${prsp}" var="p" status="i">
        <tr class="${(i%2==0)?'even':'odd'}">
            <td>${p.numero}</td>
            <td>${p.descripcion}</td>
            <td>${p.nivel}</td>
            <td><a href="#" class="mas btn btn-sm btn-success" prsp="${p.id}" nombre="${p.numero}" desc="${p.descripcion}" title="Añadir"><i class="fa fa-plus"></i> </a></td>
        </tr>
    </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $(".mas").click(function(){
//        console.log("prsp " + $(this).attr("prsp"))
        $("#prsp_desc2").val($(this).attr("prsp"))
        $("#dlgBuscarPre").modal("hide")
    });


    setTimeout(function () {
        $("#tblPresupuesto").fixedHeaderTable({
            height : 420

        }).removeClass("hidden");
    }, 500);

</script>