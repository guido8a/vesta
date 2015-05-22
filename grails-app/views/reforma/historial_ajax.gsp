<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 02:41 PM
--%>

<script src="${resource(dir: 'js', file: 'ui.js')}"></script>

<table class="table table-bordered table-hover table-condensed">
    <thead>
        <tr>
            <th>Solicita</th>
            <th>Fecha</th>
            <th>Concepto</th>
            <th>Tipo</th>
            <th>Estado</th>
            <th>Ver</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${reformas}" var="reforma">
            <tr>
                <td>${reforma.persona.unidad} - ${reforma.persona}</td>
                <td>${reforma.fecha.format("dd-MM-yyyy")}</td>
                <td>${reforma.concepto}</td>
                <td>
                    <elm:tipoReforma reforma="${reforma}"/>
                </td>
                <td class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                <td>
                    <div class="btn-group" role="group">
                        <elm:linkPdfReforma reforma="${reforma}"/>
                    </div>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>