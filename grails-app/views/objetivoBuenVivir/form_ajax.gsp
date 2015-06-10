<%@ page import="vesta.proyectos.ObjetivoBuenVivir" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!objetivoBuenVivirInstance}">
    <elm:notFound elem="ObjetivoBuenVivir" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmObjetivoBuenVivir" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${objetivoBuenVivirInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: objetivoBuenVivirInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Código
                </label>
                <div class="col-md-2">
                    <g:field name="codigo" type="number" value="${objetivoBuenVivirInstance.codigo}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: objetivoBuenVivirInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripción
                </label>
                <div class="col-md-10">
                    <g:textArea name="descripcion" maxlength="127" class="form-control input-sm" value="${objetivoBuenVivirInstance?.descripcion}" style="height: 60px;"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmObjetivoBuenVivir").validate({
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
                            id: "${objetivoBuenVivirInstance?.id}"
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
                submitFormObjetivoBuenVivir();
                return false;
            }
            return true;
        });
    </script>

</g:else>