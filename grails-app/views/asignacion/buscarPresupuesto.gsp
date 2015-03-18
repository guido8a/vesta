<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 03:56 PM
--%>
<table class="ui-widget-content ui-corner-all" width="480px">
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
            <td><a href="#" class="mas" prsp="${p.id}" nombre="${p.numero}" desc="${p.descripcion}">Añadir</a></td>
        </tr>
    </g:each>
    </tbody>
</table>
<script type="text/javascript">
    $(".mas").button().click(function(){
        $("#presupuesto").val($(this).attr("prsp"))
        $("#txt_buscar").val($(this).attr("nombre"))
        $("#"+$("#id_txt").val()).val($(this).attr("nombre"))
        $("#"+$("#id_txt").val()).parent().find(".prsp").val($(this).attr("prsp"))
        var desc = $("#id_desc").val()
        if(desc!="undefined" && desc !="" && desc!=" " && desc!=undefined)
            $("#"+desc).html($(this).attr("desc"))
        else
            $("#desc").html($(this).attr("desc"))
        $("#buscar").dialog("close")
        $("#buscarAgr").dialog("close")
    });
</script>