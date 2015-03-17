<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 12:18 PM
--%>

<div style="margin-bottom: 10px">
    <b>Unidad:</b><g:select from="${vesta.parametros.UnidadEjecutora.list([sort:'nombre'])}" optionKey="id" optionValue="nombre" name="unidad" id="unidadAsg" noSelection="['-1':'Todas']"/><br><br>
    <b>Partida:</b>  <input type="hidden" class="prsp" value="${asignacionInstance?.presupuesto?.id}" id="prsp2" name="presupuesto.id">
    <input type="text" id="prsp_desc2" desc="desc2" style="width: 100px;border: 1px solid black;text-align: center" class="buscar ui-corner-all">
    <span style="font-size: smaller;">Haga clic para consultar</span><br>
</div>
%{--<a href="#" class="btn" id="btn_buscarAsg">Buscar</a>--}%
<div id="resultadoAsg" style="width: 450px;margin-top: 10px;" class="ui-corner-all"></div>