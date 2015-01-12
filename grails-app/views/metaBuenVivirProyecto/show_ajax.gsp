
<%@ page import="vesta.proyectos.MetaBuenVivirProyecto" %>

<g:if test="${!metaBuenVivirProyectoInstance}">
    <elm:notFound elem="MetaBuenVivirProyecto" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${metaBuenVivirProyectoInstance?.proyecto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Proyecto
                </div>
                
                <div class="col-md-4">
                    ${metaBuenVivirProyectoInstance?.proyecto?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${metaBuenVivirProyectoInstance?.metaBuenVivir}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Meta Buen Vivir
                </div>
                
                <div class="col-md-4">
                    ${metaBuenVivirProyectoInstance?.metaBuenVivir?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>