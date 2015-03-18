<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 03:54 PM
--%>


<g:if test="${res}">
    <table style="width: 850px;margin-bottom: 10px;font-size: 10px">
        <thead>
        <th>Proyecto</th>
        <th style="width: 80px" class="ui-state-default">Unidad</th>
        <th class="ui-state-default">Actividad</th>
        <th style="width: 60px;" class="ui-state-default">Partida</th>
        <th style="width: 240px" class="ui-state-default">Desc. Presupuestaria</th>

        <th class="ui-state-default">Fuente</th>
        <th class="ui-state-default">Presupuesto</th>
        <th class="ui-state-default"></th>
        </thead>
        <tbody>
        <g:each in="${res}" var="asg" status="i">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="det_${i}">

                <td class="unidad">
                    ${asg.unidad}
                </td>



                <td class="actividad">
                    ${asg.marcoLogico}
                </td>

                <td class="prsp" style="text-align: center">
                    ${asg.presupuesto.numero}
                </td>

                <td class="desc" style="width: 240">
                    ${asg.presupuesto.descripcion}
                </td>

                <td class="fuente">
                    ${asg.fuente.descripcion}
                </td>

                <td class="valor" style="text-align: right">
                    <g:formatNumber number="${asg.priorizado}"
                                    format="###,##0"
                                    minFractionDigits="2" maxFractionDigits="2"/>
                </td>

                <td style="text-align: center">

                    %{--<a href="#" class="btn origen ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}" prog="${asg.programa}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente}" valor="${(asg.redistribucion == 0) ? asg.planificado.toFloat().round(2) : asg.redistribucion.toFloat().round(2)}" actv="${asg.actividad}">Establecer como asignación de origen</a>--}%
                    <a href="#" class="btn destino ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}"  prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente}" valor="${asg.priorizado}" actv="${asg.marcoLogico}" proy="${asg.marcoLogico.proyecto}">Establecer como asignación de destino</a>
                </td>
            </tr>

        </g:each>
        </tbody>
    </table>
    <script type="text/javascript">
        $(".origen").button({icons:{ primary:"ui-icon-arrowrefresh-1-n"},text:false}).click(function(){
            if($("#id_destino").val()!=$(this).attr("iden")){
                $(".proyecto_org").html($(this).attr("proy"))
                $(".fuente_org").html($(this).attr("fuente"))
                $(".valor_org").html(number_format($(this).attr("valor")*1, 2, ",", "."))
                $(".prsp_org").html($(this).attr("prsp_num"))
                $(".desc_org").html($(this).attr("desc"))
                $("#id_origen").val($(this).attr("iden"))
                $(".actividad_org").html($(this).attr("actv"))
                $("#buscarAsg_dlg").dialog("close")
            }else{
                alert("La asignaciones de origen y destino no pueden ser la misma")
            }
        });
        $(".destino").button({icons:{ primary:"ui-icon-arrowrefresh-1-s"},text:false}).click(function(){
            if($("#id_origen").val()!=$(this).attr("iden")){
                $(".programa_dest").html($(this).attr("prog"))
                $(".fuente_dest").html($(this).attr("fuente"))
                $(".valor_dest").html(number_format($(this).attr("valor")*1, 2, ",", "."))
                $(".prsp_dest").html($(this).attr("prsp_num"))
                $(".desc_dest").html($(this).attr("desc"))
                $("#id_destino").val($(this).attr("iden"))
                $(".actividad_dest").html($(this).attr("actv"))
                $("#buscarAsg_dlg").dialog("close")
            } else{
                alert("La asignaciones de origen y destino no pueden ser la misma")
            }
        });

    </script>
</g:if>
<g:else>No se encontraron datos</g:else>