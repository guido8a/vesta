<table>
    <tbody>
        <th>Provincia</th>
        <th>Cantón</th>
        <th>Parroquia</th>
    </tbody>
    <tbody>
        <g:each in="${parroquias}" var="parr" status="i">
            <tr>
                <td class="provincia" id="prv_${parr.canton.provincia.id}">
                    <a href="#" class="add" name="${parr.canton.provincia.nombre}">${parr.canton.provincia.nombre}</a>
                </td>

                <td class="canton" id="cnt_${parr.canton.id}">
                    <a href="#" class="add" name="${parr.canton.nombre}">${parr.canton.nombre}</a>
                </td>

                <td class="parroquia" id="par_${parr.id}">
                    <a href="#" class="add" name="${parr.nombre}">${parr.nombre}</a>
                </td>
                %{--<td><a href="#" class="btn_bscar" parr="${parr.id}" nombre="${parr.nombre}">Añadir</a></td>--}%
            </tr>
        </g:each>
    </tbody>
</table>
<script type="text/javascript">
    $(".btn_bscar").button().click(function () {
        $("#parr_id").val($(this).attr("parr"));
        $("#parr_nombre").html($(this).attr("nombre"));
        $("#parr_nombre_txt").val($(this).attr("nombre"));
        $("#dlg_buscar").dialog("close");
    });

    $(".add").button({
        icons:{
            primary:"ui-icon-check"
        }
    }).css({
                width:"100%"
            }).click(function () {

                var btn = $(this);
                var td = btn.parent();
                var geoTipo = td.attr("class");

                var text = "";

                if (geoTipo == "provincia") {
                    text = "Provincia:"
                } else if (geoTipo == "canton") {
                    text = "Cantón:"
                } else if (geoTipo == "parroquia") {
                    text = "Parroquia:"
                }

                $("#spanLbl").text(text);
                $("#parr_id").val(td.attr("id"));
                $("#parr_nombre_txt").val(btn.attr("name"));

                $("#dlg_buscar").dialog("close");

                return false;
            });

</script>