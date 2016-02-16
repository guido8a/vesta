<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vesta.utilitarios.BuscadorService" %>

<%
    def buscadorServ = grailsApplication.classLoader.loadClass('vesta.utilitarios.BuscadorService').newInstance()
%>


<div id="detalle">
    <div class="row-fluid">
        <div class="span12">

            <b>Buscar Por: </b>
            <elm:select name="buscador" from = "${buscadorServ.parametrosPartidas()}" value="${params.buscador}"
                        optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con" style="width: 200px" />

            <b>Operación:</b>
            <span id="selOpt"></span>
            <b style="margin-left: 20px">Criterio: </b>
            <g:textField name="criterio" style="width: 160px; margin-right: 10px" value="${params.criterio}" id="criterio_con"/>
            <a href="#" id="buscarP" class="btn btn-success" title="Buscar"><i class="fa fa-search"></i> Buscar</a>

        </div>

    </div>


    <g:set var="band" value="1"/>
    <div class="row-fluid"  style="width: 99.7%;height: 600px;overflow-y: auto;float: right;">
        <div class="span12">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 40px;">Seleccionar</th>
                    <g:each in="${buscadorServ.parametrosPartidas().campo}" var="pr" status="j">
                        <g:if test="${pr[j] != 0}">
                            <th style="width: 150px">${buscadorServ.parametrosPartidas().nombre[j]}</th>

                        </g:if>
                    </g:each>
                </tr>
                </thead>

                <tbody id="tabla_material">

                <g:each in="${res}" var="r" status="j">
                    <tr>
                        <td style="text-align: center; width: 40px">
                            %{--<a href="#" id="seleccionar" class="btn btn-success" title="Seleccionar"><i class="fa fa-check"></i></a>--}%
                            <a href="#" id="btnSel"  class="btn btn-success btn-sm btnP" title="Seleccionar" prt="${r?.prsp__id}" num="${r?.prspnmro}" des="${r?.prspdscr}"><i class="fa fa-check"></i></a>
                            %{--<a href="#" id="btnSel"  class="btn btn-success btn-sm btnP" title="Seleccionar" num="${r?.prspnmro}" des="${r?.prspdscr}"><i class="fa fa-check"></i></a>--}%

                        </td>
                        %{--<g:each in="${r}" var="t" status="k">--}%

                                %{--<g:set var="ts" value="${t.toString().split("=")}"/>--}%
                                %{--<g:if test="${ts[1] == 'null'}">--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                    %{--<td style="width: 150px">${ts[1]}</td>--}%
                                %{--</g:else>--}%

                        %{--</g:each>--}%
                        <td style="width: 80px">${r?.prspnmro}</td>
                        <td>${r?.prspdscr}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>


<script type="text/javascript">

    $("#buscarP").click(function(){
        var datos = "si=${"si"}&buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() +
                "&operador=" + $("#oprd").val() + "&tipo=corrientes";
        $.ajax({type : "POST", url : "${g.createLink(controller: 'asignacion',action:'buscadorPartidas')}",
            data     : datos,
            success  : function (msg) {
                $("#detalle").html(msg)
            }
        });
    });


    $("#buscador_con").change(function(){
        var anterior = "${params.operador}";
        var opciones = $(this).find("option:selected").attr("class").split(",");
        poneOperadores(opciones);
        /* regresa a la opción seleccionada */
//        $("#oprd option[value=" + anterior + "]").prop('selected', true);
    });


    function poneOperadores (opcn) {
        var $sel = $("<select name='operador' id='oprd' style='width: 160px'}>");
        for(var i=0; i<opcn.length; i++) {
            var opt = opcn[i].split(":");
            var $opt = $("<option value='"+opt[0]+"'>"+opt[1]+"</option>");
            $sel.append($opt);
        }
        $("#selOpt").html($sel);
    };

    /* inicializa el select de oprd con la primea opción de busacdor */
    $( document ).ready(function() {
        $("#buscador_con").change();
    });

    $(".btnP").click(function () {
//        console.log("--->" + $(this).attr("prt"));
//        $("#prsp_id").val($(this).attr("prt"));
        var tt = ($(this).attr("num") + " - " +  $(this).attr("des"))
        $("#prsp_id").val(tt);
        $("#prsp_hide").val($(this).attr("prt"));
        $("#dlgPartidas").modal("hide");

    });

</script>
