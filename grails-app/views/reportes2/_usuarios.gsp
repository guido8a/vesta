<table border="1" style="width:100%;">
    <thead>
        <tr>
            <th></th>
            <th>
                Apellido
            </th>
            <th>
                Nombre
            </th>

            <th>
                Unidad
            </th>
            <th>
                Teléfono
            </th>
            <th>
                Correo
            </th>
            <th>
                Cargo
            </th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${usuarios}" var="u" status="i">
            <tr>
                <td>${i + 1}</td>
                <td>
                    ${u.persona?.apellido}
                </td>
                <td>
                    ${u.persona?.nombre}
                </td>


                <td>
                    ${u.unidad}
                </td>

                <td>
                    ${u.persona?.telefono}
                </td>

                <td>
                    ${u.persona?.mail}
                </td>

                <td>
                    ${u.cargoPersonal?.descripcion}
                </td>
            </tr>
        </g:each>
    </tbody>
</table>