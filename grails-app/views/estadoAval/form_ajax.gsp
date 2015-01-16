<%@ page import="vesta.avales.EstadoAval" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!estadoAvalInstance}">
    <elm:notFound elem="EstadoAval" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmEstadoAval" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${estadoAvalInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: estadoAvalInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="50" required="" class="form-control input-sm required" value="${estadoAvalInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: estadoAvalInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="3" required="" class="form-control input-sm required unique noEspacios" value="${estadoAvalInstance?.codigo}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmEstadoAval").validate({
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
label.remove();
            }
            
            , rules          : {
                
                codigo: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${estadoAvalInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigo: {
                    remote: "Ya existe Codigo"
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