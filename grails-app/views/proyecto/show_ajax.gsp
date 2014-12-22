
<%@ page import="vesta.proyectos.Proyecto" %>

<g:if test="${!proyectoInstance}">
    <elm:notFound elem="Proyecto" genero="o" />
</g:if>
<g:else>

    <g:if test="${proyectoInstance?.unidadEjecutora}">
        <div class="row">
            <div class="col-md-2">
                Unidad Ejecutora
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.unidadEjecutora?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.etapa}">
        <div class="row">
            <div class="col-md-2">
                Etapa
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.etapa?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fase}">
        <div class="row">
            <div class="col-md-2">
                Fase
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.fase?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.tipoProducto}">
        <div class="row">
            <div class="col-md-2">
                Tipo Producto
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.tipoProducto?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.estadoProyecto}">
        <div class="row">
            <div class="col-md-2">
                Estado Proyecto
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.estadoProyecto?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.linea}">
        <div class="row">
            <div class="col-md-2">
                Linea
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.linea?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.tipoInversion}">
        <div class="row">
            <div class="col-md-2">
                Tipo Inversion
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.tipoInversion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.cobertura}">
        <div class="row">
            <div class="col-md-2">
                Cobertura
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.cobertura?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.calificacion}">
        <div class="row">
            <div class="col-md-2">
                Calificacion
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.calificacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.programa}">
        <div class="row">
            <div class="col-md-2">
                Programa
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.programa?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.codigoProyecto}">
        <div class="row">
            <div class="col-md-2">
                Codigo Proyecto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="codigoProyecto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fechaRegistro}">
        <div class="row">
            <div class="col-md-2">
                Fecha Registro
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${proyectoInstance?.fechaRegistro}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fechaModificacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Modificacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${proyectoInstance?.fechaModificacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.monto}">
        <div class="row">
            <div class="col-md-2">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.producto}">
        <div class="row">
            <div class="col-md-2">
                Producto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="producto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fechaInicioPlanificada}">
        <div class="row">
            <div class="col-md-2">
                Fecha Inicio Planificada
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${proyectoInstance?.fechaInicioPlanificada}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-2">
                Fecha Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${proyectoInstance?.fechaInicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fechaFinPlanificada}">
        <div class="row">
            <div class="col-md-2">
                Fecha Fin Planificada
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${proyectoInstance?.fechaFinPlanificada}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.fechaFin}">
        <div class="row">
            <div class="col-md-2">
                Fecha Fin
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${proyectoInstance?.fechaFin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.mes}">
        <div class="row">
            <div class="col-md-2">
                Mes
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="mes"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.problema}">
        <div class="row">
            <div class="col-md-2">
                Problema
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="problema"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.informacionDias}">
        <div class="row">
            <div class="col-md-2">
                Informacion Dias
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="informacionDias"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.subPrograma}">
        <div class="row">
            <div class="col-md-2">
                Sub Programa
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="subPrograma"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.aprobado}">
        <div class="row">
            <div class="col-md-2">
                Aprobado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="aprobado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.aprobadoPoa}">
        <div class="row">
            <div class="col-md-2">
                Aprobado Poa
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="aprobadoPoa"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.objetivoEstrategico}">
        <div class="row">
            <div class="col-md-2">
                Objetivo Estrategico
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.objetivoEstrategico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.ejeProgramatico}">
        <div class="row">
            <div class="col-md-2">
                Eje Programatico
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.ejeProgramatico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.lineaBase}">
        <div class="row">
            <div class="col-md-2">
                Linea Base
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="lineaBase"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.poblacionObjetivo}">
        <div class="row">
            <div class="col-md-2">
                Poblacion Objetivo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="poblacionObjetivo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.objetivoGobiernoResultado}">
        <div class="row">
            <div class="col-md-2">
                Objetivo Gobierno Resultado
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.objetivoGobiernoResultado?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.programaPresupuestario}">
        <div class="row">
            <div class="col-md-2">
                Programa Presupuestario
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.programaPresupuestario?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.codigoEsigef}">
        <div class="row">
            <div class="col-md-2">
                Codigo Esigef
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="codigoEsigef"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.unidadAdministradora}">
        <div class="row">
            <div class="col-md-2">
                Unidad Administradora
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.unidadAdministradora?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.portafolio}">
        <div class="row">
            <div class="col-md-2">
                Portafolio
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.portafolio?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${proyectoInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${proyectoInstance?.estrategia}">
        <div class="row">
            <div class="col-md-2">
                Estrategia
            </div>
            
            <div class="col-md-3">
                ${proyectoInstance?.estrategia?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>