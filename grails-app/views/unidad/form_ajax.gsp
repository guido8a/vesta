<%@ page import="vesta.parametros.Unidad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!unidadInstance}">
    <elm:notFound elem="Unidad" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmUnidad" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${unidadInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: unidadInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="7" class="form-control input-sm unique noEspacios" value="${unidadInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="63" class="form-control input-sm" value="${unidadInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmUnidad").validate({
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
                            id: "${unidadInstance?.id}"
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