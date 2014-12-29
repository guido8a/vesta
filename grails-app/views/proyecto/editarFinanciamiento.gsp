<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/21/11
  Time: 11:32 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="yachay.parametros.poaPac.Anio; yachay.parametros.poaPac.Fuente" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>

        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins', file: 'jquery.meio.mask.js')}"></script>

        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.cookie.js')}"></script>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'Base.css')}"
              type="text/css"/>
        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'BreadCrumb.css')}"
              type="text/css"/>

        <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.easing.1.3.js')}" type="text/javascript"
                language="JavaScript"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jBreadCrumb/js', file: 'jquery.jBreadCrumb.1.1.js')}"
                type="text/javascript" language="JavaScript"></script>

        <title>Editar Presupuesto/Fuentes</title>
    </head>

    <body>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div style="padding: 0.7em; margin: 0.7em;" class="ui-state-error ui-corner-all ui-helper-hidden"
             id="divError">
            <p>
                <span style="float: left; margin-right: .3em;" class="ui-icon ui-icon-alert"></span>
                <strong>Error:</strong>
                <span id="spanError"></span>
            </p>
        </div>

        <div class="ui-widget-content ui-corner-all" style="padding: 3px;">

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
                            <g:link class="bc" action="verFinanciamiento" id="${proyecto.id}">
                                Presupuesto/Fuentes
                            </g:link>
                        </li>

                        <li>
                            Edici&oacute;n
                        </li>
                    </ul>
                </div>
            </div>

            <div style="display: inline; margin-left: 5px;">
                <strong>
                    Fuente:
                </strong>
                <g:select from="${Fuente.list()}" name="fuente" id="fuente" optionKey="id"
                          optionValue="descripcion"/>
            </div>

            <div style="display: inline; margin-left: 5px;">
                <strong>
                    Monto:
                </strong>
                <g:textField name="monto" id="monto" autocomplete="off" alt="decimal"/>
            </div>

            <div style="display: inline; margin-left: 5px;">
                <strong>
                    A&ntilde;o:
                </strong>
                <g:select name="anio" id="anio" from="${Anio.list([sort:'anio', order:'asc'])}" optionKey="id"
                          optionValue="anio" value="${Anio.findByAnio(new Date().format('yyyy')).id}"/>
            </div>

            <a href="#" id="btnAdd" class="button">Agregar</a>
        </div>


        <div class="ui-widget-content ui-corner-all" style="padding: 10px;">

            <div style="padding: 15px;">
                <strong>Total del proyecto:</strong> <g:formatNumber number="${proyecto.monto.toDouble()}"
                                                                     format="###,##0"
                                                                     minFractionDigits="2" maxFractionDigits="2"/>
            </div>

            <g:form class="frmFinanciamiento" method="post" action="saveFinanciamiento">
                <input type="hidden" name="deleted" id="deleted"/>

                <input type="hidden" name="id" id="id" value="${proyecto.id}"/>
                <table id="tblFinanciamiento">
                    <thead>
                        <tr style="padding: 5px;">
                            <th style="padding: 5px;" class="ui-widget-header ui-corner-tl" width="320px;">
                                Fuente
                            </th>
                            <th style="padding: 5px;" class="ui-widget-header" width="120px;">
                                Monto
                            </th>
                            <th style="padding: 5px;" class="ui-widget-header" width="120px;">
                                Porcentaje
                            </th>
                            <th style="padding: 5px;" class="ui-widget-header" width="80px;">
                                A&ntilde;o
                            </th>
                            <th style="padding: 5px;" class="ui-widget-header ui-corner-tr" width="100px;">
                                Eliminar
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:set var="suma" value="${0}"/>
                        <g:set var="prct" value="${0}"/>
                        <g:each in="${financiamientos}" status="i" var="fin">
                            <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                                <td fuente="${fin.fuente.id}" tipo="descripcion">
                                    ${fin.fuente.descripcion}
                                </td>

                                <td style="text-align: right;" fuente="${fin.fuente.id}" tipo="monto">

                                    <g:formatNumber number="${fin.monto}" format="###,##0"
                                                    minFractionDigits="2" maxFractionDigits="2"/>

                                    <g:set var="suma" value="${suma + fin.monto}"/>
                                </td>

                                <td style="text-align: right;" fuente="${fin.fuente.id}" tipo="porcentaje">

                                    <g:set var="finPorcentaje" value="${(fin.monto * 100) / proyecto.monto}"/>
                                    <g:formatNumber number="${finPorcentaje/100}" type="percent"
                                                    minFractionDigits="2"
                                                    maxFractionDigits="2"/>

                                    <g:set var="prct" value="${prct+ finPorcentaje}"/>
                                </td>

                                <td>
                                    ${fin.anio?.anio}
                                </td>

                                <td style="text-align: center;" fuente="${fin.fuente.id}">
                                    <a href="#" class="button del elim" id="fnm_${fin.id}">Eliminar</a>
                                </td>
                            </tr>
                        </g:each>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th class="ui-state-active ui-corner-bl" style="font-weight: bold;">
                                TOTAL
                            </th>
                            <th class="ui-state-active" style="text-align: right; font-weight: bold;">
                                <span id="spanSuma">
                                    <g:formatNumber number="${suma}" format="###,##0"
                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                            </th>
                            <th class="ui-state-active" style="text-align: right; font-weight: bold;">
                                <span id="spanPrct">
                                    <g:formatNumber number="${prct/100}" type="percent" minFractionDigits="2"
                                                    maxFractionDigits="2"/>
                                </span>
                            </th>
                            <th class="ui-state-active"></th>
                            <th class="ui-state-active ui-corner-br">&nbsp;</th>
                        </tr>
                    </tfoot>
                </table>

                <div style="padding: 15px;">
                    <strong>Restante:</strong>
                    <span id="spanRestante">
                        <g:formatNumber number="${proyecto.monto.toDouble() - suma}"
                                        format="###,##0"
                                        minFractionDigits="2" maxFractionDigits="2"/>
                    </span>
                </div>
            </g:form>

            <br/>

            <div class="botones">
                <div class="botones right">
                    <a href="#" class="button save">
                        Guardar
                    </a>
                </div>
            </div>
        </div>


        <div id="dialog-confirm" sid="" title="¿Eliminar?">
            <p>
                <span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>
                ¿Est&aacute; seguro de querer eliminar este financiamiento?
            </p>
        </div>


        <script type="text/javascript">

            $("#deleted").val("");

            $(function () {

//                $('#monto').setMask();

                $("#breadCrumb").jBreadCrumb({
                    beginingElementsToLeaveOpen:10
                });

                $("#dialog-confirm").dialog({
                    resizable:false,
                    height:160,
                    modal:true,
                    autoOpen:false,
                    buttons:{
                        "Sí, Eliminar":function () {
                            deleteRow($("#dialog-confirm").attr("sid"));
                            $(this).dialog("close");
                        },
                        "No, Cancelar":function () {
                            $(this).dialog("close");
                        }
                    }
                });

                var montoTotal = ${proyecto.monto};
                var suma = ${suma};
                var prct = ${prct};
                var total = montoTotal - suma;

                $("#monto").keypress(function (evt) {
                    switch (evt.keyCode) {
                        case 38:
                            var sel = $("#fuente option:selected").index();
                            sel++;
                            if (sel >= $('#fuente option').length) {
                                sel = 0;
                            }
                            $('#fuente option').eq(sel).attr('selected', 'selected')
                            break;
                        case 40:
                            var sel = $("#fuente option:selected").index();
                            sel--;
                            if (sel < 0) {
                                sel = $('#fuente option').length - 1;
                            }
                            $('#fuente option').eq(sel).attr('selected', 'selected')
                            break;
                        case 13:
                            addRow();
                            break;
                    }
                });

                function addRow() {
                    var err = false;

                    var id = $("#fuente").val();
                    var fuente = $("#fuente option:selected").text();
                    var anioId = $("#anio").val();
                    var anioText = $("#anio option:selected").text();

                    $("#tblFinanciamiento tbody tr").each(function () {
                        if (trim($(this).children().first().text()) == trim(fuente) && trim($(this).children().eq(3).text()) == trim(anioText)) {
                            $("#spanError").text("Seleccione una fuente diferente a las ya seleccionadas");
                            $("#divError").show();
                            err = true;
                            return false;
                        }
                    });

                    var monto = $("#monto").val();
                    var mn = monto;
//                    //console.log(monto);
                    monto = str_replace(".", "", monto);
                    monto = str_replace(",", ".", monto);
//                    //console.log(monto);
                    monto *= 1;
//                    //console.log(monto);

                    total = montoTotal - suma;

                    if (monto <= 0) {
                        $("#spanError").text("Ingrese un valor mayor a 0");
                        $("#divError").show();
                        err = true;
                        return false;
                    }
                    if (monto > montoTotal) {
                        $("#spanError").text("Ingrese un valor igual o menor a " + number_format(montoTotal, 2, ',', '.'));
                        $("#divError").show();
                        err = true;
                        return false;
                    }
                    if (monto + suma > montoTotal) {
                        $("#spanError").text("Ingrese un valor igual o menor a " + number_format(total, 2, ',', '.'));
                        $("#divError").show();
                        err = true;
                        return false;
                    }

                    if (!err) {
                        $("#divError").hide();

                        var pct = (monto * 100) / montoTotal;

                        var inp = "<input type='hidden' name='mnt_" + id + "_" + anioId + "' value='" + monto + "' />"

                        var tr = $("<tr style='border: solid 1px #285589;'>");
                        var tdF = $("<td style='border-bottom: solid 1px #285589;'>" + fuente + "</td>");
                        var tdM = $("<td style='border-bottom: solid 1px #285589; text-align: right;'>" + number_format(monto, 2, ',', '.') + inp + " </td>");
                        var tdP = $("<td style='border-bottom: solid 1px #285589; text-align: right;'>" + number_format(pct, 2, ',', '.') + "%</td>");
                        var tdA = $("<td style='border-bottom: solid 1px #285589;'>" + anioText + "</td>");
                        var tdD = $("<td style='border-bottom: solid 1px #285589; text-align: center;'>");

                        var btnDel = $("<a href='#' class='button del' id='fnm_'" + id + ">Eliminar</a>");

                        btnDel.button({
                            icons:{
                                primary:"ui-icon-trash"
                            },
                            text:false
                        }).click(function () {
                                    suma -= monto;
                                    prct -= pct;
                                    $("#spanSuma").text(number_format(suma, 2, ',', '.'));
                                    $("#spanPrct").text(number_format(prct, 2, ',', '.') + "%");
                                    $("#spanRestante").text(number_format(montoTotal - suma, 2, ',', '.'));
                                    $(this).parent().parent().remove();
                                });

                        tdD.append(btnDel);

                        tr.append(tdF);
                        tr.append(tdM);
                        tr.append(tdP);
                        tr.append(tdA);
                        tr.append(tdD);

                        suma += monto;
                        prct += pct;

                        $("#tblFinanciamiento tbody").prepend(tr);
                        $("#spanSuma").text(number_format(suma, 2, ',', '.'));
                        $("#spanPrct").text(number_format(prct, 2, ',', '.') + "%");

                        $("#spanRestante").text(number_format(montoTotal - suma, 2, ',', '.'));

                        $("#monto").val("");
                    }
                }

                function deleteRow(sid) {

                    var obj = $("#" + sid);

                    var monto = obj.parent().siblings("[tipo=monto]").text();
                    var pct = obj.parent().siblings("[tipo=porcentaje]").text();

                    monto = str_replace('.', '', monto);
                    monto = str_replace(',', '.', monto);
                    pct = str_replace(',', '.', pct);
                    pct = str_replace('%', '', pct);

                    monto = parseFloat(monto);
                    pct = parseFloat(pct);

                    suma -= monto;
                    prct -= pct;

                    $("#spanSuma").text(number_format(suma, 2, ',', '.'));
                    $("#spanPrct").text(number_format(prct, 2, ',', '.') + "%");
                    $("#spanRestante").text(number_format(montoTotal - suma, 2, ',', '.'));
                    obj.parent().parent().remove();

//            var sid = $(this).attr("id");
                    var parts = sid.split("_");
                    var id = parts[1];

                    var del = $("#deleted").val();
                    if (trim(del) == "") {
                        del = "" + id;
                    } else {
                        del += "," + id;
                    }
                    $("#deleted").val(del);
                }

                $("#btnAdd").button({
                    icons:{
                        primary:'ui-icon-plusthick'
                    },
                    text:false
                }).click(function () {
                            addRow();
                            return false;
                        });

                $(".elim").button({
                    icons:{
                        primary:"ui-icon-trash"
                    },
                    text:false
                }).click(function () {
                            $("#dialog-confirm").attr("sid", $(this).attr("id"));
                            $("#dialog-confirm").dialog("open");
//                    deleteRow();
                        });

                var myForm = $(".frmFinanciamiento");

                $(".button").button();

                $(".save").button("option", "icons", {primary:'ui-icon-disk'}).click(function () {
                    myForm.submit();
                    return false;
                });
                $(".back").button("option", "icons", {primary:'ui-icon-arrowthick-1-w'});
                $(".salir").button("option", "icons", {primary:'ui-icon-arrowreturnthick-1-w'});

                $("#selAll").click(function () {
                    $(".sel").attr("checked", $("#selAll").is(":checked"));
                });

                $(".sel").click(function () {
                    var sel = true;
                    $(".sel").each(function () {
                        if ($(this).is(":checked")) {
                            sel = sel & true;
                        } else {
                            sel = sel & false;
                        }
                    });
                    if (sel) {
                        $("#selAll").attr("checked", true);
                    } else {
                        $("#selAll").attr("checked", false);
                    }
                });
            });
        </script>

    </body>
</html>