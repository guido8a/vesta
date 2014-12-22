<%--
  Created by IntelliJ IDEA.
  User: vanessa
  Date: 18/12/14
  Time: 03:21 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Parámetros</title>
</head>

<body>
<div class="row">
    <div class="col-md-8">

        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">Parámetros del Sistema</h3>
            </div>
            <div class="panel-body">
                <p><g:link data-info="catalogo" class="over" controller="catalogo" action="items">Catálogo del Sistema</g:link> datos tipo y parámetros que se usan en el sistema</p>
                <p><g:link data-info="presupuesto" class="over" controller="presupuesto" action="tree">Plan de cuentas Presupuestario</g:link> o partidas presupuestarias para la asignación de gasto corriente y de inversión</p>
                <p><g:link data-info="cargo" class="over" controller="cargoPersonal" action="list">Cargos del Personal de las Unidades</g:link> que se aplican a los responsables del ingreso y seguimiento del proyecto      </p>
                <p><g:link data-info="institucion" class="over" controller="tipoInstitucion" action="list">Área de Gestión</g:link> que se aplica a las distintas entidades y unidades responsables</p>
                <p><g:link data-info="estrategia" class="over" controller="estrategia" action="list">Estrategia</g:link> que se aplica de acuerdo al objetivo estratégico</p>
                <p><g:link data-info="anio" class="over" controller="anio" action="list">Año Fiscal</g:link> Año al cual corresponde el PAPP. Es similar al período contable o año fiscal</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-default" id="1" >
            <div class="panel-body" >
                <div class="catalogo" >
                    <h4>Catálogo del Sistema</h4><br>
                    <p>Valores de las tablas tipo del sistema y parámetros en general.</p>
                    <p>Entre los parámetros más importantes tenemos a: grupo de procesos, tipos de elemento, fuentes de recursos, tipo de compra,
                    año presupuestario, unidades de medida, programas, portafolios, etc..</p>
                </div>
                <div class="presupuesto" >
                    <p > Basic panel example </p>
                </div>
                <div class="cargo" >
                    <p > Basic panel example </p>
                </div>
                <div class="institucion" >
                    <p > Basic panel example </p>
                </div>
                <div class="estrategia" >
                    <p > Basic panel example </p>
                </div>
                <div class="anio" >
                    <p > Basic panel example </p>
                </div>


            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    //    $('.pres').mouseover(function() {$('#1').show()});
    $(function(){
        $('.over').hover(function() {
            $('#1').removeClass("hidden");
        }, function() {
            $('#1').addClass("hidden")
        });
    })

</script>

</body>
</html>