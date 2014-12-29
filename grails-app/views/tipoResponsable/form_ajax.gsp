<%@ page import="vesta.parametros.TipoResponsable" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoResponsableInstance}">
    <elm:notFound elem="TipoResponsable" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTipoResponsable" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${tipoResponsableInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: tipoResponsableInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="1" required="" class="form-control input-sm required unique noEspacios" value="${tipoResponsableInstance?.codigo}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: tipoResponsableInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="15" required="" class="form-control input-sm required" value="${tipoResponsableInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTipoResponsable").validate({
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
                            id: "${tipoResponsableInstance?.id}"
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