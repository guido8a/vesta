<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 06/01/15
  Time: 04:34 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Ver Proyecto</title>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="list" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>

            <div class="btn-group" role="group">
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        <i class="fa fa-clipboard"></i> Proyecto
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li>
                            <a href="#">
                                <i class="fa fa-calculator"></i> Presupuesto/Fuentes
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <i class="fa fa-files-o"></i> Documentos del proyecto
                            </a>
                        </li>
                    </ul>
                </div>

                <a href="#" class="btn btn-sm btn-default btnCrear">
                    <i class="fa fa-calendar-o"></i> Plan de proyecto
                </a>

                <a href="#" class="btn btn-sm btn-default btnCrear">
                    <i class="fa fa-calendar"></i> Cronograma
                </a>

                <a href="#" class="btn btn-sm btn-default btnCrear">
                    <i class="fa fa-shopping-cart"></i> P.A.C.
                </a>
            </div>

            <div class="btn-group">
                <a href="#" class="btn btn-sm btn-default btnCrear">
                    <i class="fa fa-trash-o"></i> Eliminar
                </a>
            </div>
        </div>

        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingOne">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                            Detalles del proyecto
                        </a>
                    </h4>
                </div>

                <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body">

                    </div>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingTwo">
                    <h4 class="panel-title">
                        <a class="collapsed" data-toggle="collapse" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                            Plan Nacional de Desarrollo (Buen Vivir)
                        </a>
                    </h4>
                </div>

                <div id="collapseTwo" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingTwo">
                    <div class="panel-body">

                    </div>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingThree">
                    <h4 class="panel-title">
                        <a class="collapsed" data-toggle="collapse" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                            Presupuestos / Fuentes
                        </a>
                    </h4>
                </div>

                <div id="collapseThree" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingThree">
                    <div class="panel-body">

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>