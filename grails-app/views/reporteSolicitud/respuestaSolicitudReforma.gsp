<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/14
  Time: 02:42 PM
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

    </style>
</head>


<body>
<div class="hoja">
    <div>
        <div style="text-align: right" class="label">Memorando Nro. ${numero}</div>
        <div style="text-align: right" class="label">Quito, D.M., ${fecha}</div>
    </div>

    <div style="margin-top: 30px">

        <div>
            <table width="80%">
                <tr>
                    <th>
                        PARA:
                    </th>
                    <th>${para}</th>
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
            En atención al memorando N° ${numero}, de ${fecha}, con el cual la Gerencia Administrativa Financiera
            solicita reformar la Planificación Operativa Institucional - POA 2014, para cuyo efecto remite el formulario
            de solicitud respectivo; informo a usted que la Gerencia de Planificación efectuó la reforma solicitada, Sírvase
            encontrar adjunto al presente el Ajuste de POA 2014-GP N° 007 aprobado

        </div>

        <div style="margin-top: 10px">
            Atentamente,
        </div>

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