<%@ page import="vesta.proyectos.PoliticaBuenVivir" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!politicaBuenVivirInstance}">
    <elm:notFound elem="PoliticaBuenVivir" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmPoliticaBuenVivir" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${politicaBuenVivirInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: politicaBuenVivirInstance, field: 'objetivo', 'error')} required">
            <span class="grupo">
                <label for="objetivo" class="col-md-2 control-label">
                    Objetivo
                </label>
                <div class="col-md-10">
                    <g:select id="objetivo" name="objetivo.id" from="${vesta.proyectos.ObjetivoBuenVivir.list()}" optionKey="id" required="" value="${politicaBuenVivirInstance?.objetivo?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: politicaBuenVivirInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Código
                </label>
                <div class="col-md-2">
                    <g:field name="codigo" type="number" value="${politicaBuenVivirInstance.codigo}" class="digits form-control input-sm required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: politicaBuenVivirInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripción
                </label>
                <div class="col-md-10">
                    <g:textArea name="descripcion" maxlength="511" class="form-control input-sm"
                                value="${politicaBuenVivirInstance?.descripcion}" style="height: 100px"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmPoliticaBuenVivir").validate({
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
                            id: "${politicaBuenVivirInstance?.id}"
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
                submitFormPoliticaBuenVivir();
                return false;
            }
            return true;
        });
    </script>

</g:else>