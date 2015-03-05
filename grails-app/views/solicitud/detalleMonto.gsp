<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 08/01/15
  Time: 04:34 PM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<div style="padding: 5px;" class="alert alert-info">
  <form class="form-group">
    <label>Monto solicitado:</label>
    <div class="input-group input-group-sm">
      <g:textField name="txtMax" class="form-control input-sm number money" style="width: 95px; margin-right: 10px" max="${solicitud.actividad.monto}"
                   value="${g.formatNumber(number: solicitud.montoSolicitado, maxFractionDigits: 2, minFractionDigits: 2)}"/>
      <a href="#" class="btn button btn-success btn-sm" id="btnCambiaMax" style="margin-right: 10px">  Modificar  </a>   <b>(NOTA: Si las asignaciones superan el nuevo máximo serán eliminadas)</b>
    </div>
  </form>
</div>

<div class="alert alert-success">
  <form class="form-group">
    <label>Año: </label>
    <g:select from="${anios}" name="selAnio" optionKey="id" optionValue="anio"/>
    <label>Monto: </label>
    <g:textField name="txtMonto" style="width: 95px;" class="money number"/>
    <a href="#" class="btn button btn-success btn-sm" id="btnAddDetalleMonto"><i class='fa fa-plus'></i></a>
  </form>
</div>

<div class="alert alert-info">
  <form class="form-group">
  <label>Monto máximo a detallar: </label>
  <span id="spanMax" max="${solicitud.montoSolicitado}">
    ${formatNumber(number: solicitud.montoSolicitado, type: "currency" , currencySymbol:" ")}
  </span>
  </form>
</div>

<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaDetalleMonto" width="100%">
  <thead>
  <tr style="background-color: #469DA8">
    <th style="width: 127px;">Año</th>
    <th style="width: 128px;">Monto</th>
    <th style="width: 70px;">Eliminar</th>
  </tr>
  </thead>
  <tbody id="tb">
  <g:set var="total" value="${0}"/>
  <g:each in="${solicitud.detallesMonto}" var="dt">
    <tr class="${dt.anio.anio}" val="${dt.monto}">
      <td>${dt.anio.anio}</td>
      <td class="num">
        <g:formatNumber number="${dt.monto}" type="currency" currencySymbol=""/>
        <g:set var="total" value="${total + dt.monto}"/>
      </td>
      <td style="text-align: center;">
        <a href="#" class="btn btn-danger btn-sm btnDelete"><i class="fa fa-trash-o"></i></a>
      </td>
    </tr>
  </g:each>
  </tbody>
  <tfoot>
  <tr>
    <th>
      TOTAL
    </th>
    <th class="num" id="thTotal">
      <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
    </th>
  </tr>
  <tr>
    <th>
      Restante
    </th>
    <th class="num" id="thResto">
      <g:formatNumber number="${solicitud.montoSolicitado - total}" type="currency" currencySymbol=""/>
    </th>
  </tr>
  </tfoot>
</table>

<script type="text/javascript">

  var maximo = parseFloat($("#spanMax").attr("max"));

  function updateTotal() {
    var total = 0;
    $("#tb").children().each(function () {
      total += parseFloat($(this).attr("val"));
    });
    var resto = maximo - total;
    $("#thTotal").text("$" + number_format(total, 2, ".", ","));
    $("#thResto").text("$" + number_format(resto, 2, ".", ","));
    if (total > maximo) {
      $("#thTotal, #thResto").addClass("alert alert-danger");
    } else {
      $("#thTotal, #thResto").removeClass("alert alert-danger");
    }
    return total;
  }

  function cambiaMax() {
    var val = $("#txtMax").val();
    val = val.replace(new RegExp(",", 'g'), "");
    val = parseFloat(val);

    if (val > maximo || val <= 0) {
      $("#txtMax").val(number_format(maximo, 2, ".", ","));
      log("Por favor ingrese un valor mayor que 0,00 y menor o igual que " + number_format(maximo, 2, ".", ","),'error')
    } else {
      $.ajax({
        type    : "POST",
        url     : "${createLink(action:'cambiarMax')}",
        data    : {
          id    : "${solicitud.id}",
          monto : val
        },
        success : function (msg) {
          var parts = msg.split("_");
          $("#spanError").text(parts[1]);
          if (parts[0] == "NO") {
           log(parts[1],'error')
          } else {
            log(parts[1], 'success');
            maximo = val;
            $("#spanMax").text(number_format(maximo, 2, ".", ",")).attr("max", maximo);
          }
        }
      });
    }
  }

  function addRow() {
    var val = $("#txtMonto").val();
    val = val.replace(new RegExp(",", 'g'), "");
    val = parseFloat(val);

    if (val > maximo || val <= 0) {
      log("Por favor ingrese un valor mayor que 0,00 y menor o igual que " + number_format(maximo, 2, ".", ","),'error')
      $("#txtMonto").val(number_format(maximo, 2, ".", ","));
    } else {
      var anioId = $("#selAnio").val();
      var anio = $("#selAnio option:selected").text();
      var $row = $("<tr>");
      $row.addClass(anio);
      $row.attr("val", val);
      var $tdAnio = $("<td>" + anio + "</td>");
      var $tdMonto = $("<td class='num'>$" + number_format(val, 2, ".", ",") + "</td>");
      var $tdDelete = $("<td style='text-align:center;'></td>");
      var $btnDelete = $("<a href='#' class='btn btn-danger btn-sm btnDelete'><i class='fa fa-trash-o'></i></a>");
      $btnDelete.button({
        icons : {
          primary : "ui-icon-trash"
        },
        text  : false
      }).click(function () {
        removeRow($(this));
      });
      $tdDelete.append($btnDelete);
      $row.append($tdAnio);
      $row.append($tdMonto);
      $row.append($tdDelete);
      var $oldRow = $("#tb").find("." + anio);
      if ($oldRow.length == 0) {
        $("#tb").append($row);
      } else {
        $oldRow.replaceWith($row);
      }
      updateTotal();
    }
  }

  function removeRow($btn) {
    $btn.parents("tr").remove();
    updateTotal();
  }

  $("#btnAddDetalleMonto").button({
    icons : {
      primary : "ui-icon-plusthick"
    },
    text  : false
  }).click(function () {
    addRow();
  });

  $("#btnCambiaMax").button({
    icons : {
      primary : "ui-icon-refresh"
    },
    text  : false
  }).click(function () {
    cambiaMax();
  });

  $(".btnDelete").button({
    icons : {
      primary : "ui-icon-trash"
    },
    text  : false
  }).click(function () {
    removeRow($(this));
  });

  function guardar() {
    var max = $("#spanMax").attr("max");
    max = parseFloat(max);
    var val = $("#txtMonto").val();
    val = val.replace(new RegExp(",", 'g'),'');
    val = parseFloat(val);



    if (val > max || val <= 0) {
      $("#spanError").text("Por favor ingrese un valor mayor que 0,00 y menor o igual que " + number_format(max, 2, ".", ","));
      $("#txtMonto").val(number_format(max, 2, ".", ","));
      $("#divError").show();
    } else {
      $("#divError").hide();
      $.ajax({
        type    : "POST",
        url     : "${createLink(action:'addDetalleMonto')}",
        data    : {
          id    : "${solicitud.id}",
          monto : val,
          anio  : $("#selAnio").val()
        },
        success : function (msg) {
          if (msg == "OK") {
            var anio = $("#selAnio option:selected").text();
            var $row = $("<tr>");
            $row.addClass(anio);
            $row.attr("val", val);
            var $tdAnio = $("<td>" + anio + "</td>");
            var $tdMonto = $("<td class='num'>" + number_format(val, 2, ".", ",") + "</td>");
            $row.append($tdAnio);
            $row.append($tdMonto);
            var $oldRow = $("#tb").find("." + anio);
            if ($oldRow.length == 0) {
              $("#tb").append($row);
            } else {
              $oldRow.replaceWith($row);
            }
            var total = 0;
            $("#tb").children().each(function () {
              total += parseFloat($(this).attr("val"));
            });
            $("#thTotal").text("$" + number_format(total, 2, ".", ","));
            $("#txtMonto").val(0);
            max = parseFloat("${solicitud.montoSolicitado}") - total;
            $("#spanMax").text("$" + number_format(max, 2, ".", ",")).attr("max", max);
          } else {
            var parts = msg.split("_");
            $("#spanError").text(parts[1]);
            $("#divError").show();
          }
        }
      });
    }
  }
</script>