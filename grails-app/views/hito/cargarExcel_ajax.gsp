<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 19/11/14
  Time: 12:06 PM
--%>


<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">${flash.message}</div>
</g:if>
<fieldset style="margin-bottom:5px; margin-top:10px; " class="ui-corner-all ui-widget-content">
    %{--<legend>Cargar avances financieros</legend>--}%
    <g:form name="frmUpload" enctype="multipart/form-data" method="post" action="subirExcelHitos">
        <div class="container ui-corner-all" style="min-height: 100px; width: 500px">
            <b>Archivo Excel:</b>  <input type="file" class="ui-corner-all" name="file" id="file" size="70"/>
        </div>
        %{--<div style="margin-bottom: 10px">--}%
            %{--<a href="#" id="btnUpload">Cargar archivo excel</a>--}%
        %{--</div>--}%
    </g:form>
</fieldset>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">${msg}</div>
</g:if>
<div class="alert-danger">
    * El archivo a cargar solo puede ser de tipo XLS
</div>

%{--<script type="text/javascript">--}%
    %{--$(function () {--}%
        %{--$("#btnUpload").button().click(function () {--}%
            %{--$("#frmUpload").submit();--}%
        %{--});--}%
    %{--});--}%
%{--</script>--}%

