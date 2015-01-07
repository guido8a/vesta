<%@ page import="vesta.proyectos.Proyecto" %>

<g:if test="${!proyectoInstance}">
    <elm:notFound elem="Proyecto" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">
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
                        <g:if test="${proyectoInstance?.unidadEjecutora}">
                            <div class="row">
                                <div class="col-md-2 show-label">Pertenece a</div>

                                <div class="col-md-5">${proyectoInstance?.unidadEjecutora}</div>

                                <div class="col-md-2 show-label">Aprobado</div>

                                <div class="col-md-3">${(proyectoInstance.aprobado == "a") ? "Si" : "No"}</div>
                            </div>
                        </g:if>

                        <div class="row">
                            <div class="col-md-2 show-label">Nombre</div>

                            <div class="col-md-10">${proyectoInstance.nombre}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Obj. estratégico</div>

                            <div class="col-md-10">${proyectoInstance?.objetivoEstrategico?.descripcion}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Estrategia</div>

                            <div class="col-md-10">${proyectoInstance?.estrategia?.descripcion}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Portafolio</div>

                            <div class="col-md-10">${proyectoInstance?.portafolio?.descripcion}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Programa</div>

                            <div class="col-md-10">${proyectoInstance?.programa?.descripcion}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">U. Administradora</div>

                            <div class="col-md-10">${proyectoInstance?.unidadAdministradora?.nombre}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Código</div>

                            <div class="col-md-5">${proyectoInstance?.codigo}</div>

                            <div class="col-md-2 show-label">C.U.P.</div>

                            <div class="col-md-3">${proyectoInstance?.codigoProyecto}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Monto</div>

                            <div class="col-md-5"><g:formatNumber number="${proyectoInstance.monto}"
                                                                  format="###,##0"
                                                                  minFractionDigits="2" maxFractionDigits="2"/></div>

                            <div class="col-md-2 show-label">Código financiero</div>

                            <div class="col-md-3">${proyectoInstance?.codigoEsigef}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">F. ini. planificada</div>

                            <div class="col-md-5"><g:formatDate date="${proyectoInstance?.fechaInicioPlanificada}"
                                                                format="dd-MM-yyyy"/></div>

                            <div class="col-md-2 show-label">F. ini. ejecución</div>

                            <div class="col-md-3"><g:formatDate date="${proyectoInstance?.fechaInicio}"
                                                                format="dd-MM-yyyy"/></div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">F. fin planificada</div>

                            <div class="col-md-5"><g:formatDate date="${proyectoInstance?.fechaFinPlanificada}"
                                                                format="dd-MM-yyyy"/></div>

                            <div class="col-md-2 show-label">F. fin ejecución</div>

                            <div class="col-md-3"><g:formatDate date="${proyectoInstance?.fechaFin}"
                                                                format="dd-MM-yyyy"/></div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Justificación</div>

                            <div class="col-md-10">${proyectoInstance?.justificacion}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Descripción</div>

                            <div class="col-md-10">${proyectoInstance?.descripcion}</div>
                        </div>

                        <div class="row">
                            <div class="col-md-2 show-label">Propósito</div>

                            <div class="col-md-10">${proyectoInstance?.problema}</div>
                        </div>
                    </div>
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

            <div id="collapseTwo" class="panel-collapse collapse " role="tabpanel" aria-labelledby="headingTwo">
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

            <div id="collapseThree" class="panel-collapse collapse " role="tabpanel" aria-labelledby="headingThree">
                <div class="panel-body">

                </div>
            </div>
        </div>
    </div>
    </div>
</g:else>