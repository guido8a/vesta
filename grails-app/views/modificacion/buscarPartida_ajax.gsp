<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 03:04 PM
--%>


<input type="hidden" id="id_txt">

<div>
    Buscar por:

    <select id="tipo">
        <option value="1">Número</option>
        <option value="2">Descripción</option>
    </select>

    %{--<input type="text" id="par" style="width: 160px;">--}%
    <g:textField name="parName" id="par" width="160px"/>

    %{--<a href="#" class="btn" id="btn_buscar">Buscar</a>--}%
</div>

<div id="resultado" style="width: 420px;margin-top: 10px;" ></div>

<script type="text/javascript">

    $.ajax({
        type:"POST",
        url:"${createLink(action:'buscarPresupuesto_ajax',controller:'asignacion')}",
        data:"parametro=" + $("#par").val() + "&tipo=" + $("#tipo").val(),
        success:function (msg) {
            $("#resultado").html(msg)
        }
    });

</script>



