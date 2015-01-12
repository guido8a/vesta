<%@ page import="vesta.proyectos.MetaBuenVivirProyecto" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!metaBuenVivirProyectoInstance}">
    <elm:notFound elem="MetaBuenVivirProyecto" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmMetaBuenVivirProyecto" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${metaBuenVivirProyectoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: metaBuenVivirProyectoInstance, field: 'proyecto', 'error')} required">
            <span class="grupo">
                <label for="proyecto" class="col-md-2 control-label">
                    Proyecto
                </label>
                <div class="col-md-6">
                    <g:select id="proyecto" name="proyecto.id" from="${vesta.proyectos.Proyecto.list()}" optionKey="id" required="" value="${metaBuenVivirProyectoInstance?.proyecto?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: metaBuenVivirProyectoInstance, field: 'metaBuenVivir', 'error')} required">
            <span class="grupo">
                <label for="metaBuenVivir" class="col-md-2 control-label">
                    Meta Buen Vivir
                </label>
                <div class="col-md-6">
                    <g:select id="metaBuenVivir" name="metaBuenVivir.id" from="${vesta.proyectos.MetaBuenVivir.list()}" optionKey="id" required="" value="${metaBuenVivirProyectoInstance?.metaBuenVivir?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmMetaBuenVivirProyecto").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }
            
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormMetaBuenVivirProyecto();
                return false;
            }
            return true;
        });
    </script>

</g:else>