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
                        <ul class="fa-ul">
                            <li>
                                <i class="fa-li fa fa-hand-o-right text-info"></i>
                                <g:link data-info="catalogo" class="over" controller="catalogo" action="items">
                                    Catálogo del Sistema
                                </g:link> datos tipo y parámetros que se usan en el sistema

                                <div class="descripcion hidden">
                                    <h4>Catálogo del Sistema</h4>

                                    <p>Valores de las tablas tipo del sistema y parámetros en general.</p>

                                    <p>Entre los parámetros más importantes tenemos a: grupo de procesos, tipos de elemento,
                                    fuentes de recursos, tipo de compra, año presupuestario, unidades de medida, programas,
                                    portafolios, etc..</p>
                                </div>
                            </li>

                            <li>
                                <i class="fa-li fa fa-hand-o-right text-info"></i>
                                <g:link data-info="categoria" class="over" controller="categoria" action="list">
                                    Categorías de Actividades
                                </g:link> para difenciar entre Estudios, construcción, fiscalización

                                <div class="descripcion hidden">
                                    <h4>Categorías</h4>

                                    <p>Valores de las categorías de las actividades dentro de los componenetes de un proyecto.</p>

                                    <p>Las categorías poseen valores de "ninguna" o específicos como Estudios, construcción, fiscalización, etc..</p>
                                </div>
                            </li>

                            <li>
                                <i class="fa-li fa fa-money text-success"></i>
                                <g:link class="over" controller="presupuesto" action="arbol">
                                    Plan de cuentas Presupuestario
                                </g:link> o partidas presupuestarias para la asignación de gasto corriente y de inversión

                                <div class="descripcion hidden">
                                    <h4>Plan de cuentas Presupuestario</h4>

                                    <p>Plan de cuentas o de partidas presupuestarias conforme exista en el ESIGEF</p>
                                </div>
                            </li>

                            <li>
                                <i class="fa-li fa fa-users text-info"></i>
                                <g:link data-info="cargo" class="over" controller="cargoPersonal" action="list">
                                    Cargos del Personal de las Unidades
                                </g:link> que se aplican a los responsables del ingreso y seguimiento del proyecto

                                <div class="descripcion hidden">
                                    <h4>Cargos del Personal</h4>

                                    <p>Cargos del personal de la Unidad Ejecutora y de la planta central del app.</p>

                                    <p>Estos cargo se aplican a quienes van a ser los responsables del ingreso o seguimiento
                                    y de la ejecución del proyecto</p>
                                </div>
                            </li>

                            <li>
                                <i class="fa-li fa fa-building-o text-info"></i>
                                <g:link class="over" controller="tipoInstitucion" action="list">
                                    Área de Gestión
                                </g:link> que se aplica a las distintas entidades y unidades responsables

                                <div class="descripcion hidden">
                                    <h4>Area de Gestión</h4>

                                    <p>Se aplica a las distintas entidades, instituciones y dependencias para diferenciarlas como:</p>

                                    <p>Gerencias, Direcciones, Unidades Operativas, etc.</p>
                                </div>
                            </li>

                            <li>
                                <i class="fa-li fa fa-bar-chart-o text-info"></i>
                                <g:link class="over" controller="estrategia" action="list">
                                    Estrategia
                                </g:link> que se aplica de acuerdo al objetivo estratégico

                                <div class="descripcion hidden">
                                    <h4>Estratagia</h4>

                                    <p>Estrategia específica edntro del objetivo estratégico con la cual se alinea uno o varios proyectos</p>
                                </div>
                            </li>

                            <li>
                                <i class="fa-li fa fa-calendar text-info"></i>
                                <g:link class="over" controller="anio" action="list">
                                    Año Fiscal
                                </g:link> Año al cual corresponde el PAPP. Es similar al período contable o año fiscal

                                <div class="descripcion hidden">
                                    <h4>Año Fiscal</h4>

                                    <p>Año al cual corresponde el PAPP, cada año debe iniciarse una nueva gestión de proyectos.</p>

                                    <p>Es similar al período contable o año fiscal.</p>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="panel panel-info right hidden">
                    <div class="panel-heading">
                        <h3 class="panel-title"></h3>
                    </div>

                    <div class="panel-body">

                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                $(".over").hover(function () {
                    var $h4 = $(this).siblings(".descripcion").find("h4");
                    var $cont = $(this).siblings(".descripcion").find("p");
                    $(".right").removeClass("hidden").find(".panel-title").text($h4.text()).end().find(".panel-body").html($cont.html());
                }, function () {
                    $(".right").addClass("hidden");
                });
            });
        </script>

    </body>
</html>