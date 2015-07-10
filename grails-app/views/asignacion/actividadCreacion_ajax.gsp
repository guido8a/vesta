<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/07/15
  Time: 10:41 AM
--%>

<div class="alert alert-info">
    %{--<p><strong> * La siguiente actividad se creará en:</strong></p>--}%
    <p><strong>Objetivo:</strong>  ${objetivo?.descripcion}</p>
    <p><strong>Macro Actividad:</strong> ${macro?.descripcion}</p>
</div>


<table class="table table-condensed table-bordered table-striped table-hover" style="width: 600px;">
    <thead>
    <th>Actividad</th>
    </thead>
    <tbody>
    <tr class="odd">
        <td class="actividadC">
            <g:textArea name="actividadCrear_name" style="width: 550px; height: 70px; resize: none" id="creacionActividad" maxlength="200" class="form-control input-sm required" value="${actividad?.descripcion}"/>
        </td>
    </tr>
    </tbody>
</table>
<table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
<thead>
<th>Meta</th>
</thead>
    <tbody>
    <tr>
        <td class="meta">
            <g:textArea name="meta_name" style="width: 550px; height: 70px; resize: none" id="metaActividad" maxlength="200" class="form-control input-sm required" value="${actividad?.meta}"/>
        </td>
    </tr>
    </tbody>
</table>