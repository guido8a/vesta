<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 05/03/15
  Time: 01:27 PM
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 19/11/14
  Time: 12:06 PM
--%>


%{--<%@ page contentType="text/html;charset=UTF-8" %>--}%
%{--<html>--}%
%{--<head>--}%
    %{--<meta name="layout" content="main"/>--}%
    %{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'svt.css')}"--}%
          %{--type="text/css"/>--}%
    %{--<title>Cargar avances finan   cieros</title>--}%

    %{--<style type="text/css">--}%
    %{--.colorf {--}%
        %{--color: #ff162a;--}%
    %{--}--}%
    %{--</style>--}%

%{--</head>--}%

%{--<body>--}%
%{--<g:if test="${flash.message}">--}%
    %{--<div class="message ui-state-highlight ui-corner-all">${flash.message}</div>--}%
%{--</g:if>--}%
%{--<fieldset style="width: 800px; margin-bottom:5px; margin-top:10px; " class="ui-corner-all ui-widget-content">--}%
    %{--<legend>Cargar avances financieros</legend>--}%
    <g:form name="frmUpload" enctype="multipart/form-data" method="post" action="subirExcelHitos" >
        <g:hiddenField name="id" value="${idAval}"/>
        <div class="container ui-corner-all" style="min-height: 100px; width: 600px;">
            <b>Archivo Excel:</b>  <input type="file" class="ui-corner-all" name="file" id="file" size="70"/>
        </div>
        %{--<div style="margin-bottom: 10px">--}%
            %{--<a href="#" id="btnUpload">Cargar archivo excel</a>--}%
        %{--</div>--}%
    </g:form>
%{--</fieldset>--}%
%{--<g:if test="${flash.message}">--}%
    %{--<div class="message ui-state-highlight ui-corner-all">${msg}</div>--}%
%{--</g:if>--}%
<div class="alert alert-danger">
    * El archivo a cargar solo puede ser de tipo XLS
</div>

%{--<script type="text/javascript">--}%
    %{--$(function () {--}%
        %{--$("#btnUpload").button().click(function () {--}%
            %{--$("#frmUpload").submit();--}%
        %{--});--}%
    %{--});--}%
%{--</script>--}%

%{--</body>--}%
%{--</html>--}%