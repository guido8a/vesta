<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/21/11
  Time: 12:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="yachay.proyectos.EntidadesProyecto; yachay.proyectos.EstudiosTecnicos; yachay.proyectos.BeneficioSenplades; yachay.proyectos.IndicadoresSenplades; yachay.proyectos.Proyecto" %>
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

        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.cookie.js')}"></script>

        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins/qtip', file: 'jquery.qtip.min.js')}"></script>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/qtip', file: 'jquery.qtip.css')}"/>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'Base.css')}"
              type="text/css"/>
        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'BreadCrumb.css')}"
              type="text/css"/>

        <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.easing.1.3.js')}" type="text/javascript"
                language="JavaScript"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jBreadCrumb/js', file: 'jquery.jBreadCrumb.1.1.js')}"
                type="text/javascript" language="JavaScript"></script>

        <title>Datos Senplades</title>

        <style type="text/css">
        .number2 {
            width : 55px;
        }
        </style>

    </head>

    <body>

    <div class="dialog">

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
                        <g:link class="bc" controller="proyecto" action="verIndicadoresSenplades"
                                id="${proyecto.id}">
                            Indicadores Senplades
                        </g:link>
                    </li>

                    <li>
                        Edici&oacute;n
                    </li>
                </ul>
            </div>
        </div>

        <div id="" class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 5px;">
            <a href="#" class="button save" id="${proyecto.id}">
                Guardar
            </a>
        </div> <!-- toolbar -->

        <g:form name="frmSenplades" class="frmSenplades" action="saveIndicadoresSenplades">
            <table width="100%" class="ui-widget-content ui-corner-all">
                <tbody>
                    <tr class="prop ">
                        <td class="label  mandatory" valign="middle">
                            Tasa de An&aacute;lisis
                        </td>

                        <td class="mandatory" valign="middle">
                            <g:textField name="tasaAnalisisFinanciero" class="field number2 ui-widget-content ui-corner-all" id="tan" title="${IndicadoresSenplades.constraints.tasaAnalisisFinanciero.attributes.mensaje}"
                                         value="${g.formatNumber(number: indicadores.indicadoresSempladesInstance?.tasaAnalisisFinanciero, minFractionDigits:2, maxFractionDigist:2, format:'###,##0')}"
                                         max2="100"/>
                            %
                        </td>

                        <td class="label  mandatory" valign="middle">
                            Valor Actual Neto
                        </td>

                        <td class="mandatory" valign="middle">
                            <g:textField name="valorActualNeto" class="field number2 ui-widget-content ui-corner-all" id="van" title="${IndicadoresSenplades.constraints.valorActualNeto.attributes.mensaje}"
                                         value="${g.formatNumber(number: indicadores.indicadoresSempladesInstance?.valorActualNeto, minFractionDigits:2, maxFractionDigist:2, format:'###,##0')}" style="width: 140px;"/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td class="label  mandatory" valign="middle">
                            Tasa Interna de Retorno
                        </td>

                        <td class="mandatory" valign="middle">
                            <g:textField name="tasaInternaDeRetorno" class="field number2 ui-widget-content ui-corner-all" id="tir" title="${IndicadoresSenplades.constraints.tasaInternaDeRetorno.attributes.mensaje}"
                                         value="${g.formatNumber(number: indicadores.indicadoresSempladesInstance?.tasaInternaDeRetorno, minFractionDigits:2, maxFractionDigist:2, format:'###,##0')}"
                                         max2="100"/>
                            %
                        </td>

                        <td class="label " valign="middle">
                            Metodolog&iacute;a de c&aacute;lculo
                        </td>

                        <td valign="middle">
                            <g:textField name="metodologia" class="field  ui-widget-content ui-corner-all" id="met" title="${IndicadoresSenplades.constraints.metodologia.attributes.mensaje}"
                                         value="${indicadores.indicadoresSempladesInstance?.metodologia}"/>
                        </td>
                    </tr>

                    <tr class="prop ">

                        <td class="label  mandatory" valign="middle">
                            Costo Beneficio
                        </td>

                        <td class="mandatory" valign="middle">
                            <g:textField name="costoBeneficio" class="field number2 ui-widget-content ui-corner-all" id="cob" title="${IndicadoresSenplades.constraints.costoBeneficio.attributes.mensaje}"
                                         value="${g.formatNumber(number: indicadores.indicadoresSempladesInstance?.costoBeneficio, minFractionDigits:2, maxFractionDigist:2, format:'###,##0')}"
                                         style="width: 140px;" max2="999"/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td class="label " valign="middle">
                            Indicadores de resultado
                        </td>

                        <td valign="middle" colspan="3">
                            <g:textArea cols="5" rows="5" name="impactos" id="imp" class="field  ui-widget-content ui-corner-all" title="${IndicadoresSenplades.constraints.impactos.attributes.mensaje}"
                                        value="${indicadores.indicadoresSempladesInstance?.impactos}" style="width: 680px;"/>
                        </td>
                    </tr>

                </tbody>
            </table>
            </div>

        </g:form>

        <script type="text/javascript">
            $(function () {

                var myForm = $(".frmSenplades");

                $(".number").keypress(function (evt) {
                    var charCodes = [
                        46, 44, //. ,
                        48, 49, 50, 51, 52, 53, 54, 55, 56, 57, //0-9
                        96, 97, 98, 99, 100, 101, 102, 103, 104, 105    //0-9
                    ];
                    var keyCodes = [
                        8,
                        9,
                        13,
                        46
                    ];

                    if ($.inArray(evt.charCode, charCodes) != -1 || $.inArray(evt.keyCode, keyCodes) != -1) {
                        /* remplaza los puntos por comas */
                        if (evt.charCode == 46 || evt.charCode == 44) {
                            var v = $(this).val();
                            v += ",";
                            $(this).val(v);
                            return false;
                        }
                        /**
                         * TODO:
                         *     validar q no haya mas de 1 ','
                         *     agregar el '.' cada 3 digitos
                         */
                        return true;
                    } else {
                        return false;
                    }
                });


                // Tooltip de informacion para cada field (utiliza el atributo title del textfield)
                var elems = $('.field')
                        .each(function (i) {
                            $.attr(this, 'oldtitle', $.attr(this, 'title'));
                        })
                        .removeAttr('title');
                $('<div />').qtip(
                        {
                            content:' ', // Can use any content here :)
                            position:{
                                target:'event' // Use the triggering element as the positioning target
                            },
                            show:{
                                target:elems,
                                event:'click mouseenter focus'
                            },
                            hide:{
                                target:elems,
                                delay:0,
                                leave:false
                            },
                            events:{
                                show:function (event, api) {
                                    // Update the content of the tooltip on each show
                                    var target = $(event.originalEvent.target);
                                    api.set('content.text', target.attr('title'));
                                }
                            },
                            style:{
                                classes:'ui-tooltip-rounded ui-tooltip-cream'
                            }
                        });
                // fin del codigo para los tooltips

                // Validacion del formulario
                myForm.validate({
                    errorClass:"errormessage",
                    onkeyup:false,
                    errorElement:"em",
                    errorClass:'error',
                    validClass:'valid',
                    errorPlacement:function (error, element) {
                        // Set positioning based on the elements position in the form
                        var elem = $(element),
                                corners = ['right center', 'left center'],
                                flipIt = elem.parents('span.right').length > 0;

                        // Check we have a valid error message
                        if (!error.is(':empty')) {
                            // Apply the tooltip only if it isn't valid
                            elem.filter(':not(.valid)').qtip({
                                overwrite:false,
                                content:error,
                                position:{
                                    my:corners[ flipIt ? 0 : 1 ],
                                    at:corners[ flipIt ? 1 : 0 ],
                                    viewport:$(window)
                                },
                                show:{
                                    event:false,
                                    ready:true
                                },
                                hide:false,
                                style:{
                                    classes:'ui-tooltip-rounded ui-tooltip-red' // Make it red... the classic error colour!
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
                    success:$.noop // Odd workaround for errorPlacement not firing!
                })
                ;
                //fin de la validacion del formulario

                $("#breadCrumb").jBreadCrumb({
                    beginingElementsToLeaveOpen:10
                });
                $(".button").button();
                $(".save").button("option", "icons", {primary:'ui-icon-disk'}).click(function () {
                    if (myForm.valid()) {
                        var tan = $("#tan").val();
                        var tir = $("#tir").val();
                        var cob = $("#cob").val();
                        var van = $("#van").val();

                        var met = $("#met").val();
                        var imp = $("#imp").val();

                        tan = str_replace(".", "", tan);
                        tir = str_replace(".", "", tir);
                        cob = str_replace(".", "", cob);
                        van = str_replace(".", "", van);

                        tan = str_replace(",", ".", tan);
                        tir = str_replace(",", ".", tir);
                        cob = str_replace(",", ".", cob);
                        van = str_replace(",", ".", van);

                        var url = "${createLink(action: 'saveIndicadoresSenplades')}?id=${proyecto.id}&tan=" + tan + "&tir=" + tir + "&cob=" + cob + "&van=" + van + "&met=" + met + "&imp=" + imp;

                        //console.log(url);

                        location.href = url;
                    }
                    return false;
                });
            });
        </script>

    </body>
</html>
