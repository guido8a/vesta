<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 01/07/15
  Time: 03:34 PM
--%>

<div class="alert alert-info">
    <p><strong> * La siguiente tarea se creará en:</strong></p>
    <p><strong>Objetivo:</strong> ${objetivo?.descripcion}</p>
    <p><strong>Macro Actividad:</strong> ${macro?.descripcion}</p>
    <p><strong>Actividad:</strong> ${actividad?.descripcion}</p>
</div>


<table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
    <thead>
    <th>Tarea</th>

    </thead>
    <tbody>

    <tr class="odd">
        <td class="tarea">
            <g:textArea name="tarea_name" style="width: 450px; height: 80px; resize: none" id="creacionTarea" maxlength="200" class="form-control input-sm"/>
        </td>
    </tr>

    </tbody>
</table>