<%@ page import="vesta.parametros.Catalogo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!catalogoInstance}">
    <elm:notFound elem="Catalogo" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmCatalogo" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${catalogoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: catalogoInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="63" required="" class="form-control input-sm required" value="${catalogoInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: catalogoInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Código
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="8" required="" class="form-control input-sm required unique noEspacios" value="${catalogoInstance?.codigo}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: catalogoInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-2">
                    <g:select name="estado" from="${catalogoInstance.constraints.estado.inList}" required="" class="inList form-control input-sm required" value="${fieldValue(bean: catalogoInstance, field: 'estado')}" valueMessagePrefix="catalogo.estado"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmCatalogo").validate({
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
            
            , rules          : {
                
                codigo: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${catalogoInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigo: {
                    remote: "Ya existe Código"
                }
                
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