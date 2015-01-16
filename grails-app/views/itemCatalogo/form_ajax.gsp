<%@ page import="vesta.parametros.ItemCatalogo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!itemCatalogoInstance}">
    <elm:notFound elem="ItemCatalogo" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmItemCatalogo" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${itemCatalogoInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textArea name="nombre" cols="40" rows="5" maxlength="255" required="" class="form-control input-sm required" value="${itemCatalogoInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'catalogo', 'error')} required">
            <span class="grupo">
                <label for="catalogo" class="col-md-2 control-label">
                    Catalogo
                </label>
                <div class="col-md-6">
                    <g:select id="catalogo" name="catalogo.id" from="${vesta.parametros.Catalogo.list()}" optionKey="id" required="" value="${itemCatalogoInstance?.catalogo?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" required="" class="form-control input-sm required unique noEspacios" value="${itemCatalogoInstance?.codigo}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" required="" class="form-control input-sm required" value="${itemCatalogoInstance?.descripcion}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'estado', 'error')} required">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-2">
                    <g:field name="estado" type="number" value="${itemCatalogoInstance.estado}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'orden', 'error')} required">
            <span class="grupo">
                <label for="orden" class="col-md-2 control-label">
                    Orden
                </label>
                <div class="col-md-2">
                    <g:field name="orden" type="number" value="${itemCatalogoInstance.orden}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'original', 'error')} required">
            <span class="grupo">
                <label for="original" class="col-md-2 control-label">
                    Original
                </label>
                <div class="col-md-2">
                    <g:field name="original" type="number" value="${itemCatalogoInstance.original}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmItemCatalogo").validate({
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
                            id: "${itemCatalogoInstance?.id}"
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