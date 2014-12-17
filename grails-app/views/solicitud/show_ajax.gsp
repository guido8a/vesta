
<%@ page import="vesta.contratacion.Solicitud" %>

<g:if test="${!solicitudInstance}">
    <elm:notFound elem="Solicitud" genero="o" />
</g:if>
<g:else>

    <g:if test="${solicitudInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.revisadoAdministrativaFinanciera}">
        <div class="row">
            <div class="col-md-2">
                Revisado Administrativa Financiera
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.revisadoAdministrativaFinanciera}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.revisadoJuridica}">
        <div class="row">
            <div class="col-md-2">
                Revisado Juridica
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.revisadoJuridica}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.revisadoDireccionProyectos}">
        <div class="row">
            <div class="col-md-2">
                Revisado Direccion Proyectos
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.revisadoDireccionProyectos}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.observacionesAdministrativaFinanciera}">
        <div class="row">
            <div class="col-md-2">
                Observaciones Administrativa Financiera
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="observacionesAdministrativaFinanciera"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.observacionesJuridica}">
        <div class="row">
            <div class="col-md-2">
                Observaciones Juridica
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="observacionesJuridica"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.observacionesDireccionProyectos}">
        <div class="row">
            <div class="col-md-2">
                Observaciones Direccion Proyectos
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="observacionesDireccionProyectos"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathPdfTdr}">
        <div class="row">
            <div class="col-md-2">
                Path Pdf Tdr
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathPdfTdr"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathOferta1}">
        <div class="row">
            <div class="col-md-2">
                Path Oferta1
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathOferta1"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathOferta2}">
        <div class="row">
            <div class="col-md-2">
                Path Oferta2
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathOferta2"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathOferta3}">
        <div class="row">
            <div class="col-md-2">
                Path Oferta3
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathOferta3"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathCuadroComparativo}">
        <div class="row">
            <div class="col-md-2">
                Path Cuadro Comparativo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathCuadroComparativo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathAnalisisCostos}">
        <div class="row">
            <div class="col-md-2">
                Path Analisis Costos
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathAnalisisCostos"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.incluirReunion}">
        <div class="row">
            <div class="col-md-2">
                Incluir Reunion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="incluirReunion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathRevisionGAF}">
        <div class="row">
            <div class="col-md-2">
                Path Revision GAF
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathRevisionGAF"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathRevisionGJ}">
        <div class="row">
            <div class="col-md-2">
                Path Revision GJ
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathRevisionGJ"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathRevisionGDP}">
        <div class="row">
            <div class="col-md-2">
                Path Revision GDP
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathRevisionGDP"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.validadoAdministrativaFinanciera}">
        <div class="row">
            <div class="col-md-2">
                Validado Administrativa Financiera
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.validadoAdministrativaFinanciera}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.validadoJuridica}">
        <div class="row">
            <div class="col-md-2">
                Validado Juridica
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.validadoJuridica}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.fechaPeticionReunion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Peticion Reunion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.fechaPeticionReunion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.aprobacion}">
        <div class="row">
            <div class="col-md-2">
                Aprobacion
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.aprobacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.tipoAprobacion}">
        <div class="row">
            <div class="col-md-2">
                Tipo Aprobacion
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.tipoAprobacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.observacionesAprobacion}">
        <div class="row">
            <div class="col-md-2">
                Observaciones Aprobacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="observacionesAprobacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.pathAprobacion}">
        <div class="row">
            <div class="col-md-2">
                Path Aprobacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="pathAprobacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.revisionDireccionPlanificacionInversion}">
        <div class="row">
            <div class="col-md-2">
                Revision Direccion Planificacion Inversion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="revisionDireccionPlanificacionInversion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.asistentesAprobacion}">
        <div class="row">
            <div class="col-md-2">
                Asistentes Aprobacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="asistentesAprobacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.fechaParaRevision}">
        <div class="row">
            <div class="col-md-2">
                Fecha Para Revision
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.fechaParaRevision}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.actividad}">
        <div class="row">
            <div class="col-md-2">
                Actividad
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.actividad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.detallesMonto}">
        <div class="row">
            <div class="col-md-2">
                Detalles Monto
            </div>
            
            <div class="col-md-3">
                <ul>
                    <g:each in="${solicitudInstance.detallesMonto}" var="d">
                        <li>${d?.encodeAsHTML()}</li>
                    </g:each>
                </ul>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.formaPago}">
        <div class="row">
            <div class="col-md-2">
                Forma Pago
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="formaPago"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.montoSolicitado}">
        <div class="row">
            <div class="col-md-2">
                Monto Solicitado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="montoSolicitado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.nombreProceso}">
        <div class="row">
            <div class="col-md-2">
                Nombre Proceso
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="nombreProceso"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.objetoContrato}">
        <div class="row">
            <div class="col-md-2">
                Objeto Contrato
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="objetoContrato"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.plazoEjecucion}">
        <div class="row">
            <div class="col-md-2">
                Plazo Ejecucion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudInstance}" field="plazoEjecucion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.tipoBien}">
        <div class="row">
            <div class="col-md-2">
                Tipo Bien
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.tipoBien?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.tipoContrato}">
        <div class="row">
            <div class="col-md-2">
                Tipo Contrato
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.tipoContrato?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.unidadEjecutora}">
        <div class="row">
            <div class="col-md-2">
                Unidad Ejecutora
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.unidadEjecutora?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudInstance?.usuario}">
        <div class="row">
            <div class="col-md-2">
                Usuario
            </div>
            
            <div class="col-md-3">
                ${solicitudInstance?.usuario?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>