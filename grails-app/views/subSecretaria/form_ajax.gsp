<%@ page import="vesta.parametros.SubSecretaria" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!subSecretariaInstance}">
    <elm:notFound elem="SubSecretaria" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmSubSecretaria" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${subSecretariaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: subSecretariaInstance, field: 'entidad', 'error')} ">
            <span class="grupo">
                <label for="entidad" class="col-md-2 control-label">
                    Entidad
                </label>
                <div class="col-md-6">
                    <g:select id="entidad" name="entidad.id" from="${vesta.parametros.Entidad.list()}" optionKey="id" value="${subSecretariaInstance?.entidad?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: subSecretariaInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="63" required="" class="form-control required" value="${subSecretariaInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: subSecretariaInstance, field: 'titulo', 'error')} ">
            <span class="grupo">
                <label for="titulo" class="col-md-2 control-label">
                    Titulo
                </label>
                <div class="col-md-6">
                    <g:textField name="titulo" maxlength="63" class="form-control" value="${subSecretariaInstance?.titulo}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmSubSecretaria").validate({
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
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>