<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 27/02/15
  Time: 02:53 PM
--%>

<g:uploadForm id="${reunion.id}" name="frmPdf" controller="solicitud" action="uploadActa">
    <div class="row">
        <div class="col-md-4" style="width: 220px">
            Selecccione el archivo a subir

        </div>
    </div>
    <div class="row">

        <div class="col-md-1" style="width: 50px">
            <label>
                Acta:
            </label>
        </div>
        <div class="col-md-4" style="height: 30px">
            <input type="file" name="pdf" class="required"/>

        </div>
    </div>
    <div class="row">
        <div class="col-md-6" style="width: 350px; color: #ff851a">
        <g:if test="${reunion.pathPdf}">
            <b> * Archivo cargado actualmente: ${reunion.pathPdf}</b>
        </g:if>
        </div>
    </div>
</g:uploadForm>