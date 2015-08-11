<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 21/10/14
  Time: 12:57 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Solicitud De Reforma POA</title>

        <rep:estilos orientacion="p" pagTitle="Solicitud Reforma"/>
    <style type="text/css">

    th {
        text-align: left;
    }

    .label {
        font-weight : bold;
    }
    .ttl {
        text-align  : center;
        font-weight : bold;
    }

    </style>
</head>


<body>

    <rep:headerFooter  title="Solicitud Reforma"/>
    <div>
        %{--<div style="text-align: right" class="label">Memorando Nro. ${numero}</div>--}%
        <div style="text-align: right" class="label">Quito, D.M., ${fecha}</div>
    </div>

    <div style="margin-top: 30px">

        <div>
            <table width="80%">
                <tr>
                    <th>
                        PARA:
                    </th>
                    <th>${gerente?.nombre + " " + gerente?.apellido }</th>
                </tr>
                <tr>
                    <th></th>
                    <th>${cargo}</th>
                </tr>
                <tr style="margin-top: 10px">
                    <th>ASUNTO:</th>
                    <th>${asunto.toUpperCase()}</th>
                </tr>
            </table>
        </div>

        <div style="margin-top: 40px">
            De mi consideración:

        </div>

        <div style="margin-top: 15px">
            Con el proposito de mejorar la ejecución de la planificación operativa institucional,
            adjunto al presente sírvase encontrar la solicitud de reforma al Plan Operativo - POA 2015

        </div>

        <div style="margin-top: 15px">
            Particular que pongo en su conocimiento para los fines pertinentes.
        </div>

        <div style="margin-top: 20px">
            Con sentimientos de distinguida consideración.
        </div>

        <div style="margin-top: 10px">
            Atentamente,
        </div>
        <g:if test="${solicitud?.firmaSol?.estado=='F'}">
            <img src="${resource(dir: 'firmas',file: solicitud.firmaSol.path)}"/><br/>
            ${solicitud.firmaSol.usuario.nombre} ${solicitud.firmaSol.usuario.apellido}<br/>
            %{--${solicitud.firmaSol.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
            ${solicitud.firmaSol.usuario.cargo?.toString()?.toUpperCase()}<br/>
            ${solicitud.firmaSol.fecha.format("dd-MM-yyyy hh:mm")}
        </g:if>
    %{--<div style="margin-top: 70px">--}%
    %{--${nombreFirma}--}%
    %{--</div>--}%
    %{--<div class="label">--}%
    %{--${cargoFirma}--}%
    %{--</div>--}%

    </div>

</body>
</html>