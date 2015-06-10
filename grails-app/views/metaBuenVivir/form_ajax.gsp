<%@ page import="vesta.proyectos.MetaBuenVivir" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!metaBuenVivirInstance}">
    <elm:notFound elem="MetaBuenVivir" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmMetaBuenVivir" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${metaBuenVivirInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: metaBuenVivirInstance, field: 'politica', 'error')} required">
            <span class="grupo">
                <label for="politica" class="col-md-2 control-label">
                    Política
                </label>
                <div class="col-md-10">
                    <g:select id="politica" name="politica.id" from="${vesta.proyectos.PoliticaBuenVivir.list()}" optionKey="id" required="" value="${metaBuenVivirInstance?.politica?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: metaBuenVivirInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Código
                </label>
                <div class="col-md-2">
                    <g:field name="codigo" type="number" value="${metaBuenVivirInstance.codigo}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: metaBuenVivirInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripción
                </label>
                <div class="col-md-10">
                    <g:textArea name="descripcion" maxlength="127" class="form-control input-sm" value="${metaBuenVivirInstance?.descripcion}" style="height: 60px;"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmMetaBuenVivir").validate({
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
                            id: "${metaBuenVivirInstance?.id}"
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
                submitFormMetaBuenVivir();
                return false;
            }
            return true;
        });
    </script>

</g:else>