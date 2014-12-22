
<%@ page import="vesta.hitos.AvanceAvance" %>

<g:if test="${!avanceAvanceInstance}">
    <elm:notFound elem="AvanceAvance" genero="o" />
</g:if>
<g:else>

    <g:if test="${avanceAvanceInstance?.avance}">
        <div class="row">
            <div class="col-md-2">
                Avance
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceAvanceInstance}" field="avance"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceAvanceInstance?.avanceFisico}">
        <div class="row">
            <div class="col-md-2">
                Avance Fisico
            </div>
            
            <div class="col-md-3">
                ${avanceAvanceInstance?.avanceFisico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceAvanceInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avanceAvanceInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
</g:else>