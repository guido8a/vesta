<%@ page import="yachay.proyectos.ResponsableProyecto" %>

<style type="text/css">
select.field {
    width : 235px;
}

.datepicker {
    width : 215px;
}
</style>


<div class="dialog">
    <g:if test="${flash.message}">
        <div class="message ui-state-highlight ui-corner-all">
            <g:message code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/>
        </div>
    </g:if>
    <g:hasErrors bean="${responsableIngreso}">
        <div class="errors ui-state-error ui-corner-all">
            <g:renderErrors bean="${responsableIngreso}" as="list"/>
        </div>
    </g:hasErrors>

    <g:set var="ingreso" value="${responsableIngreso?.id ? true: false}"/>
    <g:set var="ejecucion" value="${responsableEjecucion?.id ? true: false}"/>
    <g:set var="seguimiento" value="${responsableSeguimiento?.id ? true: false}"/>


    <g:form action="saveResponsable" class="frmResponsableProyecto" method="post" name="ejecucion">
        <g:hiddenField name="ejecucion.id" value="${responsableEjecucion?.id}"/>
        <g:hiddenField name="ejecucion.version" value="${responsableEjecucion?.version}"/>
        <g:hiddenField name="ejecucion.proyecto.id" value="${proyecto.id}"/>

        <g:hiddenField name="ejecucion.tipo" id="tipo_ejecucion" value="insert"/>

        <table width="100%" class="ui-widget-content ui-corner-all ${ejecucion ? 'ui-helper-hidden' : ''}"
               id="create_ejecucion">

            <thead>
                <tr>
                    <td width="430" colspan="5" class="ui-widget ui-widget-header ui-corner-left" style="padding: 3px;">
                        Responsable U.E. del proyecto
                    </td>
                    <td class="ui-widget ui-widget-header ui-corner-right">
                        <a href="#" tipo="ejecucion" class="btn save">Guardar</a>
                        <a href="#" tipo="ejecucion" class="btn cancel">Cancelar</a>
                    </td>
                </tr>
            </thead>

            <tbody>

                <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'responsable', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.responsable.label" default="Responsable"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <g:select class="field ui-widget-content ui-corner-all" name="ejecucion.responsable.id"
                                  title="${ResponsableProyecto.constraints.responsable.attributes.mensaje}"
                                  from="${responsablesEjecucion}" optionKey="id" noSelection="['null': '']"/>
                    </td>
                </tr>

                <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'desde', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.desde.label" default="Desde"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <input type="hidden" value="date.struct" name="ejecucion.desde2">
                        <input type="hidden" name="ejecucion.desde_day" id="desde2_day"
                               value="${responsableEjecucion?.desde?.format('dd')}">
                        <input type="hidden" name="ejecucion.desde_month" id="desde2_month"
                               value="${responsableEjecucion?.desde?.format('MM')}">
                        <input type="hidden" name="ejecucion.desde_year" id="desde2_year"
                               value="${responsableEjecucion?.desde?.format('yyyy')}">
                        <g:textField class="datepicker field ui-widget-content ui-corner-all" name="ejecucion.desde"
                                     title="${ResponsableProyecto.constraints.desde.attributes.mensaje}" id="desde2"/>
                    </td>

                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.hasta.label" default="Hasta"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <input type="hidden" value="date.struct" name="ejecucion.hasta2">
                        <input type="hidden" name="ejecucion.hasta_day" id="hasta2_day"
                               value="${responsableEjecucion?.hasta?.format('dd')}">
                        <input type="hidden" name="ejecucion.hasta_month" id="hasta2_month"
                               value="${responsableEjecucion?.hasta?.format('MM')}">
                        <input type="hidden" name="ejecucion.hasta_year" id="hasta2_year"
                               value="${responsableEjecucion?.hasta?.format('yyyy')}">
                        <g:textField class="datepicker field ui-widget-content ui-corner-all" name="ejecucion.hasta"
                                     title="${ResponsableProyecto.constraints.hasta.attributes.mensaje}" id="hasta2"/>
                    </td>
                </tr>

                <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'observaciones', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.observaciones.label" default="Observaciones"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle" colspan="4">
                        <g:textField name="ejecucion.observaciones" id="observaciones"
                                     title="${ResponsableProyecto.constraints.observaciones.attributes.mensaje}"
                                     style="width: 560px;"
                                     class="field ui-widget-content ui-corner-all" minLenght="1" maxLenght="127"/>
                    </td>
                </tr>

            </tbody>
        </table>
    </g:form>

    <table width="100%" class="ui-widget-content ui-corner-all ${!ejecucion ? 'ui-helper-hidden' : ''}"
           id="show_ejecucion">

        <thead>
            <tr>
                <td width="430" colspan="5" class="ui-widget ui-widget-header ui-corner-left" style="padding: 3px;">
                    Responsable U.E. del proyecto
                </td>
                <td class="ui-widget ui-widget-header ui-corner-right">
                    <a href="#" tipo="ejecucion" class="btn show">Reasignar</a>
                </td>
            </tr>
        </thead>

        <tbody>

            <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'responsable', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.responsable.label" default="Responsable"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableEjecucion?.responsable}
                </td>
            </tr>

            <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'desde', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.desde.label" default="Desde"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableEjecucion?.desde?.format('dd-MM-yyyy')}
                </td>

                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.hasta.label" default="Hasta"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableEjecucion?.hasta?.format('dd-MM-yyyy')}
                </td>
            </tr>

            <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'observaciones', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.observaciones.label" default="Observaciones"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle" colspan="4">
                    ${responsableEjecucion?.observaciones}
                </td>
            </tr>

        </tbody>
    </table>

    <br/>

    <g:form action="saveResponsable" class="frmResponsableProyecto" method="post" name="ingreso">
        <g:hiddenField name="ingreso.id" value="${responsableIngreso?.id}"/>
        <g:hiddenField name="ingreso.version" value="${responsableIngreso?.version}"/>
        <g:hiddenField name="ingreso.proyecto.id" value="${proyecto.id}"/>

        <g:hiddenField name="ingreso.tipo" id="tipo_ingreso" value="insert"/>

        <table width="100%" class="ui-widget-content ui-corner-all ${ingreso ? 'ui-helper-hidden' : ''}"
               id="create_ingreso">
            <thead>
                <tr>
                    <td width="430" colspan="5" class="ui-widget ui-widget-header ui-corner-left" style="padding: 3px;">
                        Responsable U.E./Ingreso de información
                    </td>
                    <td class="ui-widget ui-widget-header ui-corner-right">
                        <a href="#" tipo="ingreso" class="btn save">Guardar</a>
                        <a href="#" tipo="ingreso" class="btn cancel">Cancelar</a>
                    </td>
                </tr>
            </thead>

            <tbody>

                <tr class="prop ${hasErrors(bean: responsableIngreso, field: 'responsable', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.responsable.label" default="Responsable"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <g:select class="field ui-widget-content ui-corner-all" name="ingreso.responsable.id"
                                  title="${ResponsableProyecto.constraints.responsable.attributes.mensaje}"
                                  from="${responsablesIngreso}" optionKey="id" noSelection="['null': '']"/>
                    </td>
                </tr>

                <tr class="prop ${hasErrors(bean: responsableIngreso, field: 'desde', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.desde.label" default="Desde"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <input type="hidden" value="date.struct" name="ingreso.desde1"/>
                        <input type="hidden" name="ingreso.desde_day" id="desde_day"/>
                        <input type="hidden" name="ingreso.desde_month" id="desde_month"/>
                        <input type="hidden" name="ingreso.desde_year" id="desde_year"/>
                        <g:textField class="datepicker field ui-widget-content ui-corner-all" name="ingreso.desde"
                                     title="${ResponsableProyecto.constraints.desde.attributes.mensaje}" id="desde"/>
                    </td>

                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.hasta.label" default="Hasta"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <input type="hidden" value="date.struct" name="ingreso.hasta1"/>
                        <input type="hidden" name="ingreso.hasta_day" id="hasta_day"/>
                        <input type="hidden" name="ingreso.hasta_month" id="hasta_month"/>
                        <input type="hidden" name="ingreso.hasta_year" id="hasta_year"/>
                        <g:textField class="datepicker field ui-widget-content ui-corner-all" name="ingreso.hasta"
                                     title="${ResponsableProyecto.constraints.hasta.attributes.mensaje}" id="hasta"/>
                    </td>
                </tr>

                <tr class="prop ${hasErrors(bean: responsableIngreso, field: 'observaciones', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.observaciones.label" default="Observaciones"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle" colspan="4">
                        <g:textField name="ingreso.observaciones" id="observaciones"
                                     title="${ResponsableProyecto.constraints.observaciones.attributes.mensaje}"
                                     style="width: 560px;" class="field ui-widget-content ui-corner-all" minLenght="1"
                                     maxLenght="127"/>
                    </td>
                </tr>
            </tbody>
        </table>
    </g:form>

    <table width="100%" class="ui-widget-content ui-corner-all ${!ingreso ? 'ui-helper-hidden' : ''}" id="show_ingreso">

        <thead>
            <tr>
                <td width="430" colspan="5" class="ui-widget ui-widget-header ui-corner-left" style="padding: 3px;">
                    Responsable de U.E./Ingreso de información
                </td>
                <td class="ui-widget ui-widget-header ui-corner-right">
                    <a href="#" tipo="ingreso" class="btn show">Reasignar</a>
                </td>
            </tr>
        </thead>

        <tbody>

            <tr class="prop ${hasErrors(bean: responsableIngreso, field: 'responsable', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.responsable.label" default="Responsable"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableIngreso?.responsable}
                </td>
            </tr>

            <tr class="prop ${hasErrors(bean: responsableIngreso, field: 'desde', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.desde.label" default="Desde"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableIngreso?.desde?.format('dd-MM-yyyy')}
                </td>

                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.hasta.label" default="Hasta"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableIngreso?.hasta?.format('dd-MM-yyyy')}
                </td>
            </tr>

            <tr class="prop ${hasErrors(bean: responsableIngreso, field: 'observaciones', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.observaciones.label" default="Observaciones"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle" colspan="4">
                    ${responsableIngreso?.observaciones}
                </td>
            </tr>

        </tbody>
    </table>

    <br/>

    <g:form action="saveResponsable" class="frmResponsableProyecto" method="post" name="seguimiento">
        <g:hiddenField name="seguimiento.id" value="${responsableSeguimiento?.id}"/>
        <g:hiddenField name="seguimiento.version" value="${responsableSeguimiento?.version}"/>
        <g:hiddenField name="seguimiento.proyecto.id" value="${proyecto.id}"/>

        <g:hiddenField name="seguimiento.tipo" id="tipo_seguimiento" value="insert"/>

        <table width="100%" class="ui-widget-content ui-corner-all ${seguimiento ? 'ui-helper-hidden' : ''}"
               id="create_seguimiento">

            <thead>
                <tr>
                    <td width="430" colspan="5" class="ui-widget ui-widget-header ui-corner-left" style="padding: 3px;">
                        Responsable Seguimiento
                    </td>
                    <td class="ui-widget ui-widget-header ui-corner-right">
                        <a href="#" tipo="seguimiento" class="btn save">Guardar</a>
                        <a href="#" tipo="seguimiento" class="btn cancel">Cancelar</a>
                    </td>
                </tr>
            </thead>

            <tbody>

                <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'responsable', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.responsable.label" default="Responsable"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <g:select class="field ui-widget-content ui-corner-all" name="seguimiento.responsable.id"
                                  title="${ResponsableProyecto.constraints.responsable.attributes.mensaje}"
                                  from="${responsablesSeguimiento}" optionKey="id" noSelection="['null': '']"/>
                    </td>
                </tr>

                <tr class="prop ${hasErrors(bean: responsableSeguimiento, field: 'desde', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.desde.label" default="Desde"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <input type="hidden" value="date.struct" name="seguimiento.desde3">
                        <input type="hidden" name="seguimiento.desde_day" id="desde3_day"
                               value="${responsableSeguimiento?.desde?.format('dd')}">
                        <input type="hidden" name="seguimiento.desde_month" id="desde3_month"
                               value="${responsableSeguimiento?.desde?.format('MM')}">
                        <input type="hidden" name="seguimiento.desde_year" id="desde3_year"
                               value="${responsableSeguimiento?.desde?.format('yyyy')}">
                        <g:textField class="datepicker field ui-widget-content ui-corner-all" name="seguimiento.desde"
                                     title="${ResponsableProyecto.constraints.desde.attributes.mensaje}" id="desde3"/>
                    </td>

                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.hasta.label" default="Hasta"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle">
                        <input type="hidden" value="date.struct" name="seguimiento.hasta3">
                        <input type="hidden" name="seguimiento.hasta_day" id="hasta3_day"
                               value="${responsableSeguimiento?.hasta?.format('dd')}">
                        <input type="hidden" name="seguimiento.hasta_month" id="hasta3_month"
                               value="${responsableSeguimiento?.hasta?.format('MM')}">
                        <input type="hidden" name="seguimiento.hasta_year" id="hasta3_year"
                               value="${responsableSeguimiento?.hasta?.format('yyyy')}">
                        <g:textField class="datepicker field ui-widget-content ui-corner-all" name="seguimiento.hasta"
                                     title="${ResponsableProyecto.constraints.hasta.attributes.mensaje}" id="hasta3"/>
                    </td>
                </tr>

                <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'observaciones', 'error')}">
                    <td class="label " valign="middle">
                        <g:message code="responsableProyecto.observaciones.label" default="Observaciones"/>
                    </td>
                    <td class="indicator">
                        &nbsp;
                    </td>
                    <td class="" valign="middle" colspan="4">
                        <g:textField name="seguimiento.observaciones" id="observaciones"
                                     title="${ResponsableProyecto.constraints.observaciones.attributes.mensaje}"
                                     style="width: 560px;"
                                     class="field ui-widget-content ui-corner-all" minLenght="1" maxLenght="127"/>
                    </td>
                </tr>

            </tbody>
        </table>
    </g:form>

    <table width="100%" class="ui-widget-content ui-corner-all ${!seguimiento ? 'ui-helper-hidden' : ''}"
           id="show_seguimiento">

        <thead>
            <tr>
                <td width="430" colspan="5" class="ui-widget ui-widget-header ui-corner-left" style="padding: 3px;">
                    Responsable Seguimiento
                </td>
                <td class="ui-widget ui-widget-header ui-corner-right">
                    <a href="#" tipo="seguimiento" class="btn show">Reasignar</a>
                </td>
            </tr>
        </thead>

        <tbody>

            <tr class="prop ${hasErrors(bean: responsableEjecucion, field: 'responsable', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableSeguimiento.responsable.label" default="Responsable"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableSeguimiento?.responsable}
                </td>
            </tr>

            <tr class="prop ${hasErrors(bean: responsableSeguimiento, field: 'desde', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.desde.label" default="Desde"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableSeguimiento?.desde?.format('dd-MM-yyyy')}
                </td>

                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.hasta.label" default="Hasta"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle">
                    ${responsableSeguimiento?.hasta?.format('dd-MM-yyyy')}
                </td>
            </tr>

            <tr class="prop ${hasErrors(bean: responsableSeguimiento, field: 'observaciones', 'error')}">
                <td class="label " valign="middle">
                    <g:message code="responsableProyecto.observaciones.label" default="Observaciones"/>
                </td>
                <td class="indicator">
                    &nbsp;
                </td>
                <td class="" valign="middle" colspan="4">
                    ${responsableSeguimiento?.observaciones}
                </td>
            </tr>

        </tbody>
    </table>

</div>

<script type="text/javascript">
    $(function () {

        $(".show").button({
            icons:{
                primary:"ui-icon-shuffle"
            }
        }).click(function () {
                    var tipo = $(this).attr("tipo");
                    $("#show_" + tipo).hide();
                    $("#create_" + tipo).show();

                    $("#tipo_" + tipo).val("update");

                    return false;
                });

        $(".cancel").button({
            icons:{
                primary:"ui-icon-close"
            }
        }).click(function () {
                    var tipo = $(this).attr("tipo");
                    $("#create_" + tipo).hide();
                    $("#show_" + tipo).show();

                    $("#tipo_" + tipo).val("insert");

                    return false;
                });

        $(".save").button({
            icons:{
                primary:"ui-icon-disk"
            }
        }).click(function () {
                    var tipo = $(this).attr("tipo");

                    var form = $("[name=" + tipo + "]");
                    var data = form.serialize();

                    var url = form.attr("action");
                    var href = "${createLink(action: 'responsable', id: proyecto.id)}";

                    $.ajax({
                        type:"POST",
                        url:url,
                        data:data,
                        success:function (msg) {
                            if (msg == "OK") {
                                $("#actuales").load(href);
                            }
                        }
                    });
                    return false;
                });

        $('#desde').datepicker({
            changeMonth:true,
            changeYear:true,
            dateFormat:'dd-mm-yy',
            minDate:new Date("${responsableIngreso?.desde?.format('yyyy')}", "${responsableIngreso?.desde?.format('MM') ? responsableIngreso?.desde?.format('MM').toInteger() - 1 : 0}", "${responsableIngreso?.desde?.format('dd')}").add(1).days(),
            onClose:function (dateText, inst) {
                var date = $(this).datepicker('getDate');
                var day, month, year;
                if (date != null) {
                    day = date.getDate();
                    month = parseInt(date.getMonth()) + 1;
                    year = date.getFullYear();
                } else {
                    day = '';
                    month = '';
                    year = '';
                }
                var id = $(this).attr('id');
                $('#' + id + '_day').val(day);
                $('#' + id + '_month').val(month);
                $('#' + id + '_year').val(year);

                $("#hasta").datepicker("option", "minDate", date.add(1).days());
            }
        });

        $('#hasta').datepicker({
            changeMonth:true,
            changeYear:true,
            dateFormat:'dd-mm-yy',
            minDate:new Date("${responsableIngreso?.desde?.format('yyyy')}", "${responsableIngreso?.desde?.format('MM') ? responsableIngreso?.desde?.format('MM').toInteger() - 1 : 0}", "${responsableIngreso?.desde?.format('dd')}").add(2).days(),
            onClose:function (dateText, inst) {
                var date = $(this).datepicker('getDate');
                var day, month, year;
                if (date != null) {
                    day = date.getDate();
                    month = parseInt(date.getMonth()) + 1;
                    year = date.getFullYear();
                } else {
                    day = '';
                    month = '';
                    year = '';
                }
                var id = $(this).attr('id');
                $('#' + id + '_day').val(day);
                $('#' + id + '_month').val(month);
                $('#' + id + '_year').val(year);
            }
        });

        $('#desde2').datepicker({
            changeMonth:true,
            changeYear:true,
            dateFormat:'dd-mm-yy',
            minDate:new Date("${responsableEjecucion?.desde?.format('yyyy')}", "${responsableEjecucion?.desde?.format('MM')?responsableEjecucion?.desde?.format('MM').toInteger() - 1:0}", "${responsableEjecucion?.desde?.format('dd')}").add(1).days(),
            onClose:function (dateText, inst) {
                var date = $(this).datepicker('getDate');
                var day, month, year;
                if (date != null) {
                    day = date.getDate();
                    month = parseInt(date.getMonth()) + 1;
                    year = date.getFullYear();
                } else {
                    day = '';
                    month = '';
                    year = '';
                }
                var id = $(this).attr('id');
                $('#' + id + '_day').val(day);
                $('#' + id + '_month').val(month);
                $('#' + id + '_year').val(year);

                $("#hasta2").datepicker("option", "minDate", date.add(1).days());
            }
        });

        $('#hasta2').datepicker({
            changeMonth:true,
            changeYear:true,
            dateFormat:'dd-mm-yy',
            minDate:new Date("${responsableEjecucion?.desde?.format('yyyy')}", "${responsableEjecucion?.desde?.format('MM')?responsableEjecucion?.desde?.format('MM').toInteger() - 1:0}", "${responsableEjecucion?.desde?.format('dd')}").add(2).days(),
            onClose:function (dateText, inst) {
                var date = $(this).datepicker('getDate');
                var day, month, year;
                if (date != null) {
                    day = date.getDate();
                    month = parseInt(date.getMonth()) + 1;
                    year = date.getFullYear();
                } else {
                    day = '';
                    month = '';
                    year = '';
                }
                var id = $(this).attr('id');
                $('#' + id + '_day').val(day);
                $('#' + id + '_month').val(month);
                $('#' + id + '_year').val(year);
            }
        });

        $('#desde3').datepicker({
            changeMonth:true,
            changeYear:true,
            dateFormat:'dd-mm-yy',
            minDate:new Date("${responsableSeguimiento?.desde?.format('yyyy')}", "${responsableSeguimiento?.desde?.format('MM')?responsableSeguimiento?.desde?.format('MM').toInteger() - 1:0}", "${responsableSeguimiento?.desde?.format('dd')}").add(1).days(),
            onClose:function (dateText, inst) {
                var date = $(this).datepicker('getDate');
                var day, month, year;
                if (date != null) {
                    day = date.getDate();
                    month = parseInt(date.getMonth()) + 1;
                    year = date.getFullYear();
                } else {
                    day = '';
                    month = '';
                    year = '';
                }
                var id = $(this).attr('id');
                $('#' + id + '_day').val(day);
                $('#' + id + '_month').val(month);
                $('#' + id + '_year').val(year);

                $("#hasta2").datepicker("option", "minDate", date.add(1).days());
            }
        });

        $('#hasta3').datepicker({
            changeMonth:true,
            changeYear:true,
            dateFormat:'dd-mm-yy',
            minDate:new Date("${responsableSeguimiento?.desde?.format('yyyy')}", "${responsableSeguimiento?.desde?.format('MM')?responsableSeguimiento?.desde?.format('MM').toInteger() - 1:0}", "${responsableSeguimiento?.desde?.format('dd')}").add(2).days(),
            onClose:function (dateText, inst) {
                var date = $(this).datepicker('getDate');
                var day, month, year;
                if (date != null) {
                    day = date.getDate();
                    month = parseInt(date.getMonth()) + 1;
                    year = date.getFullYear();
                } else {
                    day = '';
                    month = '';
                    year = '';
                }
                var id = $(this).attr('id');
                $('#' + id + '_day').val(day);
                $('#' + id + '_month').val(month);
                $('#' + id + '_year').val(year);
            }
        });

        var myForm = $(".frmResponsableProyecto");

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
    });
</script>