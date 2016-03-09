<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 08/03/16
  Time: 04:18 PM
--%>

<table class="table table-condensed table-bordered">
    <thead>
    <tr>
        <th>Proyecto</th>
        <th>Proceso</th>
        <th>Justificación</th>
    </tr>
    </thead>
    <tbody>
    <tr style="height: 170px; width: 500px">
        <td style="height: 150px; width: 100px">${solicitud.proceso.proyecto.nombre}</td>
        <td style="height: 150px; width: 200px; text-align: center"><g:textArea name="procesoNombre" id="procesoNombre" value="${solicitud.proceso.nombre}" style="height: 150px; width: 290px" maxlength="255"/></td>
        <td style="height: 150px; width: 200px; text-align: center"><g:textArea name="concepto" id="concepto" value="${solicitud.concepto}" style="height: 150px; width: 290px" maxlength="500"/></td>
    </tr>
    </tbody>
</table>