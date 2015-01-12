<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Aprobar proyecto</title>
</head>
<body>
<fieldset style="width: 990px;height: 55px;padding: 5px;" class="ui-corner-all">
    <legend>Busqueda</legend>
    <input type="text" id="txt_buscar" style="width: 200px;" class="ui-corner-all" value="${parametro}">
    <a href="#" id="buscar" >Buscar</a>
</fieldset>
<div class="list" style="width: 1000px;margin-top: 20px;margin-bottom: 20px;">
    <table style="width:1000px;">
        <thead>
        <tr>
            <tdn:sortableColumn property="nombre" class="ui-state-default sortable" title="Nombre" style="width: 200px;" />
            <tdn:sortableColumn property="codigoProyecto" class="ui-state-default sortable" title="Código" />
            <tdn:sortableColumn property="monto" class="ui-state-default sortable" title="Monto" />
            <th class="ui-state-default">Estado</th>
            <th class="ui-state-default" >Datos</th>
            <th class="ui-state-default" >Marco lógico</th>
            <th class="ui-state-default" >Cronograma</th>
            <th class="ui-state-default">Aprobar</th>

        </tr>
        </thead>
        <tbody>
        <g:each in="${proyectos}" status="i" var="proy">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                <td style="width: 200px;">${proy.nombre}</td>
                <td>${proy.codigoProyecto}</td>
                %{--<td><g:formatNumber number="${proy.monto}" locale="ec"/></td>--}%
                <td style="text-align: right"><g:formatNumber number="${proy.monto.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td>${proy.estadoProyecto}</td>
                <td style="text-align: center;"><g:link action="show" controller="proyecto" id="${proy.id}" target="_blank" class="btn">Ver</g:link></td>
                <td style="text-align: center;"><g:link controller="marcoLogico" action="verMarcoCompleto" id="${proy.id}" target="_blank" class="btn">Ver</g:link></td>
                <td style="text-align: center;"><g:link controller="cronograma" action="verCronograma" id="${proy.id}" target="_blank" class="btn">Ver</g:link></td>
                <td style="text-align: center;">
                    <g:if test="${proy?.aprobado!='a'}">
                        <a href="#" class="btn aprobar" proy="${proy.id}">Aprobar</a>
                    </g:if><g:else>
                        Aprobado
                    </g:else>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>
<div class="fg-toolbar ui-toolbar ui-widget-header ui-corner-bottom ui-helper-clearfix paginateButtons" style="width: 1000px;">
    <tdn:paginate total="${total}" />
</div>
<div id="aprob">
    <input type="hidden" id="iden">
    Ingrese su clave de aprobación <br>
    <input type="password" id="pass">
</div>
<script type="text/javascript">
    $(".btn").button()
    $("#buscar").button().click(function(){
        window.location.href="${createLink(action:'listaAprobarProyecto')}/?parametro="+$("#txt_buscar").val()
    });
    $(".sortable").click(function(){

        $(this).child().attr("href",$(this).child().attr("href")+"&parametro="+$("#txt_buscar").val())


    });
    $(".aprobar").click(function(){
        $("#pass").val("")
        $("#iden").val($(this).attr("proy"))
        $("#aprob").dialog("open")
    });
    $("#aprob").dialog({
        autoOpen:false,
        modal:true,
        position:"center",
        width:250,
        height:150,
        title:"Aprobación",
        resizable:false,
        buttons:{
            "Aprobar":function(){
                $.ajax({
                    type: "POST",
                    url: "${createLink(action:'aprobarProyecto')}",
                    data: {
                        ssap:$("#pass").val(),
                        proy:$("#iden").val()
                    },
                    success: function(msg) {
                        if(msg!="no"){
                            alert("Proyecto aprobado")
                            window.location.href="${createLink(action:'listaAprobarProyecto')}/?parametro="+$("#txt_buscar").val()

                        }else{
                            alert("Clave no valida")
                        }
                    }
                });
            }
        }
    });
</script>
</body>
</html>