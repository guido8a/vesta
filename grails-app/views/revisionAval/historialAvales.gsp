<%@ page import="vesta.avales.SolicitudAval; vesta.avales.Aval" %>
<%@ page import="vesta.seguridad.FirmasService" %>
<%
    def firmasService = grailsApplication.classLoader.loadClass('vesta.seguridad.FirmasService').newInstance()
%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

%{--<div class="modal-contenido">--}%

    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <div>
            <tr>
                <th sort="requiriente" class="" style="width: 120px">Requirente</th>
                <th class="" style="width: 60px">Solicitud No.</th>
                <th sort="numero" class="sort ${(sort == 'numero') ? order : ''}" style="width: 60px">Aval No.</th>
                <th sort="fechaAprobacion" class="sort ${(sort == 'fechaAprobacion') ? order : ''}" style="width: 60px">F. Emisión</th>
                <th sort="proceso" class="sort ${(sort == 'proceso') ? order : ''}" style="width: 300px">Proceso</th>
                <th sort="monto" class="sort ${(sort == 'monto') ? order : ''}" style="width: 70px">Monto</th>
                <th sort="estado" class="sort ${(sort == 'estado') ? order : ''}" style="width: 60px">Estado</th>
            </tr>
        </div>
        </thead>
    </table>

    <div class="row-fluid"  style="width: 99.7%;height: 600px;overflow-y: auto;float: right; margin-top: -20px">
        <div class="span12">

            <div style="width: 1130px; height: 600px;">
                <table class="table table-condensed table-bordered table-striped table-hover">
                    <tbody>
                    <g:each in="${datos}" var="aval" status="j">
                        <g:set var="sol" value="${SolicitudAval.findByAval(aval)}"/>
                        <tr estadoTr="${aval?.estado?.codigo}" data-sol="${sol.id}" data-id="${aval?.id}" usu="${perfil}">
                            <td style="width: 150px">${unidades[j]}</td>
                            <td style="width: 50px">${sol.fecha?.format("yyyy")}-${firmasService.requirentes(sol.usuario.unidad)?.codigo} No.<elm:imprimeNumero solicitud="${sol.id}"/></td>
                            <td style="width: 50px">${aval.fechaAprobacion?.format("yyyy")}-GPE No.<elm:imprimeNumero aval="${aval.id}"/></td>
                            <td style="width: 60px">${aval.fechaAprobacion?.format("dd-MM-yyyy")}</td>
                            %{--<td style="text-align: center" title="${aval.proceso.proyecto.toStringCompleto()}">${aval.proceso.proyecto}</td>--}%
                            <td style="width: 370px">${aval.proceso.nombre}</td>
                            <td style="text-align: right; width: 70px">
                                <g:formatNumber number="${aval.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            %{--<td>${sol.unidad}</td>--}%
                            <g:set var="avalEstado" value="${aval.estado?.codigo}"/>
                            <td style="text-align: center; width: 60px" class="${avalEstado == 'E05' ? 'amarillo' : avalEstado == 'E04' ? 'rojo' : 'verde'}">
                                ${aval.estado?.descripcion}
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
     </div>
%{--</div>--}%

        <script type="text/javascript">

            function submitForm() {
                var $form = $("#frmLiberar");
                var $btn = $("#dlgLiberar").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Liberando Aval");
                    var formData = new FormData($form[0]);
                    $.ajax({
                        type        : "POST",
                        url         : $form.attr("action"),
                        data        : formData,
                        async       : false,
                        cache       : false,
                        contentType : false,
                        processData : false,
                        success     : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.reload(true);
                                    closeLoader();
                                } else {
                                    closeLoader();
                                    spinner.replaceWith($btn);
                                    return false;

                                }
                            }, 1000);
                        }
                    });
                } else {
                    $('.modal-contenido').animate({
                        scrollTop : $($(".has-error")[0]).offset().top - 100
                    }, 1000);
                    return false;
                } //else
            }

            function liberarAval(id) {
                var data = id ? {id : id} : {};
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'liberarAval')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgLiberar",
                            title   : "Liberar Aval",
                            class   : "modal-lg",
                            message : msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                guardar  : {
                                    id        : "btnSave",
                                    label     : "<i class='fa fa-save'></i> Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        return submitForm();
                                        closeLoader();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //crea


            function cambiarNumero(id) {
                var data = id ? {id : id} : {};
                var idAval = id
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'cambiarNumero')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgCambiarNumero",
                            title   : "Cambiar Número",
                            class   : "modal-lg",
                            message : msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                guardar  : {
                                    id        : "btnSave",
                                    label     : "<i class='fa fa-save'></i> Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        var sol = $("#numNuevo").val()
                                        var av = $("#numNuevoAval").val()
                                        $.ajax ({
                                            type: 'POST',
                                            url: '${createLink(action: 'guardarCambioNumero')}',
                                            data: {
                                                sol: sol,
                                                aval: av,
                                                id: idAval
                                            },
                                            success: function (msg) {
                                                var parts = msg.split("*")
                                                if(parts[0] == 'ok'){
                                                    log("Número cambiado correctamente","success");
                                                    setTimeout(function () {
                                                        location.reload(true);
                                                    }, 2000);
                                                }else{
                                                    log(parts[1],"error");
                                                }
                                            }
                                        });
//                                return submitForm();
//                                closeLoader();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //crea




            $(".imprimiAval").button({icons : {primary : "ui-icon-print"}, text : false}).click(function () {
                //location.href = "${createLink(controller:'avales',action:'descargaAval')}/"+$(this).attr("iden")
                %{--var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id=" + $(this).attr("iden")--}%
                var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval.pdf"
            });
            $(".imprimiSolicitud").button({icons : {primary : "ui-icon-print"}, text : false}).click(function () {
                var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf"
            });
            $(".sort").click(function () {
                var header = $(this);
                var sort = header.attr("sort");
                var order = "";
                if (header.hasClass("asc")) {
                    order = "desc"
                } else {
                    order = "asc"
                }
                cargarHistorialSort($("#anio").val(), $("#numero").val(), $("#descProceso").val(), sort, order)
            }).css({"cursor" : "pointer"});

            function createContextMenu(node) {
                var $tr = $(node);

                var items = {
                    header   : {
                        label  : "Acciones",
                        header : true
                    },
                    imprimir : {
                        label  : "Imprimir Aval",
                        icon   : "fa fa-print",
                        action : function ($element) {
                            var id = $element.data("sol");
                            var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id=" + id;
                            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval.pdf"
                        }
                    },
                    solicitud: {
                        label   : "Imprimir Solicitud",
                        icon    : "fa fa-print" ,
                        action : function ($element) {
                            var id = $element.data("sol");
                            var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + id;
                            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf"
                        }
                    }
                };

                if ($tr.attr("estadoTr") == 'E02' && $tr.attr("usu") == 'ASPL') {
                    items.liberar = {
                        label  : "Liberar",
                        icon   : "fa fa-unlink",
                        action : function ($element) {
                            var id = $element.data("id");
                            liberarAval(id)
                            return false
                        }
                    };
                }

                //cambiar número
                if ($tr.attr("usu") == 'ASPL') {
                    items.numero = {
                        label  : "Cambiar número",
                        icon   : "fa fa-exchange",
                        action : function ($element) {
                            var id = $element.data("id");
                            cambiarNumero(id);
                            return false
                        }
                    };
                }



                return items;
            }

            $("tbody>tr").contextMenu({

                items  : createContextMenu,
                onShow : function ($element) {
                    $element.addClass("success");
                },
                onHide : function ($element) {
                    $(".success").removeClass("success");
                }
            });

        </script>