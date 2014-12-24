<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/12/14
  Time: 12:15 PM
--%>

<%@ page import="vesta.parametros.Catalogo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!itemCatalogoInstance}">
    <elm:notFound elem="Item" genero="o" />
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmItem" role="form" controller="itemCatalogo" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${itemCatalogoInstance?.id}" />
            <g:hiddenField name="catalogo" value="${catalogo?.id}" />
            <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'codigo', 'error')} required">
                <span class="grupo">
                    <label for="codigo" class="col-md-2 control-label">
                        Código
                    </label>
                    <div class="col-md-6">
                        <g:textField name="codigo" id="id1" maxlength="255"  required="" class="form-control input-sm required unique noEspacios" value="${itemCatalogoInstance?.codigo}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>
                    <div class="col-md-6">
                        <g:textField name="descripcion" id="id2" maxlength="255" required="" class="form-control input-sm required" value="${itemCatalogoInstance?.descripcion}"/>
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
                        <g:select name="estado" from="${['1','0']}" required="" class="inList form-control input-sm required" value="${fieldValue(bean: itemCatalogoInstance, field: 'estado')}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'orden', 'error')}">
                <span class="grupo">
                    <label for="orden" class="col-md-2 control-label">
                        Orden
                    </label>
                    <div class="col-md-6">
                        <g:textField name="orden" id="id4" maxlength="3" class="form-control input-sm unique noEspacios" value="${itemCatalogoInstance?.orden}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: itemCatalogoInstance, field: 'original', 'error')}">
                <span class="grupo">
                    <label for="original" class="col-md-2 control-label">
                        Original
                    </label>
                    <div class="col-md-6">
                        <g:textField name="original" id="id5" maxlength="8" class="form-control input-sm unique noEspacios" value="${itemCatalogoInstance?.original}"/>
                    </div>
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmItem").validate({
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
                        url: "${createLink(action: 'validar_unique_codigoItem_ajax')}",
                        type: "post",
                        data: {
                            id: "${itemCatalogoInstance?.id}"
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