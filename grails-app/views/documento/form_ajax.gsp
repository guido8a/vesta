<%@ page import="vesta.proyectos.Documento" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/jquery-validation-1.13.1/dist', file: 'additional-methods.min.js')}"></script>
<g:if test="${!documentoInstance}">
    <elm:notFound elem="Documento" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:uploadForm class="form-horizontal" name="frmDocumento" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${documentoInstance?.id}"/>
            <g:hiddenField name="proyecto.id" value="${documentoInstance?.proyectoId}"/>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'grupoProcesos', 'error')} ">
                <span class="grupo">
                    <label for="grupoProcesos" class="col-md-4 control-label">
                        Grupo de Procesos
                    </label>

                    <div class="col-md-6">
                        <g:select id="grupoProcesos" name="grupoProcesos.id" from="${vesta.parametros.proyectos.GrupoProcesos.list()}" optionKey="id" value="${documentoInstance?.grupoProcesos?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-4 control-label">
                        Descripción
                    </label>

                    <div class="col-md-6">
                        <g:textField name="descripcion" maxlength="63" class="form-control input-sm required"
                                     value="${documentoInstance?.descripcion}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'clave', 'error')} ">
                <span class="grupo">
                    <label for="clave" class="col-md-4 control-label">
                        Palabras Clave
                    </label>

                    <div class="col-md-6">
                        <g:textField name="clave" maxlength="63" class="form-control input-sm" value="${documentoInstance?.clave}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'resumen', 'error')} ">
                <span class="grupo">
                    <label for="resumen" class="col-md-4 control-label">
                        Resumen
                    </label>

                    <div class="col-md-6">
                        <g:textArea name="resumen" cols="40" rows="5" maxlength="1024" class="form-control input-sm" value="${documentoInstance?.resumen}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'documento', 'error')} ">
                <span class="grupo">
                    <label for="documento" class="col-md-4 control-label">
                        Documento
                    </label>

                    <div class="col-md-6">
                        <input type="file" name="documento" id="documento" class="form-control input-sm required"/>
                    </div>

                </span>
            </div>
        </g:uploadForm>
    </div>

    <script type="text/javascript">
        var okContents = {
            'image/png'  : "png",
            'image/jpeg' : "jpeg",
            'image/jpg'  : "jpg",

            'application/pdf'      : 'pdf',
            'application/download' : 'pdf',

            'application/excel'                                                 : 'xls',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' : 'xlsx',

            'application/mspowerpoint'                                                  : 'pps',
            'application/vnd.ms-powerpoint'                                             : 'pps',
            'application/powerpoint'                                                    : 'ppt',
            'application/x-mspowerpoint'                                                : 'ppt',
            'application/vnd.openxmlformats-officedocument.presentationml.slideshow'    : 'ppsx',
            'application/vnd.openxmlformats-officedocument.presentationml.presentation' : 'pptx',

            'application/msword'                                                      : 'doc',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document' : 'docx',

            'application/vnd.oasis.opendocument.text'         : 'odt',
            'application/vnd.oasis.opendocument.presentation' : 'odp',
            'application/vnd.oasis.opendocument.spreadsheet'  : 'ods'
        };

        var okExt = "", okExt2 = "";
        $.each(okContents, function (mime, ext) {
            if (okExt != "") {
                okExt += "|";
                okExt2 += ", ";
            }
            okExt += ext;
            okExt2 += ext;
        });
        console.log(okExt);

        var validator = $("#frmDocumento").validate({
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
            },
            rules          : {
                documento : {
                    required  : true,
                    extension : okExt
                }
            },
            messages       : {
                documento : {
                    extension : "Por favor ingrese un archivo de tipo " + okExt2
                }
            }
        });

        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormDocumento();
                return false;
            }
            return true;
        });
    </script>

</g:else>