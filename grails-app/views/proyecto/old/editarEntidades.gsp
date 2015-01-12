<%@ page import="yachay.proyectos.EntidadesProyecto; yachay.parametros.TipoParticipacion" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>

        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins/validation', file: 'jquery.validate.min.js')}"></script>
        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins/validation', file: 'additional-methods.js')}"></script>
        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins/validation', file: 'messages_es.js')}"></script>

        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins/qtip', file: 'jquery.qtip.min.js')}"></script>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/qtip', file: 'jquery.qtip.css')}"/>
        <link rel="stylesheet" href="${resource(dir: 'css/menuSemplades', file: 'flow_menu_green.css')}"/>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'Base.css')}"
              type="text/css"/>
        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'BreadCrumb.css')}"
              type="text/css"/>

        <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.easing.1.3.js')}" type="text/javascript"
                language="JavaScript"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jBreadCrumb/js', file: 'jquery.jBreadCrumb.1.1.js')}"
                type="text/javascript" language="JavaScript"></script>

        <g:set var="titulo" value="Entidades del proyecto"/>
        <g:set var="sing" value="Entidad del proyecto"/>
        <g:set var="min" value="entidadesProyecto"/>
        <g:set var="may" value="EntidadesProyecto"/>
        <g:set var="abr" value="Entidad"/>

        <title>${titulo} del proyecto ${proyecto}</title>
    </head>

    <body>

        <div class="breadCrumbHolder module">
            <div id="breadCrumb" class="breadCrumb module">
                <ul>
                    <li>
                        <g:link class="bc" controller="proyecto" action="show"
                                id="${proyecto.id}">
                            Proyecto
                        </g:link>
                    </li>
                    <li>
                        <g:link class="bc" controller="proyecto" action="verEntidades"
                                id="${proyecto.id}">
                            Entidades proyecto
                        </g:link>
                    </li>
                    <li>
                        Edici&oacute;n
                    </li>
                </ul>
            </div>
        </div>

        <div class="dialog" title="${titulo} del proyecto ${proyecto}">

            <g:if test="${flash.message}">
                <div class="message ui-state-highlight ui-corner-all">
                    <g:message code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/>
                </div>
            </g:if>
            <g:hasErrors bean="${entidadesProyectoInstance}">
                <div class="errors ui-state-error ui-corner-all">
                    <g:renderErrors bean="${entidadesProyectoInstance}" as="list"/>
                </div>
            </g:hasErrors>

            <div style="margin-top: 10px;">
                <div style="padding: 5px; margin-top: 5px; margin-bottom: 5px;" id="divError1"
                     class="ui-state-error ui-corner-all ui-helper-hidden">
                    <p>
                        <span style="float: left;" class="ui-icon ui-icon-alert"></span>
                        <span id="spanError1" style="font-weight: bold;"></span>
                    </p>
                </div>

                <a href="#" class="button agregar">Agregar</a>
                <a href="#" class="button delete">Eliminar</a>

                <div id="ajaxTabla" style="margin-top: 10px;"></div>

                <div id="dlg_nuevo${abr}" title="Nueva ${sing}">

                    <div style="padding: 5px; margin-top: 5px; margin-bottom: 5px;" id="divError"
                         class="ui-state-error ui-corner-all ui-helper-hidden">
                        <p>
                            <span style="float: left;" class="ui-icon ui-icon-alert"></span>
                            <span id="spanError" style="font-weight: bold;"></span>
                        </p>
                    </div>

                    <g:form action="save${may}" class="frm${may}"
                            method="post">
                        <g:hiddenField name="id" value="${entidadesProyectoInstance?.id}"/>
                        <g:hiddenField name="version" value="${entidadesProyectoInstance?.version}"/>

                        <table width="100%" class="ui-widget-content ui-corner-all">
                            <tbody>

                                <tr class="prop ${hasErrors(bean: entidadesProyectoInstance, field: 'entidad', 'error')}">

                                    <td class="label " valign="middle">
                                        <g:message code="entidadesProyecto.entidad.label" default="Entidad"/>
                                        %{----}%
                                    </td>
                                    <td class="indicator">
                                        &nbsp;
                                    </td>
                                    <td class="campo" valign="middle">
                                        <g:select class="field ui-widget-content ui-corner-all" name="unidad.id"
                                                  title="${EntidadesProyecto.constraints.unidad.attributes.mensaje}"
                                                  from="${yachay.parametros.UnidadEjecutora.list()}" optionKey="id"
                                                  noSelection="['null': '']"/>
                                        %{----}%
                                    </td>
                                </tr>

                                <tr class="prop ${hasErrors(bean: entidadesProyectoInstance, field: 'tipoPartisipacion', 'error')}">
                                    <td class="label " valign="middle">
                                        <g:message code="entidadesProyecto.tipoParticipacion.label"
                                                   default="Tipo de Participación"/>
                                        %{----}%
                                    </td>
                                    <td class="indicator">
                                        &nbsp;
                                    </td>
                                    <td class="campo" valign="middle">

                                        <g:select class="field ui-widget-content ui-corner-all"
                                                  name="tipoPartisipacion.id"
                                                  title="${EntidadesProyecto.constraints.tipoPartisipacion.attributes.mensaje}"
                                                  from="${yachay.parametros.TipoParticipacion.list()}"
                                                  optionKey="id" noSelection="['null': '']"/>

                                    </td>

                                </tr>

                                <tr class="prop ${hasErrors(bean: entidadesProyectoInstance, field: 'monto', 'error')}">
                                    <td class="label  mandatory" valign="middle">
                                        <g:message code="entidadesProyecto.monto.label" default="Monto"/>
                                        %{--<span class="indicator">*</span>--}%
                                    </td>
                                    <td class="indicator mandatory">
                                        <span class="indicator">*</span>
                                    </td>
                                    <td class="campo mandatory" valign="middle">
                                        <g:textField class="field required number ui-widget-content ui-corner-all"
                                                     name="monto"
                                                     title="${EntidadesProyecto.constraints.monto.attributes.mensaje}"
                                                     id="monto"/>
                                        %{--<span class="indicator">*</span>--}%
                                    </td>

                                </tr>



                                <tr class="prop ${hasErrors(bean: entidadesProyectoInstance, field: 'rol', 'error')}">

                                    <td class="label " valign="middle">
                                        <g:message code="entidadesProyecto.rol.label" default="Rol"/>
                                        %{----}%
                                    </td>
                                    <td class="indicator">
                                        &nbsp;
                                    </td>
                                    <td class="campo" valign="middle">
                                        <g:textArea class="field ui-widget-content ui-corner-all" minLenght="1"
                                                    maxLenght="1023"
                                                    name="rol" id="rol" cols="40" rows="5"
                                                    title="${EntidadesProyecto.constraints.rol.attributes.mensaje}"/>
                                        %{----}%
                                    </td>
                                <tr/>

                            </tbody>
                        </table>
                    </g:form>
                </div>
            </div>

        </div>

        <script type="text/javascript">
            $(function() {

                $("#breadCrumb").jBreadCrumb({
                    beginingElementsToLeaveOpen: 10
                });

                function reloadDatos() {
                    var url = "${createLink(controller: 'proyecto', action:'getDatos')}";
                    $.ajax({
                        type: "POST",
                        url: url,
                        data: "id=${proyecto.id}&tipo=${min}",
                        success: function(msg) {
                            $("#ajaxTabla").html(msg);
                        }
                    });
                }

                reloadDatos();

                var myForm = $(".frm${may}");

                $("#dlg_nuevo${abr}").dialog({
                    width: 400,
                    zIndex: 2000,
                    position: 'center',
                    resizable: false,
                    modal: true,
                    autoOpen: false,
                    open: function(event, ui) {
                        $("#spanError").text("");
                        $("#divError").hide();
                        $(this).find("input, textarea, select").val("");
                    },
                    buttons: {
                        "Cancelar": function() {
                            $(this).dialog("close");
                        },
                        "Guardar": function() {
                            var url = "${createLink(controller: 'proyecto', action:'save'+may)}";
                            var data = myForm.serialize();
                            data += "&proyecto.id=" +${proyecto.id};

                            $.ajax({
                                type: "POST",
                                url: url,
                                data: data,
                                success: function(msg) {
                                    if (msg == "OK") {
                                        $("#dlg_nuevo${abr}").dialog("close");
                                        reloadDatos();
                                    } else {
                                        $("#spanError").text("Ha ocurrido un error al guardar el ${sing}");
                                        $("#divError").show();
                                    }
                                }
                            });
                        }
                    }
                });

                // Tooltip de informacion para cada field (utiliza el atributo title del textfield)
                var elems = $('.field')
                        .each(function(i) {
                            $.attr(this, 'oldtitle', $.attr(this, 'title'));
                        })
                        .removeAttr('title');
                $('<div />').qtip(
                        {
                            content: ' ', // Can use any content here :)
                            position: {
                                target: 'event' // Use the triggering element as the positioning target
                            },
                            show: {
                                target: elems,
                                event: 'click mouseenter focus'
                            },
                            hide: {
                                target: elems,
                                delay : 0,
                                leave: false
                            },
                            events: {
                                show: function(event, api) {
                                    // Update the content of the tooltip on each show
                                    var target = $(event.originalEvent.target);
                                    api.set('content.text', target.attr('title'));
                                }
                            },
                            style: {
                                classes: 'ui-tooltip-rounded ui-tooltip-cream'
                            }
                        });
                // fin del codigo para los tooltips

                // Validacion del formulario
                myForm.validate({
                    errorClass: "errormessage",
                    onkeyup: false,
                    errorElement: "em",
                    errorClass: 'error',
                    validClass: 'valid',
                    errorPlacement: function(error, element) {
                        // Set positioning based on the elements position in the form
                        var elem = $(element),
                                corners = ['right center', 'left center'],
                                flipIt = elem.parents('span.right').length > 0;

                        // Check we have a valid error message
                        if (!error.is(':empty')) {
                            // Apply the tooltip only if it isn't valid
                            elem.filter(':not(.valid)').qtip({
                                overwrite: false,
                                content: error,
                                position: {
                                    my: corners[ flipIt ? 0 : 1 ],
                                    at: corners[ flipIt ? 1 : 0 ],
                                    viewport: $(window)
                                },
                                show: {
                                    event: false,
                                    ready:
                                            true
                                },
                                hide: false,
                                style: {
                                    classes: 'ui-tooltip-rounded ui-tooltip-red' // Make it red... the classic error colour!
                                }
                            })

                                // If we have a tooltip on this element already, just update its content
                                    .qtip('option', 'content.text', error);
                        }

                        // If the error is empty, remove the qTip
                        else {
                            elem.qtip('destroy');
                        }
                    },
                    success: $.noop // Odd workaround for errorPlacement not firing!
                })
                        ;
                //fin de la validacion del formulario


                $(".button").button();
                $(".agregar").button("option", "icons", {primary:'ui-icon-plusthick'}).click(function() {
                    $("#dlg_nuevo${abr}").dialog("open");
                    return false;
                });
                $(".delete").button("option", "icons", {primary:'ui-icon-trash'}).click(function() {
                    var del = $(".del:checked");
                    if (del.length > 0) {
                        if (confirm("Eliminar todas las ${titulo} marcadas?")) {
                            var url = "${createLink(controller: 'proyecto', action:'delete'+may)}";
                            var data = del.serialize();

                            $.ajax({
                                type: "POST",
                                url: url,
                                data: data,
                                success: function(msg) {
                                    if (msg == "NO") {
                                        $("#spanError1").text("Ha ocurrido un error al eliminar una o más ${titulo}");
                                        $("#divError1").show();
                                    }
                                    reloadDatos();
                                }
                            });
                        }
                    } else {
                        alert("Seleccione al menos un ${sing} para eliminar");
                    }
                    return false;
                });


            });
        </script>

    </body>
</html>