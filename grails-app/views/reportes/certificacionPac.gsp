<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Intervención e inversión en el año ${anio}</title>

    <style type="text/css">
    @page {
        size: 21cm 29.7cm;  /*width height */
        margin: 2cm;
    }

    .hoja {
        width: 15cm;
    }

    .titulo {
        width: 15.5cm;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height: 24.7cm; /*29.7-(1.5*2)*/
        font-family: arial;
        font-size: 12pt;
    }

    .titulo {
        font-size: 12pt;
        font-weight: bold;
        text-align: center;
        margin-top: 10px;
        margin-bottom: 30px;
        width: 15cm;



    }

    .marco {

        text-align: justify;


    }

    .texto {

        /*height        : 130px;*/
        font-size: 12pt;
        text-align: justify;
    }

    .tabla {
        display: table;
        margin: 10px;
    }

    .fila {
        display: table-row;
        margin-bottom: 5px;

    }

    .celda {

        display: table-cell;
        text-align: left;
      padding-bottom: 10px;

    }

    .label {

        width: 180px;

    }

    .intermedio {
        font-size: 12pt;
        margin-bottom: 10px;
        margin-top: 10px;
        text-align: left;
        float: left;

    }

    .intermedio2 {
        font-size: 12pt;
        text-align: left;
        margin-left: 10px;
        float: left;

    }

    .firma {
        font-size: 12pt;
        /*text-align: left;*/
        /*max-width: 20pt;*/
        margin-top: 100px;
    }

    .totales {
        font-weight: bold;
    }

    .num {
        text-align: right;
    }

    .header {
        background: #333333 !important;
        color: #AAAAAA;
    }

    .total {
        background: #000000 !important;
        color: #FFFFFF !important;
    }

    th {
        background: #cccccc;
    }

    tbody tr:nth-child(2n+1) {
        background: none repeat scroll 0 0 #E1F1F7;
    }

    tbody tr:nth-child(2n) {
        background: none repeat scroll 0 0 #F5F5F5;
    }
    </style>

</head>

<body>
<div class="hoja">

    <div class="marco ">
        <div style="width: 15cm; height: 130px;">
            <div style="width:120px;height: 120px;  ">
                <img src="${g.resource(dir: "images", file: "logo_app.jpg")}" alt="" width="100%" height="100%;"/>
            </div>
        </div>

        <div class=" titulo">Certificación Plan Anual de Contrataciones</div>

        <div class="tabla">

            <div class="fila">

                <div class="celda label">

                    Unidad Requiriente:

                </div>

                <div class="celda">

                    ${obra.unidad.descripcion}

                </div>

            </div>


            <div class="fila">

                <div class="celda label">

                    Fecha:

                </div>

                <div class="celda">

                    <g:formatDate date="${obra.fechaCertificado}" format="dd 'de' MMMM 'de' yyyy"> </g:formatDate>

                </div>

            </div>

        </div>

        <div class="texto">Mediante resolución Administrativa 1087 de 11 de enero de 2012, el Coordinador General
        Administrativo Financiero en delegación de la Máxima Autoridad, aprobó el Plan Anual de
        Contrataciones para el año 2012, dentro del cual se encuentra la siguiente actividad

        </div>


        <div class="tabla">

            <div class="fila">

                <div class="celda label">

                    Objeto de Contratación

                </div>

                <div class="celda">

                    <g:set var="asignacion" value="${obra.asignacion}"/>
                    
                    <g:if test="${asignacion.marcoLogico}">
                        ${asignacion.marcoLogico.objeto}

                    </g:if>

                    <g:else>

                        ${asignacion.actividad}


                    </g:else>

                </div>

            </div>


            <div class="fila">

                <div class="celda label">

                    Valor referencial:

                </div>

                <div class="celda">

                   <g:set var="cantidad" value="${obra.cantidad}" />

                   <g:set var="costo" value="${obra.costo}" />

                    <g:set var="total" value="${cantidad*costo}"/>


                    USD $ <g:formatNumber number="${total}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber>



                </div>

            </div>




            <div class="fila">

                <div class="celda label">

                    Código CPC:

                </div>

                <div class="celda">

                   <g:set var="cpc" value="${obra.codigoComprasPublicas.numero}" />

                    ${cpc}


                </div>

            </div>


            <div class="fila">

                <div class="celda label">

                    Partida Presupuestaría:

                </div>

                <div class="celda">

                    <g:set var="partida" value="${obra.asignacion.presupuesto}" />

                    ${partida}

                </div>

            </div>

        </div>




        <div class="texto">Por tanto, en cumplimiento con lo señalado en la Ley Orgánica del Sistema Nacional de
        Contratación Pública y su Reglamento General de Aplicación, me permito emitir la
        presente certificación del PAC para la actividad mencionada
        Atentamente
        </div>

        <div class="firma">
            Marcelo Rodas Flores

        </div>
        <div class="texto">

            <b>DIRECTOR ADMINISTRATIVO</b>
        </div>

    </div>

</div>



</body>
</html>