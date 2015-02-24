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
    <style type="text/css">
    @font-face {
        font-family : 'Arial';
        src         : url('${resource(dir:"fontPdf", file: "arial.ttf")}');
    }

    @page {
        size   : 21cm 29.7cm;  /*width height */
        margin : 2cm;
    }

    body {
        font-family : Arial, arial, arial-black, sans-serif;
        font-size   : 10pt;
    }

    .hoja {
        width     : 15cm;
        font-size : 12pt;
    }

    .hoja {
        /*background  : #fedcba;*/
        height      : 24.7cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 12pt;
    }

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
<div class="hoja">
    <rep:headerReporte  title=""/>
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
                    <th>${gerente?.persona}</th>
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
            adjunto al presente sírvase encontrar la solicitud de reforma al Plan Operativo - POA 2014

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
        <g:if test="${solicitud.firmaSol.estado=='F'}">
            <img src="${resource(dir: 'firmas',file: solicitud.firmaSol.path)}"/><br/>
            ${solicitud.firmaSol.usuario.persona.nombre} ${solicitud.firmaSol.usuario.persona.apellido}<br/>
            ${solicitud.firmaSol.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>
            ${solicitud.firmaSol.fecha.format("dd-MM-yyyy hh:mm")}
        </g:if>
    %{--<div style="margin-top: 70px">--}%
    %{--${nombreFirma}--}%
    %{--</div>--}%
    %{--<div class="label">--}%
    %{--${cargoFirma}--}%
    %{--</div>--}%

    </div>

</div>

</body>
</html>